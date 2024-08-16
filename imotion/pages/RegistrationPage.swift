import SwiftUI

struct RegistrationPage: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var registerViewModel = RegisterViewModel()
    @Binding var userName: String
    @Binding var password: String
    @Binding var r_password: String
    @Binding var privacy: String
    @Binding var isSurveyFinished: Bool
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack {
            Text("I - M O T I O N")
                .font(Font.custom("ImperialSansDisplay-Bold", size: 36))
                .fontWeight(.bold)
                .foregroundColor(.primaryColor)
            
            VStack {
                VStack(alignment: .leading) {
                    Text("EMAIL")
                        .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.primaryColor)
                    
                    TextField("", text: $userName)
                        .disableAutocorrection(true)
                        .frame(width: 320.0, height: 40.0)
                        .textFieldStyle(BlackBorder())
                    
                    Text("PASSWORD")
                        .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.primaryColor)
                    
                    SecureField("", text: $password)
                        .disableAutocorrection(true)
                        .frame(width: 320.0, height: 40.0)
                        .textFieldStyle(BlackBorder())
                    
                    Text("REPEATED PASSWORD")
                        .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.primaryColor)
                    
                    SecureField("", text: $r_password)
                        .disableAutocorrection(true)
                        .frame(width: 320.0, height: 40.0)
                        .textFieldStyle(BlackBorder())
                }
                .padding(.bottom, 10)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.bottom, 10)
                }
                
                Button(action: {
                    if userName != "" && password != "" && r_password != "" && password == r_password{
                        Task {
                            let response = await registerViewModel.registerUser(username:userName, password:password, privacy:privacy)
                            if response == true {
                                appState.isRegistered = false
                            }
                        }
                    } else {
                        print("Enter something")
                    }
                }) {
                    Text("REGISTER")
                        .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 320, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(Color(red: 0.0, green: 0.0, blue: 1))
                        )
                }
            }
            .padding(.top, 50)
        }
    }
    
    private func register() {
        if password != r_password {
            showError = true
            errorMessage = "Passwords do not match"
        } else {
            showError = false
            errorMessage = ""
            // Proceed with registration logic
            // For example, you could set isSurveyFinished to true
            isSurveyFinished = true
        }
    }
}

struct BlackBorder: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}


