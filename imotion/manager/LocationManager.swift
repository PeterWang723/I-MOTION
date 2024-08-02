//
//  LocationManager.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/21.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120)
                                               , span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    var locationManager = CLLocationManager()
    private var timer: Timer?
    private var finished: Bool = false
    var privacy_level: String = "HIGH"
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.showsBackgroundLocationIndicator = true
        self.locationManager.distanceFilter = 10
        self.locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func setupTimer() {
            // Invalidate old timer if any
            timer?.invalidate()
            
            // Setup a new timer
            timer = Timer.scheduledTimer(timeInterval: 1800, target: self, selector: #selector(checkTimeAndToggleAccelerometer), userInfo: nil, repeats: true)
    }
        
    @objc private func checkTimeAndToggleAccelerometer() {
        print("location timer starts")
        let currentTime = Calendar.current.dateComponents([.hour], from: Date())
        guard let hour = currentTime.hour else { return }
        var netWorkMonitor: NetworkMonitor_L? = nil
        if UserDefaults.standard.bool(forKey: "WifiOnly") {
            netWorkMonitor = NetworkMonitor_L()
        }
        //hour >= 18 || hour < 9
        if hour >= 15 || hour < 9 {  
            self.locationManager.stopUpdatingLocation()
            if !self.finished {
                print("send location now")
                if self.privacy_level == "LOW" {
                    if netWorkMonitor != nil {
                        netWorkMonitor!.checkWiFiConnection { isConnected in
                            print("isConnected is \(isConnected)")
                            if isConnected {
                                Task{
                                    let token = JWTKeyChain.shared.retrieveJWT(forKey: "com.app.jwt")
                                    print("send location starts")
                                    let locations = try await StorageManager.shared.getLocations()
                                    print("Location counts are \(locations.count)")
                                    do {
                                        let done = try await NetworkManager.shared.send_location(token: token!["jwt"]!!, locations: locations)
                                        if done {self.finished=true} else {self.finished=false}
                                    } catch {
                                        // Handle the error appropriately
                                        self.finished = false
                                        print("Failed to fetch locations: \(error)")
                                    }
                                    print("finish sending location")
                                }
                            }
                        }
                    } else {
                        Task{
                            let token = JWTKeyChain.shared.retrieveJWT(forKey: "com.app.jwt")
                            print("send location starts")
                            let locations = try await StorageManager.shared.getLocations()
                            print("Location counts are \(locations.count)")
                            do {
                                let done = try await NetworkManager.shared.send_location(token: token!["jwt"]!!, locations: locations)
                                if done {self.finished=true} else {self.finished=false}
                            } catch {
                                // Handle the error appropriately
                                self.finished = false
                                print("Failed to fetch locations: \(error)")
                            }
                            print("finish sending location")
                        }
                    }
                } else {
                    self.finished = true
                }
            }
        } else {  // Check if it's 6:00 AM
            self.locationManager.startUpdatingLocation()
        }
    }
    
    @MainActor func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task {
            try await StorageManager.shared.storeLocation(location: location)
        }
    }

}

