//
//  StorageContainer.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/19.
//

import SwiftData
import CoreLocation
import CoreMotion

class StorageManager {
    static let shared = StorageManager()
    let container: ModelContainer
    
    init() {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false, allowsSave: true)
        self.container = {
            do {
                return try ModelContainer(for: Location.self, Accelerometer.self, Activity_Storage.self, configurations: configuration)
            } catch {
                fatalError("Failed to initialize the ModelContainer: \(error)")
            }
        }()
    }
    
    @MainActor func storeLocation(location: CLLocation) async throws{
        let context = self.container.mainContext
        let location_model = Location(timestamp: location.timestamp, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        context.insert(location_model)
    }
    
    @MainActor func storeAcc(timestamp: Date, data: [CMAcceleration]) async throws{
        let context = self.container.mainContext
        let acc_model = Accelerometer(timestamp: timestamp, data: data)
        context.insert(acc_model)
    }
    
    @MainActor func getLocations() throws ->[Location] {
        let context = self.container.mainContext
        
        let fetchDescriptor = FetchDescriptor<Location>(predicate: nil)

        do {
            return try context.fetch(fetchDescriptor)
        }catch{
            fatalError("Failed to fetch the token list: \(error)")
        }
        
    }
    
    @MainActor func getAcc() throws ->[Accelerometer] {
        let context = self.container.mainContext
        
        let fetchDescriptor = FetchDescriptor<Accelerometer>(predicate: nil)

        do {
            return try context.fetch(fetchDescriptor)
        }catch{
            fatalError("Failed to fetch the token list: \(error)")
        }
        
    }
    
    
    @MainActor func getActivities(date:Date) throws ->[Activity_Storage]?{
        let context = self.container.mainContext
        
        /*
        let actPredicate = #Predicate<Activity_Storage> { actvity in
            actvity.day == date
        }
         */
        let fetchDescriptor = FetchDescriptor<Activity_Storage>(predicate: nil)

        do {
            return try context.fetch(fetchDescriptor)
        }catch{
            fatalError("Failed to fetch the token list: \(error)")
        }
    }
    
    @MainActor func storeActivities(data: [Activity_Storage]) async throws{
        let context = self.container.mainContext
        for activity in data {
            context.insert(activity)
        }
        try context.delete(model:Accelerometer.self)
        try context.save()
    }
    
    @MainActor func logout() throws {
        let context = self.container.mainContext
        try context.delete(model:Accelerometer.self)
        try context.delete(model:Location.self)
        try context.delete(model:Activity_Storage.self)
        try context.save()
    }
    
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!.addingTimeInterval(-1)
    }
}
