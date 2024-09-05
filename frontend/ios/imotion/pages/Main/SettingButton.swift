//
//  SettingButton.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/24.
//

import SwiftUI

struct SettingButton: View {
    @State private var isShowingSheet = false
    @ObservedObject var inferViewModel:InferViewModel
    @Binding var selectedDate:Date
    @Binding var isLoading: Bool
    @Binding var notReady: Bool
    var body: some View {
        Button {
            isShowingSheet.toggle()
        } label: {
            Image(systemName: "calendar")
                .font(.title2)
                .foregroundColor(.primaryColor)
                .padding()
                .background(.white)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .shadow(color:.black, radius:4)
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .sheet(isPresented: $isShowingSheet, onDismiss: didDismiss) {
                    VStack {
                        CalendarView(selectedDate:$selectedDate)
                        Button("Done",
                               action: { isShowingSheet.toggle() })
                        .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
                        .foregroundColor(.primaryColor)
                    }
            }
    }
    func didDismiss() {
        isLoading = true
        notReady = false
        Task{
            inferViewModel.getCalendar(date: selectedDate)
            let success = await inferViewModel.createPolylines(date: selectedDate.startOfDay)
            print("Create polylines sucess: \(success)")
            if success {
                isLoading = false
            } else {
                notReady = true
            }
        }
    }
}

