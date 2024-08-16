//
//  Accelerometer.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/18.
//

import Foundation
import SwiftData
import CoreMotion

@Model
final class Accelerometer {
    var id: String
    var timestamp: Date
    var data: [AccelerationData]
    
    init(timestamp: Date, data:[CMAcceleration]) {
        self.id = UUID().uuidString
        self.timestamp = timestamp
        self.data = data.map({ acc in
            AccelerationData(x:acc.x,y:acc.y,z:acc.z)
        })
    }
}

struct AccelerationData: Codable, Hashable{
    var x: Double
    var y: Double
    var z: Double
}
