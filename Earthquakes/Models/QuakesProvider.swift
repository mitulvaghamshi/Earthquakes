//
//  QuakesProvider.swift
//  Earthquakes
//
//  Created by Mitul Vaghamshi on 2022-11-06.
//

import Foundation

@MainActor
class QuakesProvider: ObservableObject {
    @Published var quakes: [Quake] = []
    
    let client: QuakeClient
    
    init(client: QuakeClient = QuakeClient()) {
        self.client = client
    }
    
    func fetchQuakes() async throws {
        let latestQuakes = try await client.quakes
#if DEBUG
        if latestQuakes.first!.location == nil {
            let modifiedLocation = latestQuakes.map {
                var quake = $0
                quake.location = QuakeLocation(
                    lat: Double.random(in: -90...90),
                    lng: Double.random(in: -180...180)
                )
                return quake
            }
            self.quakes = modifiedLocation
        }
#else
        self.quakes = latestQuakes
#endif
    }
    
    func location(for quake: Quake) async throws -> QuakeLocation {
        return try await client.quakeLocation(from: quake.detail)
    }
    
    func deleteQuakes(atOffsets offsets: IndexSet) {
        quakes.remove(atOffsets: offsets)
    }
}
