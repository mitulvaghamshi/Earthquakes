//
//  CacheEntryObject.swift
//  Earthquakes
//
//  Created by Mitul Vaghamshi on 2022-11-06.
//

import Foundation

enum CacheEntry {
    case inProgress(Task<QuakeLocation, Error>)
    case ready(QuakeLocation)
}

final class CacheEntryObject {
    let entry: CacheEntry
    
    init(entry: CacheEntry) {
        self.entry = entry
    }
}
