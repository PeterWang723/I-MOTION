//
//  RegistrationComponent.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/20.
//

import SwiftUI

struct RegistrationComponent: View {
    @EnvironmentObject var appState: AppState
    @State private var isSurveyFinished: Bool = false
    @State private var privacyLevel: String = ""
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var r_password: String = ""
    var body: some View {
        if isSurveyFinished{
            RegistrationPage(userName: $userName, password: $password, r_password: $r_password, privacy: $privacyLevel, isSurveyFinished: $isSurveyFinished)
        } else {
            PrivacyPage(privacy_level: $privacyLevel, isSurveyFinished: $isSurveyFinished)
        }
    }
}

#Preview {
    RegistrationComponent()
}
