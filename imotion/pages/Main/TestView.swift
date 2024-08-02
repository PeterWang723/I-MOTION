//
//  TestView.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/1.
//

import SwiftUI
import CoreMotion

class CMotionManager: ObservableObject {
    private var motionManager: CMMotionManager
        @Published var acceleration: CMAcceleration?
        @Published var accelerationData: [(timestamp: Date, data: [CMAcceleration])] = []  // List to store 100 data points per second with timestamp
        private var currentDataBatch: [CMAcceleration] = []  // Current batch of data points
        
        init() {
            self.motionManager = CMMotionManager()
            self.motionManager.accelerometerUpdateInterval = 1.0 / 100.0  // 100 Hz
            startAccelerometerUpdates()  // Start updates immediately upon initialization
        }
        
        func startAccelerometerUpdates() {
            if self.motionManager.isAccelerometerAvailable {
                print("Accelerometer is available.")
                self.motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                    guard let self = self else { return }
                    if let data = data {
                        DispatchQueue.main.async {
                            self.acceleration = data.acceleration
                            self.currentDataBatch.append(data.acceleration)
                            if self.currentDataBatch.count == 100 {
                                let timestamp = Date()
                                self.accelerationData.append((timestamp: timestamp, data: self.currentDataBatch))
                                self.currentDataBatch = []
                            }
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


struct TestView: View {
    @StateObject private var motionManager = CMotionManager()
    
    var body: some View {
            VStack {
                if let acceleration = motionManager.acceleration {
                    Text("Current Acceleration")
                    Text("X: \(acceleration.x)")
                    Text("Y: \(acceleration.y)")
                    Text("Z: \(acceleration.z)")
                } else {
                    Text("No data")
                }
                if let latestData = motionManager.accelerationData.last {
                    VStack(alignment: .leading) {
                        Text("Timestamp: \(latestData.timestamp)")
                            .font(.headline)
                    }
                }
            }
            .onAppear {
                motionManager.startAccelerometerUpdates()
                print("ContentView appeared, starting accelerometer updates.")
            }
    }
}

#Preview {
    TestView()
}
