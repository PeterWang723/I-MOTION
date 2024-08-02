//
//  LoginPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/19.
//

import SwiftUI

struct LoginPage: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var loginviewModel = LoginViewModel()
    @State private var userName: String = ""
    @State private var password: String = ""
    var body: some View {
        Text("I - M O T I O N")
            .font(Font.custom("ImperialSansDisplay-Bold", size: 36))
            .fontWeight(.bold)
            .foregroundColor(.primaryColor)
        VStack{
            VStack(alignment: .leading){
                Text("EMAIL")
                    .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.primaryColor)
                
                TextField(
                    "",
                    text: $userName
                )
                .autocorrectionDisabled()
                .frame(width: 320.0, height: 40.0)
                .textFieldStyle(BlackBorder())
                
                Text("PASSWORD")
                    .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.primaryColor)
                
                SecureField(
                    "",
                    text: $password
                )
                .autocorrectionDisabled()
                .frame(width: 320.0, height: 40.0)
                .textFieldStyle(BlackBorder())
            }
            .padding(.bottom, 100)
            
            Button(action: {
                if userName != "" && password != "" {
                    Task {
                        await loginviewModel.loginUser(username: userName, password: password)
                        let token = JWTKeyChain.shared.retrieveJWT(forKey: "com.app.jwt")
                        if token != nil {
                            appState.user_token = token!["jwt"]!!
                            print("appState.user_token: \(appState.user_token)")
                            appState.privacy = token!["privacyLevel"]!!
                            print("appState.privacy: \(appState.privacy)")
                            print(appState.privacy)
                            if token!["houseHold"] != "" {
                                appState.houseHold = token!["houseHold"]!!
                                appState.skipSurvey = true
                            }
                            appState.isLoggedIn = false
                            appState.isSuccessfulLoggedIn = true
                        } else {
                            print("No token found")
                        }
                    }
                }
            }) {
                Text("LOGIN")
                    .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 320, height:40)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 5,
                            style: .continuous
                        )
                        .fill(Color(red: 0.0, green: 0.0, blue: 1))
                    )
            }
        }
        .padding(.top, 50)
    }
}

