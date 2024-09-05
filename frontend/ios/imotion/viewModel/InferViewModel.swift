//
//  InferViewModel.swift
//  imotion
//
//  Created by Peter Wang on 2024/7/2.
//

import Foundation
import MapKit
import SwiftUI

class InferViewModel: ObservableObject {
    var gpsPoints: [GPSPoint]? = []
    var pointswithMode:[Int: [GPSPoint]] = [:]
    var pointswithMode_local:[String: [GPSPoint]] = [:]
    var locations_withMode: [Int:[String]] = [:]
    var local_locations_withMode: [String: [String]] = [:]
    @Published var activities:[Activity]? = []
    @Published var local_activities: [Activity_Storage]? = []
    var polylines: [Draw] = []
    var time:(Int, Int, Int) = (0, 0, 0)
    var distance: Double = 0
    var privacy: String = "HIGH"
    var placemarks: [Int:[String:[CLPlacemark]?]] = [:]
    var local_placemarks: [String:[String:[CLPlacemark]?]] = [:]
    func color(for mode: String) -> Color {
        switch mode {
        case "Walk":
            return .yellow
        case "Run":
            return .orange
        case "Bike":
            return .green
        case "Car":
            return .red
        case "Bus":
            return .blue
        case "Train":
            return .brown
        case "Subway":
            return .pink
        case "e-Bike":
            return .green
        case "e-Car":
            return .red
        case "1":
            return .yellow
        case "2":
            return .orange
        case "3":
            return .green
        case "4":
            return .red
        case "5":
            return .blue
        case "6":
            return .brown
        case "7":
            return .pink
        case "8":
            return .green
        case "9":
            return .red
        default:
            return .gray // Default color for unknown modes
        }
    }
    
    func icon(for mode: String) -> String {
        switch mode {
        case "Car":
            return "car.fill"
        case "Bus":
            return "bus.fill"
        case "Bike":
            return "bicycle"
        case "Walk":
            return "figure.walk"
        default:
            return "figure.arms.open"
        }
    }
    
    @MainActor func generateGPSPoints(date:Date) async ->[GPSPoint]?{
        print(self.privacy)
        do {
            if self.privacy == "HIGH" || self.privacy == "MEDIUM"{
                let locations = try StorageManager.shared.getLocations()
                return locations.map { location in
                    GPSPoint(id: location.id.hashValue, uid: nil, createdTime: location.timestamp, latitude: location.latitude, longitude: location.longitude)
                }
            } else {
                let token = JWTKeyChain.shared.retrieveJWT(forKey: "com.app.jwt")
                let locations = try await NetworkManager.shared.get_location(token: token!["jwt"]!!, date: date)
                print("locations: ", locations!)
                return locations
            }
        }catch{
            fatalError("Failed to get locations: \(error)")
        }
    }
    
    @MainActor func generateActivities(date:Date) async ->[Activity]? {
        do {
            let token = JWTKeyChain.shared.retrieveJWT(forKey: "com.app.jwt")
            var activites = try await NetworkManager.shared.get_infer(token: token!["jwt"]!!, date: date)
            activites!.sort{$0.start_time < $1.start_time}
            print("activities: ", activites!)
            return activites
        }catch{
            fatalError("Failed to get locations: \(error)")
        }
    }
    
    @MainActor func generateActivities_local(date:Date) async ->[Activity_Storage]? {
        do {
            var accs = try StorageManager.shared.getActivities(date: date)!
            accs.sort {$0.start_time < $1.start_time}
            return accs
        }catch{
            fatalError("Failed to get locations: \(error)")
        }
    }
    
