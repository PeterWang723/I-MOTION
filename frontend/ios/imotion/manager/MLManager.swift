//
//  MLManager.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/24.
//

import Foundation
import CoreML

class MLManager {
    static let shared = MLManager()
    
    func processActivities(allAccDates: [Date], modes: [Int]) throws -> [Activity_Storage] {
        guard !allAccDates.isEmpty, !modes.isEmpty, allAccDates.count == modes.count else {
            throw NSError(domain: "DataError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Dates and modes lists must be of the same length and non-empty"])
        }
        
        var processedActivities: [Activity_Storage] = []
        var current_mode: Int? = nil
        var current_start: Date? = nil
        var current_end: Date? = nil
        
        for (date, mode) in zip(allAccDates, modes) {
            if mode != current_mode {
                if current_mode != nil {
                    processedActivities.append(Activity_Storage(mode: TransportMode(rawValue: current_mode!)!.description(), day: current_start!.startOfDay, start_time: current_start!, end_time: current_end!, distance: 0, origin: "Unknown", destination: "Unknown", purpose: nil))
                }
                current_mode = mode
                current_start = date
                current_end = date
            } else {
                current_end = date
            }
        }
        
        if let unwrappedMode = current_mode, let start = current_start, let end = current_end {
            processedActivities.append(Activity_Storage(mode: "\(unwrappedMode)", day: start, start_time: start, end_time: end, distance: 0, origin: "Unknown", destination: "Unknown", purpose: nil))
        }
        
        return processedActivities
    }
    
    func infer() async throws -> Bool {
        do {
            let accs = try await StorageManager.shared.getAcc()
            let sortedData = accs.sorted { $0.timestamp < $1.timestamp }
            var allAccDates: [Date] = []
            var allAccItems: [AccelerationData] = []
            
            for accelerometer in sortedData {
                allAccDates.append(accelerometer.timestamp)
                allAccItems.append(contentsOf: accelerometer.data)
            }
            
            let chunkSize = 600
            let jumpSize = 100
            
            var accItemChunks: [[AccelerationData]] = []
            var i = 0
            while i < allAccItems.count - chunkSize + 1 {
                let chunk = Array(allAccItems[i..<i + chunkSize])
                accItemChunks.append(chunk)
                i += jumpSize
            }
            
            var processedChunks: [[Float]] = []
            for accItemChunk in accItemChunks {
                let processedData = accItemChunk.map { accelerationData in
                    Float(sqrt(accelerationData.x * accelerationData.x + accelerationData.y * accelerationData.y + accelerationData.z * accelerationData.z))
                    }
                processedChunks.append(processedData)
            }
            
            let model:IMOTION_mode = try IMOTION_mode(configuration: MLModelConfiguration())
            var results:[Int] = []
            
            for processedChunk in processedChunks {
                guard let mlArray = try? MLMultiArray(shape: [1, 600], dataType: .float32) else {
                    throw NSError(domain: "MLManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to create MLMultiArray"])
                }
                
                for (index, value) in processedChunk.enumerated() {
                        mlArray[index] = NSNumber(value: value)
                }
                
                //let input = IMOTION_modeInput(x_1: mlArray)
                //let output = try await model.prediction(input: input)
                //let maxIndex = output.linear_13.indexOfMax()
                //results.append(maxIndex)
            }
            
            print("results count are:\(results.count)")
            print("allAccDates are:\(allAccDates.count)")
            for _ in 0..<5 {
                results.append(results[results.count - 1])
            }
            
            
            let activities = try processActivities(allAccDates: allAccDates, modes: results)
            try await StorageManager.shared.storeActivities(data: activities)
            
            return true

        }catch{
            fatalError("Failed to fetch the accs: \(error)")
        }
    }
}

extension MLMultiArray {
    func indexOfMax() -> Int {
        var maxIndex = 0
        var maxNumber = self[0].floatValue
        for i in 1..<self.count {
            let value = self[i].floatValue
            if value > maxNumber {
                maxNumber = value
                maxIndex = i
            }
        }
        return maxIndex
    }
}

enum TransportMode: Int {
    case still = 0
    case walk = 1
    case run = 2
    case bike = 3
    case car = 4
    case bus = 5
    case train = 6
    case subway = 7
    case e_bike = 8
    case e_car = 9

    func description() -> String {
        switch self {
        case .still:
            return "Still"
        case .walk:
            return "Walk"
        case .run:
            return "Run"
        case .bike:
            return "Bike"
        case .car:
            return "Car"
        case .bus:
            return "Bus"
        case .train:
            return "Train"
        case .subway:
            return "Subway"
        case .e_bike:
            return "e-Bike"
        case .e_car:
            return "e-Car"
        }
    }
    
    static func rawValue(fromDescription description: String) -> Int? {
            switch description {
            case "Still":
                return TransportMode.still.rawValue
            case "Walk":
                return TransportMode.walk.rawValue
            case "Run":
                return TransportMode.run.rawValue
            case "Bike":
                return TransportMode.bike.rawValue
            case "Car":
                return TransportMode.car.rawValue
            case "Bus":
                return TransportMode.bus.rawValue
            case "Train":
                return TransportMode.train.rawValue
            case "Subway":
                return TransportMode.subway.rawValue
            case "e-Bike":
                return TransportMode.e_bike.rawValue
            case "e-Car":
                return TransportMode.e_car.rawValue
            default:
                return nil
            }
    }
}

