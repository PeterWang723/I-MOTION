//
//  imotionTests.swift
//  imotionTests
//
//  Created by Peter Wang on 2024/7/17.
//

import XCTest
@testable import imotion

final class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!

    override func setUpWithError() throws {
        super.setUp()
        networkManager = NetworkManager.shared
    }

    override func tearDownWithError() throws {
        networkManager = nil
        super.tearDown()
    }

    func testSendLocationSuccess() throws {
        // Define expectations
        let expectation = XCTestExpectation(description: "Send location succeeds")
        let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjEiLCJleHAiOjEwMDAwMDE3MjEwNTE5NzJ9.5F04BtOoA7W1EmuLkL0fvVFemfXgrT43vjOJP6mfEXo"
        let testLocations = [Location(timestamp: Date(), latitude: 123.456, longitude: 78.910), Location(timestamp: Date(), latitude: 123.456, longitude: 78.910)]

        // Execute the test
        Task {
            do {
                let result = try await networkManager.send_location(token: testToken, locations: testLocations)
                print("Test Result: \(result)")
                XCTAssertTrue(result)
                expectation.fulfill()
            } catch {
                XCTFail("Test failed with error: \(error)")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetLocationSuccess() throws {
        // Define expectations
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let dateString = "2023-06-28T11:00:00.000+01:00"
        
        let date = formatter.date(from: dateString)!
        print("Parsed date: \(date)")
        
        let expectation = XCTestExpectation(description: "Get location succeeds")
        let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjEiLCJleHAiOjEwMDAwMDE3MjIyNjM0NDZ9.9GrAma65zo7oROnsZ6yBa0SALo6rcZWA0jV0rwsc0-E"

        // Execute the test
        Task {
            do {
                let result = try await networkManager.get_location(token: testToken, date: date)
                XCTAssertTrue((result != nil))
                expectation.fulfill()
            } catch {
                XCTFail("Test failed with error: \(error)")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetActivity() throws {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let dateString = "2024-07-31T00:00:00.000+01:00"
        
        let date = formatter.date(from: dateString)!
        // Define expectations
        let expectation = XCTestExpectation(description: "Get location succeeds")
        let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjEiLCJleHAiOjEwMDAwMDE3MjIyNjM0NDZ9.9GrAma65zo7oROnsZ6yBa0SALo6rcZWA0jV0rwsc0-E"

        // Execute the test
        Task {
            do {
                let result = try await networkManager.get_infer(token: testToken, date: date)
                for resul in result!{
                    print(resul)
                }
                XCTAssertTrue((result != nil))
                expectation.fulfill()
            } catch {
                XCTFail("Test failed with error: \(error)")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
