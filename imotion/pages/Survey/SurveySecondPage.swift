//
//  SurveySecondPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/20.
//

import SwiftUI

struct SurveySecondPage: View {
    @Binding var process:Int
    @Binding var working_address: String
    @Binding var selectedEmployment: String
    @Binding var selectedWorkplace: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Questions 2/3")
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
                    .foregroundColor(.primaryColor)
                    .cornerRadius(2)
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(.gray)
                    .cornerRadius(2)
            }
            .padding(.horizontal)
            
            Text("Employment")
                .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                .bold()
                .foregroundColor(.primaryColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top])
            ScrollView(){
                
                VStack(alignment: .leading) {
                    Text("Working Address")
                        .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                    TextField("", text: $working_address)
                        .textFieldStyle(BlackBorder())
                }
                .padding([.leading, .trailing])
        
                VStack(alignment: .leading) {
                           Text("Employment")
                               .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                               .padding(.leading)

                           // Define the grid columns for two columns
                           let columns = [
                               GridItem(.flexible()),
                               GridItem(.flexible())
                           ]

                           // Use LazyVGrid to arrange buttons in two columns
                           LazyVGrid(columns: columns, spacing: 10) {
                               SurveyButton(title: "Employed", selection: $selectedEmployment)
                               SurveyButton(title: "Unemployed", selection: $selectedEmployment)
                               SurveyButton(title: "Self-Employed", selection: $selectedEmployment)
                               SurveyButton(title: "Student", selection: $selectedEmployment)
                               SurveyButton(title: "Retired", selection: $selectedEmployment)
                               SurveyButton(title: "Others", selection: $selectedEmployment)
                           }
                           .padding([.leading, .trailing])
                }
                
                VStack(alignment: .leading) {
                    Text("Workplaces")
                        .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                    HStack {
                        SurveyButton(title: "Fixed", selection: $selectedWorkplace)
                        SurveyButton(title: "Non-Fixed", selection: $selectedWorkplace)
                    }
                }
                .padding([.leading, .trailing])
                
            }
            .frame(height: 500)
            
            Button(action: {
                if working_address != "" && selectedEmployment != "" && selectedWorkplace != ""{
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
