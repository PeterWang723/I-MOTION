//
//  SurveyPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/20.
//

import SwiftUI

struct SurveyComponent: View {
    @State var process: Int = 0
    @State var email: String = ""
    @State var phone: String = ""
    @State var age: String = ""
    @State var selectedGender: String = ""
    @State var selectedMaritalStatus: String = ""
    @State var working_address: String = ""
    @State var selectedEmployment: String = ""
    @State var selectedWorkplace: String = ""
    @State var total_member: String = ""
    @State var total_children: String = ""
    @State var income_range: String = ""
    @State var home_address: String=""
    
    var body: some View {
        if process == 0 {
            SurveyIntroPage(process: $process)
        } else if process == 1 {
            SurveyFirstPage(process: $process, email: $email, phone: $phone, age: $age, selectedGender: $selectedGender, selectedMaritalStatus: $selectedMaritalStatus)
        } else if process == 2 {
            SurveySecondPage(process: $process, working_address: $working_address, selectedEmployment: $selectedEmployment, selectedWorkplace: $selectedWorkplace)
        } else if process == 3 {
            SurveyThridPage(email: $email, phone: $phone, age: $age, selectedGender: $selectedGender, selectedMaritalStatus: $selectedMaritalStatus,working_address: $working_address, selectedEmployment: $selectedEmployment, selectedWorkplace: $selectedWorkplace, total_member: $total_member, total_children: $total_children, income_range: $income_range, home_address: $home_address)
        }
    }
}

#Preview {
    SurveyComponent()
}
