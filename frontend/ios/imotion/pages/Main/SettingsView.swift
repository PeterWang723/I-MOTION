//
//  SettingsView.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var onlyTransferDataInWiFi = true
    @State private var faceIDEnabled = UserDefaults.standard.bool(forKey: "faceIDEnabled")
    var body: some View {
        NavigationView {
            List {
                // Profile
                NavigationLink(destination: Text("Profile Settings")) {
                    SettingsRow(title: "Profile")
                }
                
                // Third App Support
                NavigationLink(destination: Text("Third App Support Settings")) {
                    SettingsRow(title: "Third App Support")
                }
                
                // Only Transfer Data in WIFI
                Toggle("Only Transfer Data in WIFI", isOn: $onlyTransferDataInWiFi)
                    .toggleStyle(SwitchToggleStyle(tint: .primaryColor))
                    .onChange(of: onlyTransferDataInWiFi){oldValue, newValue in
                        UserDefaults.standard.set(newValue, forKey: "WifiOnly")
                    }
                
                // FAQ
                Link(destination: URL(string: "https://www.jumpstart-uk.com/faqs/")!) {
                                    SettingsRow(title: "FAQ")
                }
                
                // Contact
                NavigationLink(destination: Text("Contact Info")) {
                    SettingsRow(title: "Contact")
                }
                
                // FaceID
                Toggle("FaceID", isOn: $faceIDEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .primaryColor))
                    .onChange(of: faceIDEnabled) { oldValue, newValue in
                        UserDefaults.standard.set(newValue, forKey: "faceIDEnabled")
                    }
                                
                Button(action: {
                    JWTKeyChain.shared.delete(forKey: "com.app.jwt")
                    UserDefaults.standard.set(false, forKey: "faceIDEnabled")
                    UserDefaults.standard.set(true, forKey: "WifiOnly")
                    do {
                        try StorageManager.shared.logout()
                        withAnimation{
                            appState.isLoggedIn = false
                            appState.isRegistered = false
                            appState.isSuccessfulLoggedIn = false
                            appState.skipSurvey = false
                        }
                    } catch {
                        print("there is a error")
                    }
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                }
            
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsRow: View {
    var title: String

    var body: some View {
        HStack {
            Text(title)
        }
    }
}

#Preview {
    SettingsView()
}
