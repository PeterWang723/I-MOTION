//
//  SurveyIntroPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/20.
//

import SwiftUI

struct SurveyIntroPage: View {
    @Binding var process: Int
    var body: some View {
        Text("SURVEY")
            .font(Font.custom("ImperialSansDisplay-Bold", size: 36))
            .fontWeight(.bold)
            .foregroundColor(.primaryColor)
            .padding(.bottom, 30)
        Text("Before we start, Please finish this survey to help us learn you better. About 5 minutes")
            .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
            .fontWeight(.bold)
            .padding(.top, 40)
            .padding(.horizontal, 50)
            .padding(.bottom, 150.0)
        Button(action: {process = process + 1}) {
            Text("START")
                .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 320, height:40)
                .background(
                    RoundedRectangle(
                        cornerRadius: 5,
                        style: .continuous
                    )
                    .fill(Color(red: 0.0, green: 0.0, blue: 180))
                )
        }
        .padding(.bottom, 10)
    }
}
