//
//  SurveyPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/29.
//

import SwiftUI

struct SurveyPage: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(1..<6) { index in
                        NavigationLink(destination: SurveyDetailView(surveyID: "Survey \(index)")) {
                            SurveyBlock(title: "New Survey", description: "This is a short description for this new survey")
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Surveys")
        }
    }
}

struct SurveyBlock: View {
    var title: String
    var description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primaryColor)

            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
                .cornerRadius(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

struct SurveyDetailView: View {
    var surveyID: String

    var body: some View {
        Text("Details for \(surveyID)")
            .navigationTitle(surveyID)
    }
}



#Preview {
    SurveyPage()
}
