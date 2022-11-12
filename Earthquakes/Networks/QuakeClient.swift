//
//  QuakeClient.swift
//  Earthquakes
//
//  Created by Mitul Vaghamshi on 2022-11-06.
//

import Foundation

actor QuakeClient {
    private let quakeCache: QuackCache = NSCache()
    private let downloader: any HTTPDataDownloader
    private let feedURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!
    private lazy var decoder: JSONDecoder = {
        let tempDecoder = JSONDecoder()
        tempDecoder.dateDecodingStrategy = .millisecondsSince1970
        return tempDecoder
    }()
    
    init(downloader: any HTTPDataDownloader = URLSession.shared) {
        self.downloader = downloader
    }
    
    var quakes: [Quake] {
        get async throws {
            let data = try await downloader.httpData(from: feedURL)
            let allQuakes = try decoder.decode(GeoJSON.self, from: data)
            var updatedQuakes = allQuakes.quakes
            if let olderThenOneHour = updatedQuakes.firstIndex(where: { $0.time.timeIntervalSinceNow > 3600 }) {
                let indexRange = updatedQuakes.startIndex..<olderThenOneHour
                try await withThrowingTaskGroup(of: (Int, QuakeLocation).self) { group in
                    for index in indexRange {
                        group.addTask {
                            let location = try await self.quakeLocation(from: allQuakes.quakes[index].detail)
                            return (index, location)
                        }
                    }
                    while let result = await group.nextResult() {
                        switch result {
                        case .success(let (index, location)):
                            updatedQuakes[index].location = location
                        case .failure(let error):
                            throw error
                        }
                    }
                }
            }
            return updatedQuakes
        }
    }
}

extension QuakeClient {
    private typealias QuackCache = NSCache<NSString, CacheEntryObject>
    private typealias QuakeTask = Task<QuakeLocation, Error>
}

extension QuakeClient {
    func quakeLocation(from url: URL) async throws -> QuakeLocation {
        if let cached = quakeCache[url] {
            switch cached {
            case .inProgress(let task):
                return try await task.value
            case .ready(let quakeLocation):
                return quakeLocation
            }
        }
        let task = QuakeTask {
            let data = try await downloader.httpData(from: url)
            let location = try decoder.decode(QuakeLocation.self, from: data)
            return location
        }
        quakeCache[url] = .inProgress(task)
        do {
            let location = try await task.value
            quakeCache[url] = .ready(location)
            return location
        } catch {
            quakeCache[url] = nil
            throw error
        }
    }
}
