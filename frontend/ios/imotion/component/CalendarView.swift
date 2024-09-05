//
//  CalendarView.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/20.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: ViewModel = ViewModel()
    @State var today:Date = Date()
    @Binding var selectedDate: Date
    var body: some View {
        NavigationView {
            Form {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    in:...today,
                    displayedComponents: [.date] // This shows only year, month, and day
                )
                .datePickerStyle(GraphicalDatePickerStyle()) // For a more visual style
                .environment(\.timeZone, TimeZone.current)
                .accentColor(.primaryColor)
            }
            .navigationTitle("Calendar")
            .font(Font.custom("ImperialSansDisplay-Bold", size: 18))
        }
        .onAppear{
            today = Date()
        }
    }
}
