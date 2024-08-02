import SwiftUI

// Define the data model for transportation data
struct TransportData: Identifiable {
    var id = UUID()
    var mode: String
    var percentage: Double
    var carbonFootprint: Double
    var dataUsage: Double
    var distance: Double
}

// Example data for demonstration
let exampleTransportData = [
    TransportData(mode: "Car", percentage: 30, carbonFootprint: 1200, dataUsage: 30, distance: 100),
    TransportData(mode: "Bus", percentage: 10, carbonFootprint: 300, dataUsage: 10, distance: 40),
    TransportData(mode: "Train", percentage: 15, carbonFootprint: 200, dataUsage: 15, distance: 70),
    TransportData(mode: "Subway", percentage: 20, carbonFootprint: 100, dataUsage: 20, distance: 90),
    TransportData(mode: "Walk", percentage: 5, carbonFootprint: 0, dataUsage: 5, distance: 10),
    TransportData(mode: "Run", percentage: 5, carbonFootprint: 0, dataUsage: 5, distance: 15),
    TransportData(mode: "Bike", percentage: 10, carbonFootprint: 0, dataUsage: 10, distance: 25),
    TransportData(mode: "Still", percentage: 5, carbonFootprint: 0, dataUsage: 5, distance: 0)
]

// Pie Chart View
struct PieChartView: View {
    var data: [TransportData]
    var colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .gray]

    var total: Double {
        data.reduce(0) { $0 + $1.percentage }
    }

    var angles: [Angle] {
        var starts = 0.0
        var slices: [Angle] = []
        for d in data {
            slices.append(.degrees(starts))
            starts += 360 * (d.percentage / total)
        }
        slices.append(.degrees(360))
        return slices
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(data.indices) { index in
                    PieSlice(startAngle: angles[index], endAngle: angles[index + 1])
                        .fill(colors[index % colors.count])
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .overlay(PieSlice(startAngle: angles[index], endAngle: angles[index + 1])
                            .stroke(Color.white, lineWidth: 2))
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// PieSlice Shape
struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.midY))
        p.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return p
    }
}

// Column Chart View
struct ColumnChartView: View {
    var data: [TransportData]
    var maxPercentage: Double {
        data.max(by: { $0.percentage < $1.percentage })?.percentage ?? 100
    }

    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(data) { item in
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 20, height: CGFloat(item.percentage / maxPercentage) * 200)
                    Text("\(Int(item.percentage))%")
                        .font(.caption)
                }
            }
        }.padding()
    }
}

// Main ContentView that combines all views
struct StatisticsPage: View {
    @State private var selectedTimePeriod = "Weekly"
    let timePeriods = ["Weekly", "Monthly", "Yearly"]
    var body: some View {
        NavigationView {
            VStack{
                Picker("Time Period", selection: $selectedTimePeriod) {
                    ForEach(timePeriods, id: \.self) { period in
                        Text(period).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ScrollView {
                    VStack {
                        PieChartView(data: exampleTransportData)
                            .frame(height: 300)
                        ColumnChartView(data: exampleTransportData)
                    }
                    .navigationTitle("Statistics")
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationTitle("Statistics")
        .padding(.horizontal)
    }
}

#Preview {
    StatisticsPage()
}
