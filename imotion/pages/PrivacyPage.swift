//
//  SurveyPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/19.
//

import SwiftUI

struct PrivacyPage: View {
    @Binding var privacy_level: String
    @Binding var isSurveyFinished: Bool
    var body: some View {
            Text("PRIVACY LEVEL")
                .font(Font.custom("ImperialSansDisplay-Bold", size: 36))
                .fontWeight(.bold)
                .foregroundColor(.primaryColor)
        
            Text("Choose your preferred privacy level to make you feel good!")
                .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                .font(Font.custom("ImperialSansDisplay-Bold", size: 36))
                .padding(.top, 40)
                .padding(.horizontal, 50)
        
            VStack{
                Button(action: {privacy_level="LOW"; isSurveyFinished=true}) {
                    Text("SELF USE")
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
                .padding(.bottom, 40)
                
                
                Button(action: {privacy_level="HIGH"; isSurveyFinished=true}) {
                    Text("RESEARCH")
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
            .padding(.top, 40)
    }
}
