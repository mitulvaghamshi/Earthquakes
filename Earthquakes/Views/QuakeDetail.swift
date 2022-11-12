//
//  QuakeDetail.swift
//  Earthquakes
//
//  Created by Mitul Vaghamshi on 2022-11-11.
//

import SwiftUI

struct QuakeDetail: View {
    @EnvironmentObject private var quakeProvider: QuakesProvider
    @State private var location: QuakeLocation? = nil
    @State private var viewFullPrecision = false
    
    var quake: Quake
    
    var body: some View {
        VStack {
            if let location = self.location {
                QuakeDetailMap(
                    tintColor: quake.color,
                    quakePlace: QuakePlace(location: location))
                .ignoresSafeArea(.container)
            }
            QuakeMagnitude(quake: quake)
            Text(quake.place)
                .font(.title3)
                .bold()
            Text(quake.time.formatted())
                .foregroundStyle(.secondary)
            if let location = self.location {
                Group {
                    if viewFullPrecision {
                        Text("Latitude: \(location.latitude)")
                        Text("Longitude: \(location.longitude)")
                    } else {
                        Text("Latitude: \(location.latitude.format())")
                        Text("Longitude: \(location.longitude.format())")
                    }
                }
                .onTapGesture { viewFullPrecision.toggle() }
            }
        }
        .task {
            if self.location == nil {
                if let quakeLocation = quake.location {
                    self.location = quakeLocation
                } else {
                    self.location = try? await quakeProvider.location(for: quake)
                }
            }
        }
    }
}

struct QuakeDetail_Previews: PreviewProvider {
    static var previews: some View {
        QuakeDetail(quake: .preview)
    }
}

extension Double {
    func format() -> String {
        self.formatted(.number.precision(.fractionLength(3)))
    }
}
