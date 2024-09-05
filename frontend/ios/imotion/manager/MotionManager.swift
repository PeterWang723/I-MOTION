//
//  AccManager.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/1.
//
import Foundation
import CoreMotion
import UIKit

class MotionManager: ObservableObject {
    private var motionManager: CMMotionManager
    var acceleration: CMAcceleration?
    var accelerationData: [(timestamp: Date, data: [CMAcceleration])] = []  // List to store 100 data points per second with timestamp
    private var currentDataBatch: [CMAcceleration] = []  // Current batch of data points
    private var timer: Timer?
    private var finished = false
    var privacy_level: String = "HIGH"
    
    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 1.0 / 100.0  // 100 Hz
    }
    
    func setupTimer() {
            // Invalidate old timer if any
            timer?.invalidate()
            
            // Setup a new timer
            timer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(checkTimeAndToggleAccelerometer), userInfo: nil, repeats: false)
    }
        
    @objc private func checkTimeAndToggleAccelerometer() {
        print("motionManager starts \(self.finished)")
        UIDevice.current.isBatteryMonitoringEnabled = true
        let isCharging = UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full
        let currentTime = Calendar.current.dateComponents([.hour], from: Date())
        guard let hour = currentTime.hour else { return }
        var netWorkMonitor: NetworkMonitor? = nil
        if UserDefaults.standard.bool(forKey: "WifiOnly") {
            netWorkMonitor = NetworkMonitor()
        }
        //hour >= 15 || hour < 9
        if hour >= 13 || hour < 10{
            stopAccelerometerUpdates()
            if !self.finished {
                print("send and infer acss has starts")
                if self.privacy_level != "LOW"{
                    print("isCharing = \(isCharging)")
                    if isCharging {
                        Task {
                            let done = try await MLManager.shared.infer()
                            if done {
                                self.finished = true
                            }
                        }
                    }
                } else {
                    if netWorkMonitor != nil {
                        netWorkMonitor!.checkWiFiConnection { isConnected in
                            if isConnected {
                                Task{
                                    let token = JWTKeyChain.shared.retrieveJWT(forKey: "com.app.jwt")
                                    print("prediction step starts")
                                    let accs = try await StorageManager.shared.getAcc()
                                    var accelerations:[Acceleration] = []
                                    for acc in accs {
                                        let temp = acc.data.map { acceleration in
                                            Acceleration(time: acc.timestamp, x: acceleration.x, y: acceleration.y, z: acceleration.z)
                                        }
                                        accelerations.append(contentsOf: temp)
                                    }
                                    print("accs count for ML is \(accelerations.count)")
                                    do {
                                        print("send_accs starts")
                                        let done = try await NetworkManager.shared.send_accs(token: token!["jwt"]!!, accs:accelerations)
                                        print("send_accs finish")
                                        print("prediction starts")
                                        _ = try await NetworkManager.shared.predict(token: token!["jwt"]!!, accs: accs)
                                        if done {
                                            self.finished=true
                                            try await StorageManager.shared.deleteAccelerometer()
                                        } else {
                                            self.finished = false
                                        }
                                        print("prediction finished")
                                    } catch {
                                        // Handle the error appropriately
                                        print("Failed to fetch locations: \(error)")
                                        self.finished = false
                                    }
                                }
                            }
                        }
                    } else {
                        Task{
                            let token = JWTKeyChain.shared.retrieveJWT(forKey: "com.app.jwt")
                            print("prediction starts")
                            let accs = try await StorageManager.shared.getAcc()
                            var accelerations:[Acceleration] = []
                            for acc in accs {
                                let temp = acc.data.map { acceleration in
                                    Acceleration(time: acc.timestamp, x: acceleration.x, y: acceleration.y, z: acceleration.z)
                                }
                                accelerations.append(contentsOf: temp)
                            }
                            print("accs count for ML is \(accelerations.count)")
                            do {
                                let done = try await NetworkManager.shared.send_accs(token: token!["jwt"]!!, accs:accelerations)
                                _ = try await NetworkManager.shared.predict(token: token!["jwt"]!!, accs: accs)
                                if done {self.finished=true} else {self.finished = false}
                            } catch {
                                // Handle the error appropriately
                                print("Failed to fetch locations: \(error)")
                                self.finished = false
                            }
                            print("prediction finished")
                        }
                    }
                }
            }
        } else {
            startAccelerometerUpdates()
        }
    }
    
    func startAccelerometerUpdates() {
        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.startAccelerometerUpdates(to:OperationQueue.main) { [weak self] (data, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                guard let self = self else { return }
                if let data = data {
                    self.currentDataBatch.append(data.acceleration)
                    if self.currentDataBatch.count == 100 {
                        let timestamp = Date()
                        let storedData = self.currentDataBatch
                        Task {
                            try await StorageManager.shared.storeAcc(timestamp: timestamp, data: storedData)
                        }
                        self.currentDataBatch.removeAll()
                    }
                }
            }
        } else {
            print("Accelerometer is not available on this device.")
        }
    }
    
    func stopAccelerometerUpdates() {
        if self.motionManager.isAccelerometerActive {
            self.motionManager.stopAccelerometerUpdates()
            print("Stopped accelerometer updates.")
        }
    }
}
