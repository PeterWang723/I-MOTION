//
//  Activity.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/24.
//

import Foundation
import SwiftData


@Model
final class Activity_Storage {
    var id: String
    var mode: String
    var day: Date
    var start_time: Date
    var end_time: Date
    var distance: Double
    var origin: String
    var destination: String
    var purpose: [Purpose]?
    
    init(mode: String, day: Date, start_time: Date, end_time: Date, distance:Double, origin: String, destination: String, purpose:[Purpose]?) {
        self.id = UUID().uuidString
        self.mode = mode
        self.day = day
        self.start_time = start_time
        self.end_time = end_time
        self.distance = distance
        self.origin = origin
        self.destination = destination
        self.purpose = purpose
    }
}
