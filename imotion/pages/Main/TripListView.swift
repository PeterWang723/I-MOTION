//
//  TripListView.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/24.
//
import SwiftUI
import CoreLocation

struct TripListView: View {
    @EnvironmentObject var appState: AppState
    @Binding var selectedDate:Date
    @ObservedObject var inferViewModel:InferViewModel
    @State private var scrollViewHeight: CGFloat = 200
    @State private var isDragging = false
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            let newHeight = scrollViewHeight - value.translation.height
                            scrollViewHeight = max(100, min(400, newHeight))
                        }
                        .onEnded { _ in
                            isDragging = false
                        }
                )
                .animation(.interactiveSpring(), value: isDragging)
            if appState.privacy != "LOW" {
                HStack {
                    Text("\(inferViewModel.local_activities!.count) Trips")
                    Spacer()
                    Text("\(String(inferViewModel.time.0))-\(String(inferViewModel.time.1))-\(String(inferViewModel.time.2))")
                    Spacer()
                    Text("\(String(format: "%.2f", inferViewModel.distance)) km")  // This should be calculated if dynamic
                }
                .font(.headline)
                .padding([.top, .horizontal])
                
                Divider()
                
                ScrollView {
                    VStack {
                        ForEach(Array(inferViewModel.local_activities!.enumerated()), id: \.element.id) { index, activity in
                               TripRow(selectedDate: $selectedDate, inferViewModel: inferViewModel, index: index)
                               Divider()
                           }
                    }
                }
                .frame(height: scrollViewHeight)
            } else {
                HStack {
                    Text("\(inferViewModel.activities!.count) Trips")
                    Spacer()
                    Text("\(String(inferViewModel.time.0))-\(String(inferViewModel.time.1))-\(String(inferViewModel.time.2))")
                    Spacer()
                    Text("\(String(format: "%.2f", inferViewModel.distance)) km")  // This should be calculated if dynamic
                }
                .font(.headline)
                .padding([.top, .horizontal])
                
                Divider()
                
                ScrollView {
                    VStack {
                        ForEach(Array(inferViewModel.activities!.enumerated()), id: \.element.id) { index, activity in
                               TripRow(selectedDate: $selectedDate, inferViewModel: inferViewModel, index: index)
                               Divider()
                        }
                    }
                }
                .frame(height: scrollViewHeight)
            }
        }
        .background(Color.white)
        .clipShape(TopCornersRoundedShape(radius: 10))
        .shadow(radius: 5)
    }
}


struct TripRow: View {
    @Binding var selectedDate:Date
    @State private var showingDetail = false
    @ObservedObject var inferViewModel:InferViewModel
    @State var index: Int = -1
    private let geocoder = CLGeocoder()
    private let geocodeQueue = DispatchQueue(label: "com.imotion.geocode")
    var body: some View {
        HStack {
            if inferViewModel.privacy != "LOW" {
                Image(systemName: icon_image(for: inferViewModel.local_activities![index].mode))
                    .foregroundColor(icon_color(for: inferViewModel.local_activities![index].mode))
                    .frame(width: 30, height: 30)
                VStack(alignment: .leading) {
                    Text(inferViewModel.local_activities![index].mode)
                        .font(.headline)
                    Text(String(format: "%.2fkm", inferViewModel.local_activities![index].distance))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                HStack(alignment: .center){
                    Text(inferViewModel.local_activities![index].origin.split(separator: ",").first!)
                    Text("-")
                    Text(inferViewModel.local_activities![index].destination.split(separator: ",").first!)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(DateUtils.shared.hourMinuteDifference(start_time: inferViewModel.local_activities![index].start_time, end_time: inferViewModel.local_activities![index].end_time).hours):\(DateUtils.shared.hourMinuteDifference(start_time: inferViewModel.local_activities![index].start_time, end_time: inferViewModel.local_activities![index].end_time).minutes)")
                        .bold()
                    Text("\(DateUtils.shared.formatHourMinute(date: inferViewModel.local_activities![index].start_time))-\(DateUtils.shared.formatHourMinute(date: inferViewModel.local_activities![index].end_time))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            } else {
                Image(systemName: icon_image(for: (TransportMode(rawValue: Int(inferViewModel.activities![index].mode)!)!.description())))
                    .foregroundColor(icon_color(for: TransportMode(rawValue: Int(inferViewModel.activities![index].mode)!)!.description()))
                    .frame(width: 30, height: 30)
                VStack(alignment: .leading) {
                    Text(TransportMode(rawValue: Int(inferViewModel.activities![index].mode)!)!.description())
                        .font(.headline)
                    Text(String(format: "%.2fkm", inferViewModel.activities![index].distance!))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                HStack(alignment: .center){
                    Text(inferViewModel.activities![index].origin!)
                    Text("-")
                    Text(inferViewModel.activities![index].destination!)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(DateUtils.shared.hourMinuteDifference(start_time: inferViewModel.activities![index].start_time, end_time: inferViewModel.activities![index].end_time).hours):\(DateUtils.shared.hourMinuteDifference(start_time: inferViewModel.activities![index].start_time, end_time: inferViewModel.activities![index].end_time).minutes)")
                        .bold()
                    Text("\(DateUtils.shared.formatHourMinute(date: inferViewModel.activities![index].start_time))-\(DateUtils.shared.formatHourMinute(date: inferViewModel.activities![index].end_time))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .contentShape(Rectangle()) // Makes the entire HStack tappable
        .onTapGesture {
            showingDetail.toggle() // Toggles the state to show the sheet
            print("showingDetail is \(showingDetail)")
        }
        .sheet(isPresented: $showingDetail) {
            // The content of the sheet
            TripDetail(showingDetail:$showingDetail, index:$index, inferViewModel:inferViewModel)
        }
    }
}

struct TopCornersRoundedShape: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start from the bottom left
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        // Line to the bottom right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Line to the top right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        // Top right curve
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                    radius: radius,
                    startAngle: .zero,
                    endAngle: .degrees(270),
                    clockwise: true)
        // Line to top left
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        // Top left curve
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                    radius: radius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(180),
                    clockwise: true)
        // Close the path
        path.closeSubpath()
        
        return path
    }
}
