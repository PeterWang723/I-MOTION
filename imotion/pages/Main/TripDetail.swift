//
//  TripDetail.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/25.
//

import SwiftUI
import CoreLocation

struct TripDetail: View {
    @Binding var showingDetail:Bool
    @Binding var index: Int
    @ObservedObject var inferViewModel: InferViewModel
    @State private var startHour = ""
    @State private var startMinute = ""
    @State private var total_time: Double = 0
    @State private var origin = ""
    @State private var text_origin = ""
    @State private var text_destination = ""
    @State private var destination = ""
    @State private var selectedTransport: String = ""
    @State private var networkingDuration: Double = 0
    @State private var gamingDuration: Double = 0
    @State private var socializingDuration: Double = 0
    var transportOptions = ["Car", "Bus", "Train", "Subway", "Walk", "Run", "Bike", "Still"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                transportSection
                originDestinationSection
                activitiesSection
            }
            .padding()
            .background(Color(.systemBackground))
            Button("Done",
                   action: {
                    if inferViewModel.privacy != "LOW" {
                        if selectedTransport != ""{
                            inferViewModel.local_activities![index].mode = selectedTransport
                        }
                        
                        if origin != "" {
                            inferViewModel.local_activities![index].origin = origin
                        } else if text_origin != "" {
                            inferViewModel.local_activities![index].origin = text_origin
                            print("origin is \(inferViewModel.local_activities![index].origin)")
                        }
                        
                        if destination != "" {
                            inferViewModel.local_activities![index].destination = destination
                        } else if text_destination != "" {
                            inferViewModel.local_activities![index].destination = text_destination
                            print("destination is \(inferViewModel.local_activities![index].destination)")
                        }
                        
                        if networkingDuration != 0 || gamingDuration != 0 || socializingDuration != 0 {
                            inferViewModel.local_activities![index].purpose = [
                                Purpose(id: 1, purpose: "Networking", time: networkingDuration),
                                Purpose(id: 2, purpose: "Gaming", time: gamingDuration),
                                Purpose(id: 3, purpose: "Socializing", time: socializingDuration)
                            ]
                        }
                        
                        do {
                            try StorageManager.shared.container.mainContext.save()
                            showingDetail.toggle()
                        } catch {
                            print("cannot save it")
                        }
                    } else {
                        if selectedTransport != ""{
                            inferViewModel.activities![index].mode = String(TransportMode.rawValue(fromDescription: selectedTransport)!)
                        }
                        
                        if origin != "" {
                            inferViewModel.activities![index].origin = origin
                        } else if text_origin != "" {
                            inferViewModel.activities![index].origin = text_origin
                        }
                        
                        if destination != "" {
                            inferViewModel.activities![index].destination = destination
                        } else if text_destination != "" {
                            inferViewModel.activities![index].destination = text_destination
                        }
                        
                        if networkingDuration != 0 || gamingDuration != 0 || socializingDuration != 0 {
                            inferViewModel.activities![index].purposes = [
                                Purpose(purpose: "Networking", time: networkingDuration),
                                Purpose(purpose: "Gaming", time: gamingDuration),
                                Purpose(purpose: "Socializing", time: socializingDuration)
                            ]
                        }
                        Task{
                            print("Network Task Start")
                            do {
                                let token = JWTKeyChain.shared.retrieveJWT(forKey: "com.app.jwt")
                                let success = try await NetworkManager.shared.update_infer(token: token!["jwt"]!!, activity: inferViewModel.activities![index])
                                if success {
                                    showingDetail.toggle()
                                }
                            } catch {
                                print("cannot save it")
                            }
                            print("Network Task finished")
                        }
                    }
            })
            .font(Font.custom("ImperialSansDisplay-Bold", size: 20))
            .foregroundColor(.primaryColor)
        }
        .navigationTitle("Trip Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            if inferViewModel.privacy != "LOW" {
                total_time = inferViewModel.local_activities![index].end_time.timeIntervalSince(inferViewModel.local_activities![index].start_time) / (60*60)
                if inferViewModel.local_activities![index].purpose != nil {
                    for purpose in inferViewModel.local_activities![index].purpose! {
                        if purpose.purpose == "Networking"{
                            networkingDuration = purpose.time
                        } else if purpose.purpose == "Gaming"{
                            gamingDuration = purpose.time
                        } else {
                            socializingDuration = purpose.time
                        }
                    }
                }
            } else {
                total_time = inferViewModel.activities![index].end_time.timeIntervalSince(inferViewModel.activities![index].start_time) / (60*60)
                if inferViewModel.activities![index].purposes != nil {
                    for purpose in inferViewModel.activities![index].purposes! {
                        if purpose.purpose == "Networking"{
                            networkingDuration = purpose.time
                        } else if purpose.purpose == "Gaming"{
                            gamingDuration = purpose.time
                        } else {
                            socializingDuration = purpose.time
                        }
                    }
                }
            }
        }
    }
    
    var headerSection: some View {
        HStack {
            if inferViewModel.privacy != "LOW" {
                IconView(imageName: icon_image(for: inferViewModel.local_activities![index].mode), text: String(format: "\(inferViewModel.local_activities![index].mode) %.2fkm", inferViewModel.local_activities![index].distance), detailText: "\(inferViewModel.local_activities![index].origin) → \(inferViewModel.local_activities![index].destination)")
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(DateUtils.shared.hourMinuteDifference(start_time: inferViewModel.local_activities![index].start_time, end_time: inferViewModel.local_activities![index].end_time).hours):\(DateUtils.shared.hourMinuteDifference(start_time: inferViewModel.local_activities![index].start_time, end_time: inferViewModel.local_activities![index].end_time).minutes)")
                        .font(.headline)
                    Text("\(DateUtils.shared.formatHourMinute(date: inferViewModel.local_activities![index].start_time))-\(DateUtils.shared.formatHourMinute(date: inferViewModel.local_activities![index].end_time))")
                        .font(.subheadline)
                }
            } else {
                IconView(imageName: icon_image(for: TransportMode(rawValue: Int(inferViewModel.activities![index].mode)!)!.description()), text: "\(TransportMode(rawValue: Int(inferViewModel.activities![index].mode)!)!.description()) \(inferViewModel.activities![index].distance!)km", detailText: "\(inferViewModel.activities![index].origin!) → \(inferViewModel.activities![index].destination!)")
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(DateUtils.shared.hourMinuteDifference(start_time: inferViewModel.activities![index].start_time, end_time: inferViewModel.activities![index].end_time).hours):\(DateUtils.shared.hourMinuteDifference(start_time: inferViewModel.activities![index].start_time, end_time: inferViewModel.activities![index].end_time).minutes)")
                        .font(.headline)
                    Text("\(DateUtils.shared.formatHourMinute(date: inferViewModel.activities![index].start_time))-\(DateUtils.shared.formatHourMinute(date: inferViewModel.activities![index].end_time))")
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]), startPoint: .leading, endPoint: .trailing))
        .foregroundColor(.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    var transportSection: some View {
        SectionView(title: "Mode of Transport", content: {
            GridStack(rows: 2, columns: 4) { row, col in
                let index = row * 4 + col
                if index < transportOptions.count {
                    Button(transportOptions[index]) {
                        selectedTransport = transportOptions[index]
                    }
                    .buttonStyle(FilledButtonStyle(selected: selectedTransport == transportOptions[index]))
                }
            }
        })
    }
    
    var startTimeSection: some View {
        SectionView(title: "Start", content: {
            HStack {
                CustomTextField(placeholder: "hr", text: $startHour)
                CustomTextField(placeholder: "min", text: $startMinute)
            }
        })
    }
    
    var originDestinationSection: some View {
        VStack(spacing: 10) {
            if inferViewModel.privacy != "LOW"{
                if  inferViewModel.local_placemarks[inferViewModel.local_activities![index].id]!["origin"]! != nil{
                    SectionView(title: "Origin", content: {
                        GridStack(rows: inferViewModel.local_placemarks[inferViewModel.local_activities![index].id]!["origin"]!!.count, columns: 1) { row, col in
                            let index = row
                            let loc = inferViewModel.local_placemarks[inferViewModel.local_activities![index].id]!["origin"]!![index]
                            let loc_string = [loc.name, loc.locality, loc.administrativeArea].compactMap { $0 }.joined(separator: ", ")
                            Button(loc_string) {
                                origin = loc_string
                            }
                            .buttonStyle(FilledButtonStyle(selected: origin == loc_string))
                        }
                    })
                }
                SectionView(title: "Origin", content: {
                    CustomTextField(placeholder: "Address", text: $text_origin)
                })
                
                if  inferViewModel.local_placemarks[inferViewModel.local_activities![index].id]!["dest"]! != nil{
                    SectionView(title: "Destination", content: {
                        GridStack(rows: inferViewModel.local_placemarks[inferViewModel.local_activities![index].id]!["dest"]!!.count, columns: 1) { row, col in
                            let index = row
                            let loc = inferViewModel.local_placemarks[inferViewModel.local_activities![index].id]!["dest"]!![index]
                            let loc_string = [loc.name, loc.locality, loc.administrativeArea].compactMap { $0 }.joined(separator: ", ")
                            Button(loc_string) {
                                destination = loc_string
                            }
                            .buttonStyle(FilledButtonStyle(selected: destination == loc_string))
                        }
                    })
                }
                SectionView(title: "Destination", content: {
                    CustomTextField(placeholder: "Address", text: $text_destination)
                })
            } else {
                if  inferViewModel.placemarks[inferViewModel.activities![index].id]!["origin"]! != nil{
                    SectionView(title: "Origin", content: {
                        GridStack(rows: inferViewModel.placemarks[inferViewModel.activities![index].id]!["origin"]!!.count, columns: 1) { row, col in
                            let index = row
                            let loc = inferViewModel.placemarks[inferViewModel.activities![index].id]!["origin"]!![index]
                            let loc_string = [loc.name, loc.locality, loc.administrativeArea].compactMap { $0 }.joined(separator: ", ")
                            Button(loc_string) {
                                origin = loc_string
                            }
                            .buttonStyle(FilledButtonStyle(selected: origin == loc_string))
                        }
                    })
                }
                SectionView(title: "Origin", content: {
                    CustomTextField(placeholder: "Address", text: $text_origin)
                })
                
                if  inferViewModel.placemarks[inferViewModel.activities![index].id]!["dest"]! != nil{
                    SectionView(title: "Destination", content: {
                        GridStack(rows: inferViewModel.placemarks[inferViewModel.activities![index].id]!["dest"]!!.count, columns: 1) { row, col in
                            let index = row
                            let loc = inferViewModel.placemarks[inferViewModel.activities![index].id]!["dest"]!![index]
                            let loc_string = [loc.name, loc.locality, loc.administrativeArea].compactMap { $0 }.joined(separator: ", ")
                            Button(loc_string) {
                                destination = loc_string
                            }
                            .buttonStyle(FilledButtonStyle(selected: destination == loc_string))
                        }
                    })
                }
                SectionView(title: "Destination", content: {
                    CustomTextField(placeholder: "Address", text: $text_destination)
                })
            }
        }
    }
    
    var activitiesSection: some View {
        SectionView(title: "Activities during This Trip", content: {
                    VStack {
                            ActivitySlider(activityName: "Networking", networkduration: $networkingDuration, gameduration: $gamingDuration, socailduration: $socializingDuration, totalTime: $total_time)
                            ActivitySlider(activityName: "Gaming", networkduration: $networkingDuration, gameduration: $gamingDuration, socailduration: $socializingDuration, totalTime: $total_time)
                            ActivitySlider(activityName: "Socializing", networkduration: $networkingDuration, gameduration: $gamingDuration, socailduration: $socializingDuration, totalTime: $total_time)
                    }
        })
    }
}

