//
//  Token.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/18.
//

import Foundation
import SwiftData

@Model
final class Token {
    var id: String
    var token: String
    
    init(token:String) {
        self.id = UUID().uuidString
        self.token = token
    }
}
