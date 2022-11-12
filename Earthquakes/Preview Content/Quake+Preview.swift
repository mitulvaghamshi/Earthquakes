//
//  Quake+Preview.swift
//  Earthquakes
//
//  Created by Mitul Vaghamshi on 2022-11-11.
//

import Foundation

extension Quake {
    static var preview: Quake {
        let quake = Quake(
            magnitude: 0.34,
            place: "Shakey Acres",
            time: Date(timeIntervalSinceNow: -1000),
            code: "nc73649170",
            detail: URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/nc73649170.geojson")!,
            location: QuakeLocation(lat: 19.2189998626709, lng: -155.434173583984)
        )
        return quake
    }
}
