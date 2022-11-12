//
//  EarthquakesTests.swift
//  EarthquakesTests
//
//  Created by Mitul Vaghamshi on 2022-11-06.
//

import XCTest
@testable import Earthquakes

final class EarthquakesTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let value = 5 * 2
        XCTAssertEqual(value, 10)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

extension EarthquakesTests {
    func testGeoJSONDecoderDecodesQuakes() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        
        let quake = try decoder.decode(Quake.self, from: testFeature_nc73649170)
        XCTAssertEqual(quake.code, "73649170")
        
        let expectedSeconds = TimeInterval(1636129710550) / 1000
        let decodedSoconds = quake.time.timeIntervalSince1970
        XCTAssertEqual(expectedSeconds, decodedSoconds, accuracy: 0.00001)
    }
    
    func testGeoJSONDecoderDecodesGeoJSON() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        
        let geoJson = try decoder.decode(GeoJSON.self, from: testQuakesData)
        XCTAssertEqual(geoJson.quakes.count, 6)
        
        let firstQuake = geoJson.quakes.first!
        XCTAssertEqual(firstQuake.code, "73649170")
        
        let expectedSeconds = TimeInterval(1636129710550) / 1000
        let decodedSoconds = firstQuake.time.timeIntervalSince1970
        XCTAssertEqual(expectedSeconds, decodedSoconds, accuracy: 0.00001)
    }
    
    func testQuakeDetailsDecoder() throws {
        let decoder = JSONDecoder()
        let detail = try decoder.decode(QuakeLocation.self, from: testDetail_hv72783692)
        
        XCTAssertEqual(detail.latitude, 19.2189998626709, accuracy: 0.00000000001)
        XCTAssertEqual(detail.longitude, -155.434173583984, accuracy: 0.00000000001)
    }
    
    func testClientDoesFetchEarthquakeData() async throws {
        let downloader = TestDownloader()
        let client = QuakeClient(downloader: downloader)
        let quakes = try await client.quakes
        
        XCTAssertEqual(quakes.count, 6)
    }
}
