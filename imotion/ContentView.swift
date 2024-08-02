//
//  ContentView.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/14.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        if !appState.isLoggedIn && !appState.isRegistered && !appState.isSuccessfulLoggedIn{
            StartPage()
        } else if appState.isLoggedIn{
            LoginPage()
        } else if appState.isRegistered{
            RegistrationComponent()
        } else if appState.isSuccessfulLoggedIn && !appState.skipSurvey{
            SurveyComponent()
        } else if appState.isSuccessfulLoggedIn && appState.skipSurvey {
            HomePage()
        }
    }
}