    @MainActor func createPolylines(date:Date) async -> Bool{
        do {
            self.local_activities?.removeAll()
            self.activities?.removeAll()
            self.gpsPoints?.removeAll()
            self.polylines.removeAll()
            self.pointswithMode.removeAll()
            self.pointswithMode_local.removeAll()
            self.placemarks.removeAll()
            self.local_placemarks.removeAll()
            self.activities?.removeAll()
            self.local_activities?.removeAll()
            if self.privacy == "HIGH" || self.privacy == "MEDIUM"{
                self.local_activities = await generateActivities_local(date: date)
                self.gpsPoints = await generateGPSPoints(date: date)
                if self.local_activities != [] && self.gpsPoints != [] {
                    self.gpsPoints!.sort { $0.createdTime < $1.createdTime}
                    calculateTotalDistance()
                    try await filteredLocalPoints()
                    print("Polylines counts are \(self.polylines.count)")
                    return true
                }
            } else {
                self.activities = await generateActivities(date: date)
                self.gpsPoints = await generateGPSPoints(date: date)
                
                if (self.activities != nil && self.activities != []) && (self.gpsPoints != nil && self.gpsPoints != []) {
                    self.gpsPoints!.sort { $0.createdTime < $1.createdTime}
                    calculateTotalDistance()
                    try await filteredPoints()
                    return true
                }
            }
            return false
        } catch {
            fatalError("polylines make failure")
        }
    }
    
