//
//  NetworkManager.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/19.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

        
    func login(username:String, password:String) async throws -> LoginResponse {
        guard let url = URL(string: "https://www.i4motion.com/userService/auth/login") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": username,
            "password": password
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        if let response = try? decoder.decode(LoginResponse.self, from: data) {
            return response
        } else {
            print("Invalid Data")
        }
        return try decoder.decode(LoginResponse.self, from: data)
    }
    
    func register(username:String, password:String, privacyLevel:String) async throws -> Bool {
        guard let url = URL(string: "https://www.i4motion.com/userService/auth/register") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": username,
            "password": password,
            "privacy": privacyLevel
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        if let response = try? decoder.decode(RegisterResponse.self, from: data) {
            print(response)
            if (response.status == 100) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func save_survey(token: String, email: String, phone: String, age: String, selectedGender: String, selectedMaritalStatus: String, working_address: String, selectedEmployment: String, selectedWorkplace: String, total_member: String, total_children: String, income_range: String, home_address: String) async throws -> Bool {
        guard let url = URL(string: "https://www.i4motion.com/Stat/survey/save_survey") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: AnyHashable] = [
            "email": email,
            "phone": phone,
            "age": age,
            "selectedGender": selectedGender,
            "selectedMaritalStatus": selectedMaritalStatus,
            "working_address": working_address,
            "selectedEmployment": selectedEmployment,
            "selectedWorkplace": selectedWorkplace,
            "total_member": total_member,
            "total_children": total_children,
            "income_range": income_range,
            "home_address": home_address
        ]
        
        print("request body is: \(body)")
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        
        if let response = try? decoder.decode(GeneralResponse.self, from: data) {
            print("Survey Response: \(String(describing: response.status)) and \(response.status == 100)")
            return response.status == 100
        } else {
            print("No response")
            return false
        }
    }
    
    func get_survey(token: String) async throws -> Bool {
        guard let url = URL(string: "https://www.i4motion.com/Stat/survey/get_survey") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        if let response = try? decoder.decode(GeneralResponse.self, from: data) {
            return response.status == 100
        } else {
            return false
        }
    }
    
    func send_location(token: String, locations:[Location]) async throws -> Bool {
        guard let url = URL(string: "https://www.i4motion.com/dataCollection/dc/save_loc") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body = locations.map { location -> [String: AnyHashable] in
            return [
                "createdTime": location.timestamp.toISO8601String(),
                "latitude": location.latitude,
                "longitude": location.longitude
            ]
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        
        if let response = try? decoder.decode(GeneralResponse.self, from: data) {
            return response.status == 100
        } else {
            return false
        }
    }
    
    func get_location(token: String, date:Date) async throws -> [GPSPoint]? {
        guard let url = URL(string: "https://www.i4motion.com/dataCollection/dc/get_loc") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let calendar = Calendar.current
        let dayComponent = calendar.dateComponents([.year, .month, .day], from: date)
        let baseDate = calendar.date(from: dayComponent)!
        let sixAM = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: baseDate)!
        let midnight = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: baseDate)!
        print(date)
        print("sixAM: \(sixAM.toISO8601String())")
        print("midnight: \(midnight.toISO8601String())")
        let body: [String: AnyHashable] = [
            "start_date":sixAM.toISO8601String(),
            "end_date":midnight.toISO8601String()
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            let response = try decoder.decode(User_Location.self, from: data)
            if response.status == 100 {
                return response.data
            } else {
                return nil
            }
        } catch {
            print("Decoding failed with error: \(error)")
            return nil
        }
    }
    
    func get_infer(token: String, date:Date) async throws -> [Activity]? {
        guard let url = URL(string: "https://www.i4motion.com/Infer/infer/get_infer") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions = [.withInternetDateTime, .withTimeZone] // Ensures time zone is included

        let iso8601String = formatter.string(from: date.startOfDay)
        let body: [String: AnyHashable] = [
            "date": iso8601String
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            let response = try decoder.decode(Activities.self, from: data)
            if response.status == 100{
                return response.data
            } else {
                return nil
            }
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
    
    func update_infer(token: String, activity:Activity) async throws-> Bool {
        guard let url = URL(string: "https://www.i4motion.com/Infer/infer/update_infer") else {
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        do {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(activity)
        let (data, _) = try await URLSession.shared.data(for: request)
        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Serialize JSON Object to String
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON String: \(jsonString)")
                }
            }
        let decoder = JSONDecoder()
            let response = try decoder.decode(GeneralResponse.self, from: data)
            if response.status == 100{
                return true
            } else {
                return false
            }
        } catch {
            print("Decoding error: \(error)")
            return false
        }
    }
    
    func predict(token: String, accs:[Accelerometer]) async throws-> Bool {
        guard let url = URL(string: "https://www.i4motion.com/Survey/predict_acc/") else {
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        var pred_data: [Pred_Data] = []
        for acc in accs{
            let temp = Pred_Data(day:acc.timestamp.startOfDay, time: acc.timestamp, data: acc.data)
            pred_data.append(temp)
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(pred_data)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
                let response = try decoder.decode(GeneralResponse.self, from: data)
                if response.message == "machine_learning model is predicting now"{
                    return true
                } else {
                    print(response.message)
                    return false
                }
        } catch {
            print("Decoding error: \(error)")
            return false
        }
    }
    
    func send_accs(token: String, accs:[Acceleration]) async throws -> Bool {
        guard let url = URL(string: "https://www.i4motion.com/dataCollection/dc/save_acc") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(accs)
    
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        
        if let response = try? decoder.decode(GeneralResponse.self, from: data) {
            return response.status == 100
        } else {
            return false
        }
    }
}

struct LoginResponse: Codable {
    let data: [String?]
    let message: String
    let status: Int
}

struct RegisterResponse: Codable {
    let data: String?
    let message: String
    let status: Int
}

struct GeneralResponse: Codable {
    let data: String?
    let message: String
    let status: Int?
}

struct User_Location: Codable {
    let status: Int
    let message: String
    let data: [GPSPoint]?
}

struct GPSPoint: Codable, Equatable{
    var id: Int
    var uid: Int?
    var createdTime: Date
    var latitude: Double
    var longitude: Double
}

struct Pred_Data: Codable {
    var day: Date
    var time: Date
    var data: [AccelerationData]
}

struct GPSTestPoint: Codable {
    var id: Int
    var uid: Int
    var createdTime: String
    var latitude: Double
    var longitude: Double
}

// Define a struct for Purpose
struct Purpose: Codable, Equatable{
    var id: Int?
    var purpose: String
    var time: Double
}

struct Acceleration: Codable {
    var time: Date
    var x: Double
    var y: Double
    var z: Double
}
struct Activity: Codable, Identifiable, Equatable{
    static func == (lhs: Activity, rhs: Activity) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.u_id == rhs.u_id &&
                   lhs.mode == rhs.mode &&
                   lhs.day == rhs.day &&
                   lhs.start_time == rhs.start_time &&
                   lhs.end_time == rhs.end_time &&
                   lhs.origin == rhs.origin &&
                   lhs.destination == rhs.destination &&
                   lhs.distance == rhs.distance &&
                   lhs.cost == rhs.cost &&
                   lhs.luggage_num == rhs.luggage_num &&
                   lhs.luggage_type == rhs.luggage_type &&
                   lhs.luggage_weight == rhs.luggage_weight &&
                   lhs.travel_car_cost == rhs.travel_car_cost &&
                   lhs.purposes == rhs.purposes
        }
    
    var id: Int
    var u_id: Int
    var mode: String
    var day: Date
    var start_time: Date
    var end_time: Date
    var origin: String?
    var destination: String?
    var distance: Double?
    var cost: Double?
    var luggage_num: Int?
    var luggage_type: Int?
    var luggage_weight: Double?
    var travel_car_cost: Double?
    var purposes: [Purpose]?
}

struct Activities: Codable{
    let status: Int
    let message: String
    let data: [Activity]
}


