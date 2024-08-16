//
//  CommunityPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/29.
//

import SwiftUI

struct CommunityPage: View {
    @State private var selectedTimePeriod = "Weekly"
    let timePeriods = ["Weekly", "Monthly", "Yearly"]

    var body: some View {
        NavigationView {
            VStack {
                Picker("Time Period", selection: $selectedTimePeriod) {
                    ForEach(timePeriods, id: \.self) { period in
                        Text(period).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                ScrollView {
                    Group {
                        Text("Comparison")
                            .font(.headline)
                            .padding(.top, 20)

                        ComparisonChartView(label1: "You", value1: 1, label2: "Your Friends & Family", value2: 3)
                    }

                    Group {
                        Text("Data Usage Chart")
                            .font(.headline)
                            .padding(.top, 20)
                        
                        ComparisonChartView(label1: "You", value1: 1, label2: "Your Friends & Family", value2: 4)

                        Text("CO2 Emission")
                            .font(.headline)
                            .padding(.top, 20)
                        
                        ComparisonChartView(label1: "You", value1: 1, label2: "Your Friends & Family", value2: 4)
                    }

                    Spacer()
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Community Stats")
            .padding(.horizontal)
        }
    }
}

struct ComparisonChartView: View {
    var label1: String
    var value1: CGFloat
    var label2: String
    var value2: CGFloat

    var body: some View {
        HStack(alignment: .bottom) {  // Aligns contents along the bottom
            VStack {
                Text(label1)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 50, height: value1 * 100)
                    .alignmentGuide(.bottom, computeValue: { dimension in dimension[.bottom] })
            }
            VStack {
                Text(label2)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 50, height: value2 * 100)
                    .alignmentGuide(.bottom, computeValue: { dimension in dimension[.bottom] })
            }
        }
    }
}



#Preview {
    CommunityPage()
}