    func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        return Calendar.current.date(from: components)!
    }
    
    func filterGPSPoints(for activity: Activity, from points: [GPSPoint?]) -> [CLLocationCoordinate2D] {
        let filteredPoints = points.compactMap { $0 }.filter { point in
            point.createdTime >= activity.start_time && point.createdTime <= activity.end_time
        }
        
        let sortedPoints = filteredPoints.sorted(by: { $0.createdTime < $1.createdTime })
        self.pointswithMode[activity.id] = sortedPoints
        
        return filteredPoints.map { point in
            CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
        }
    }
    
    func filteredPoints() async throws{
        for index in 0..<activities!.count {
            let activity = activities![index]
            let points = filterGPSPoints(for: activity, from: self.gpsPoints!)
            print("points' count = \(points.count)")
            let distance = calculateDistance(gpsPoints: points)
            activities![index].distance = distance
            try await reverse_location(index: index, points:points)
            self.polylines.append(Draw(mode: activity.mode, points: points))
        }
    }
    
    func local_filterGPSPoints(for activity: Activity_Storage, from points: [GPSPoint?]) -> [CLLocationCoordinate2D] {
        let filteredPoints = points.compactMap { $0 }.filter { point in
            point.createdTime >= activity.start_time && point.createdTime <= activity.end_time
        }
        
        let sortedPoints = filteredPoints.sorted(by: { $0.createdTime < $1.createdTime })
        self.pointswithMode_local[activity.id] = sortedPoints
        
        return sortedPoints.map { point in
            CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
        }
    }
    
    func filteredLocalPoints() async throws{
        for index in 0..<local_activities!.count {
            let activity = local_activities![index]
            let points = local_filterGPSPoints(for: activity, from: self.gpsPoints!)
            let distance = calculateDistance(gpsPoints: points)
            if local_activities![index].distance != 0 {
                local_activities![index].distance = distance
            }
            try await reverse_location(index: index, points:points)
            self.polylines.append(Draw(mode: activity.mode, points: points))
        }
    }
    
    func getCalendar(date: Date){
        var calendar = Calendar.current
        
        calendar.timeZone = TimeZone.current
        
        calendar.locale = Locale.current

        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        self.time = (year, month, day)
    }
    
    func calculateDistance(gpsPoints:[CLLocationCoordinate2D]) -> Double{
        if gpsPoints.count > 1 {
            var totalDistance: Double = 0
            var previousLocation: CLLocation?
            
            for point in gpsPoints {
                let currentLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
                
                if let previousLocation = previousLocation {
                    let distance = previousLocation.distance(from: currentLocation)
                    totalDistance += distance
                }
                
                previousLocation = currentLocation
            }
            return totalDistance / 1000
        } else {
            return 0
        }
    }
    
    func calculateTotalDistance() {
        if self.gpsPoints!.count > 1 {
            var totalDistance: Double = 0
            var previousLocation: CLLocation?
            
            for point in self.gpsPoints! {
                let currentLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
                
                if let previousLocation = previousLocation {
                    let distance = previousLocation.distance(from: currentLocation)
                    totalDistance += distance
                }
                
                previousLocation = currentLocation
            }
            self.distance = totalDistance / 1000
        } else {
            self.distance = 0
        }
    }
    
    func reverseGeocode(location: CLLocation, name: String) async throws -> ([CLPlacemark], String) {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        guard let placemark = placemarks.first else {
            throw NSError(domain: "GeocodeError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No valid address found"])
        }
        return (placemarks, [placemark.name, placemark.locality, placemark.administrativeArea].compactMap { $0 }.joined(separator: ", "))
    }
    
    func reverse_location(index: Int, points: [CLLocationCoordinate2D]) async throws {
        print("index \(index) has \(points.count) points")
        if !points.isEmpty {
            let origin = points.first
            let dest = points.last
            let o = try await self.reverseGeocode(location: CLLocation(latitude: origin!.latitude, longitude: origin!.longitude), name: "origin")
            let d = try await self.reverseGeocode(location: CLLocation(latitude: dest!.latitude, longitude: dest!.longitude), name: "dest")
            if self.privacy != "LOW" {
                print("index \(index) enters full points with \(o.0.count) and \(d.0.count)")
                if self.local_activities![index].origin == "Unknown" || self.local_activities![index].destination == "Unknown" {
                    self.local_activities![index].origin = o.1
                    self.local_activities![index].destination = d.1
                }
                self.local_placemarks[self.local_activities![index].id] = [
                    "origin": o.0,
                    "dest": d.0
                ]
            } else {
                if self.activities![index].origin == nil || self.activities![index].destination == nil {
                    self.activities![index].origin = o.1
                    self.activities![index].destination = d.1
                }
                self.placemarks[self.activities![index].id] = [
                    "origin": o.0,
                    "dest": d.0
                ]
            }
        } else {
            if self.privacy != "LOW" {
                print("index \(index) enters empty points")
                self.local_activities![index].origin = "None"
                self.local_activities![index].destination = "None"
                self.local_placemarks[self.local_activities![index].id] = [
                    "origin": nil,
                    "dest": nil
                ]
            } else {
                self.activities![index].origin = "None"
                self.activities![index].destination = "None"
                self.placemarks[self.activities![index].id] = [
                    "origin": nil,
                    "dest": nil
                ]
            }
        }
    }
}

struct Draw: Identifiable {
    let id: UUID
    let mode: String
    let points: [CLLocationCoordinate2D]
    
    init(mode: String, points: [CLLocationCoordinate2D]) {
            self.id = UUID() // Generate a new UUID for each instance
            self.mode = mode
            self.points = points
    }
}

func icon_color(for mode: String) -> Color {
    switch mode {
    case "Car":
        return .red
    case "e-Car":
        return .red
    case "Bus":
        return .blue
    case "Bike":
        return .green
    case "e-Bike":
        return .green
    case "Walk":
        return .yellow
    case "Run":
        return .orange
    case "Train":
        return .brown
    case "Subway":
        return .pink
    default:
        return .gray // Default color for unknown modes
    }
}

func icon_image(for mode: String) -> String {
    switch mode {
    case "Car":
        return "car.fill"
    case "e-Car":
        return "car.fill"
    case "Bus":
        return "bus.fill"
    case "Bike":
        return "bicycle"
    case "e-Bike":
        return "bicycle"
    case "Walk":
        return "figure.walk"
    case "Run":
        return "figure.run"
    case "Train":
        return "tram.fill"
    case "Subway":
        return "tram.fill.tunnel"
    default:
        return "figure.arms.open"
    }
}

