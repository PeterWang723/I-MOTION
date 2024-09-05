//
//  LoginRegisterController.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/19.
//

import Foundation

class LoginViewModel: ObservableObject {
    var errorMessage: String?
    var token: String = ""
    var privacyL: String = ""
    var houseHold: String? = ""
    var message: String = ""
    var status: Int = 0
    private let tokenKey = "com.app.jwt"
    
    func loginUser(username: String, password: String) async {
        do {
            let response = try await NetworkManager.shared.login(username: username, password: password)
            token = response.data[0]!
            privacyL = response.data[1]!
            let response_survey = try await NetworkManager.shared.get_survey(token: token)
            print("response_survey: \(response_survey)")
            if response_survey {
                houseHold = "household"
            }
            message = response.message
            status = response.status
            print(privacyL)
            JWTKeyChain.shared.save(jwt: token, privacyL:privacyL, houseHold:houseHold, forKey: tokenKey)
        } catch {
            await updateErrorMessage(with: error.localizedDescription)
        }
    }
    
    @MainActor func updateErrorMessage(with message: String) {
            errorMessage = message
        }
}
