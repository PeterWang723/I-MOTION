//
//  SurveyButton.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/20.
//

import SwiftUI

struct SurveyButton: View {
    let title: String
    @Binding var selection: String

    var body: some View {
        Button(action: {
            selection = title
        }) {
            Text(title)
                .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                .padding()
                .frame(maxWidth: .infinity)
                .background(selection == title ? .primaryColor : Color.white)
                .foregroundColor(selection == title ? Color.white : Color.black)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
        }
    }
}
