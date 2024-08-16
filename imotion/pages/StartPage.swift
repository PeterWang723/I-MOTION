//
//  StartPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/27.
//

import SwiftUI

struct StartPage: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
            Text("I - M O T I O N")
                .font(Font.custom("ImperialSansDisplay-Bold", size: 36))
                .fontWeight(.bold)
                .foregroundColor(.primaryColor)
                .padding(.bottom, 150.0)
            VStack{
                Button(action: {appState.isRegistered = true}) {
                    Text("REGISTER NOW")
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
                .padding(.bottom, 10)
                Button(action: {appState.isLoggedIn = true}) {
                    Text("LOGIN")
                        .foregroundColor(.primaryColor)
                        .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 320, height:40)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 5,
                                style: .continuous
                            )
                            .fill(.white)
                            .stroke(Color(red: 0.0, green: 0.0, blue: 1), lineWidth: 1)
                        )
                }
            }
            .padding(.top, 150)
    }
}
