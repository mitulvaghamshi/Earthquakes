//
//  QuakeDetailMap.swift
//  Earthquakes
//
//  Created by Mitul Vaghamshi on 2022-11-11.
//

import SwiftUI
import MapKit

struct QuakeDetailMap: View {
    let tintColor: Color
    let quakePlace: QuakePlace
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [quakePlace]) { place in
            MapMarker(coordinate: place.location, tint: tintColor)
        }
        .onAppear { withAnimation {
            region.center = quakePlace.location
            region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        }}
    }
}

struct QuakePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID = UUID(), location: QuakeLocation) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: location.latitude, longitude: location.longitude)
    }
}