struct ActivitySlider: View {
    var activityName: String
    @Binding var networkduration: Double
    @Binding var gameduration: Double
    @Binding var socailduration: Double
    @Binding var totalTime: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(activityName)
                .font(.headline)
            if activityName == "Networking"{
                Slider(value: $networkduration, in: 0...(totalTime-gameduration-socailduration))
                .accentColor(.blue)
                Text("\(networkduration, specifier: "%.2f") hours")
                    .font(.caption)
            } else if activityName == "Gaming"{
                Slider(value: $gameduration, in: 0...(totalTime-networkduration-socailduration))
                .accentColor(.blue)
                Text("\(gameduration, specifier: "%.2f") hours")
                    .font(.caption)
            } else {
                Slider(value: $socailduration, in: 0...(totalTime-gameduration-networkduration))
                .accentColor(.blue)
                Text("\(socailduration, specifier: "%.2f") hours")
                    .font(.caption)
            }
        }
        .padding()
    }
}

struct IconView: View {
    let imageName: String
    let text: String
    let detailText: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text(text).bold()
                Text(detailText).font(.caption)
            }
        }
    }
}

struct SectionView<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).bold()
            content
        }
        .padding()
        .frame(width: 350)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(10)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
    }
}

struct FilledButtonStyle: ButtonStyle {
    var selected: Bool = false

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(selected ? .white : .primaryColor)
            .padding()
            .background(selected ? .primaryColor : Color.white)
            .cornerRadius(8)
            .shadow(radius: selected ? 0 : 5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut, value: configuration.isPressed)
    }
}

struct GridStack<Content: View>: View {
    let rows: Int, columns: Int
    @ViewBuilder let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}
