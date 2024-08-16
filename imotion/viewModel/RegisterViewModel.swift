//
//  RegisterViewModel.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/19.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var token: String?
    
    func registerUser(username: String, password: String, privacy: String) async -> Bool{
        print("start to register user")
        let response = (try? await NetworkManager.shared.register(username: username, password: password, privacyLevel: privacy)) ?? false
        return response
    }
}
