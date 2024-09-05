//
//  SurveyThridPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/20.
//

import SwiftUI

struct SurveyThridPage: View {
    @EnvironmentObject var appState: AppState
    @Binding var email: String
    @Binding var phone: String
    @Binding var age: String
    @Binding var selectedGender: String
    @Binding var selectedMaritalStatus: String
    @Binding var working_address: String
    @Binding var selectedEmployment: String
    @Binding var selectedWorkplace: String
    @Binding var total_member: String
    @Binding var total_children: String
    @Binding var income_range: String
    @Binding var home_address: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Questions 3/3")
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
                    .foregroundColor(.primaryColor)
                    .cornerRadius(2)
            }
            .padding(.horizontal)
            
            Text("Household Information")
                .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                .bold()
                .foregroundColor(.primaryColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top])
            ScrollView(){
                Group {
                    VStack(alignment: .leading) {
                        Text("Home Address")
                            .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                        TextField("", text: $home_address)
                            .textFieldStyle(BlackBorder())
                    }
                    .padding([.leading, .trailing])
                    
                    VStack(alignment: .leading) {
                        Text("Total Member")
                            .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                        TextField("", text: $total_member)
                            .keyboardType(.numberPad)
                            .textFieldStyle(BlackBorder())
                    }
                    .padding([.leading, .trailing])
                    
                    VStack(alignment: .leading) {
                        Text("Vechile")
                            .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                        Button(action: {
                            // Handle next action
                        }) {
                            Text("Connect with your car")
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
                    }
                    .padding([.leading, .trailing])
                    
                    VStack(alignment: .leading) {
                        Text("Total Children")
                            .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                        TextField("", text: $total_children)
                            .keyboardType(.numberPad)
                            .textFieldStyle(BlackBorder())
                    }
                    .padding([.leading, .trailing])
                    
                    VStack(alignment: .leading) {
                        Text("Income range")
                            .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
                        TextField("£", text: $income_range)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(BlackBorder())
                    }
                    .padding([.leading, .trailing])
                }
            }
            .frame(height: 500)
            
            Button(action: {
                if total_member != "" && total_children != "" && income_range != "" && home_address != ""{
                    Task {
                        let success = try await NetworkManager.shared.save_survey(token:appState.user_token, email:email, phone:phone, age:age, selectedGender:selectedGender, selectedMaritalStatus:selectedMaritalStatus, working_address:working_address, selectedEmployment:selectedEmployment, selectedWorkplace:selectedWorkplace, total_member:total_member, total_children:total_children, income_range:income_range, home_address:home_address)
                        if success {
                            let token = JWTKeyChain.shared.retrieveJWT(forKey: "com.app.jwt")
                            if token != nil {
                                JWTKeyChain.shared.save(jwt: token!["jwt"]!!, privacyL: token!["privacyLevel"]!!, houseHold: "household", forKey: "com.app.jwt")
                                appState.houseHold = token!["houseHold"]!!
                                appState.skipSurvey = true
                            }
                        }
                    }
                }
            }) {
                Text("FINISH")
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
