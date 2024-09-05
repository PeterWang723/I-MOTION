//
//  globalVariable.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/19.
//
import Foundation

class AppState: ObservableObject {
    static let shared = AppState() // Singleton instance
    @Published var isActive: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var isRegistered: Bool = false
    @Published var skipSurvey: Bool = false
    @Published var isSuccessfulLoggedIn: Bool = false
    @Published var user_token: String = ""
    @Published var privacy = ""
    @Published var enable_face_id: Bool = false
    @Published var houseHold = ""
}
