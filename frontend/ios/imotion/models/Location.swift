//
//  Location.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/14.
//

import Foundation
import SwiftData

@Model
final class Location {
    var id: String
    var timestamp: Date
    var latitude: Double
    var longitude: Double
    
    init(timestamp: Date, latitude: Double, longitude: Double) {
        self.id = UUID().uuidString
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
    }
}
