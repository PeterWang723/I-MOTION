//
//  Trip.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/21.
//

import Foundation
import SwiftUI

struct Trip: Identifiable {
    let id = UUID()
    var icon: String
    var color: Color
    var type: String
    var distance: String
    var start: String
    var end: String
    var duration: String
    var time: String
}

