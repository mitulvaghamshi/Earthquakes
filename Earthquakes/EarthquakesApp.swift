//
//  EarthquakesApp.swift
//  Earthquakes
//
//  Created by Mitul Vaghamshi on 2022-11-06.
//

import SwiftUI

@main
struct EarthquakesApp: App {
    @StateObject var quakesProvider = QuakesProvider()
    
    var body: some Scene {
        WindowGroup {
            Quakes().environmentObject(quakesProvider)
        }
    }
}
