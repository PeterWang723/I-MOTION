//
//  SurveyFirstPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/20.
//

import SwiftUI

struct SurveyFirstPage: View {
    @Binding var process: Int
    @Binding var email: String
    @Binding var phone: String
    @Binding var age: String
    @Binding var selectedGender: String
    @Binding var selectedMaritalStatus: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Questions 1/3")
                .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            HStack {
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(.primaryColor)
                    .cornerRadius(2)
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(.gray)
                    .cornerRadius(2)
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(.gray)
                    .cornerRadius(2)
            }
            .padding(.horizontal)
            
            Text("Personal Information")
                .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                .bold()
                .foregroundColor(.primaryColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top])
            
            ScrollView() {
                Group {
                    VStack(alignment: .leading) {
                        Text("Email")
                            .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                        TextField("", text: $email)
                            .textFieldStyle(BlackBorder())
                    }
                    .padding([.leading, .trailing])
                    
                    VStack(alignment: .leading) {
                        Text("Phone")
                            .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                        TextField("", text: $phone)
                            .textFieldStyle(BlackBorder())
                    }
                    .padding([.leading, .trailing])
                    
                    VStack(alignment: .leading) {
                        Text("Age")
                            .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                        TextField("", text: $age)
                            .textFieldStyle(BlackBorder())
                    }
                    .padding([.leading, .trailing])
                }
                
                VStack(alignment: .leading) {
                    Text("Gender")
                        .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                    
                    HStack {
                        SurveyButton(title: "Male", selection: $selectedGender)
                        SurveyButton(title: "Female", selection: $selectedGender)
                        SurveyButton(title: "Others", selection: $selectedGender)
                    }
                }
                .padding([.leading, .trailing])
                
                VStack(alignment: .leading) {
                    Text("Marital Status")
                        .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                    HStack {
                        SurveyButton(title: "Single", selection: $selectedMaritalStatus)
                        SurveyButton(title: "Married", selection: $selectedMaritalStatus)
                    }
                }
                .padding([.leading, .trailing])
            }
            .frame(height: 500)
            Button(action: {
                if email != "" && phone != "" && age != "" && selectedGender != "" && selectedMaritalStatus != "" {
                    process = process + 1
                }
            }) {
                Text("NEXT")
                    .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(
                        cornerRadius: 5,
                        style: .continuous
                    )
                        .fill(Color(red: 0.0, green: 0.0, blue: 180)))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding([.leading, .trailing, .bottom])
        }
    }
}
