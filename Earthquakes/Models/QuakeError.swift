//
//  QuakeError.swift
//  Earthquakes
//
//  Created by Mitul Vaghamshi on 2022-11-06.
//

import Foundation

enum QuakeError: Error {
    case missingData
    case networkError
}

extension QuakeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingData:
            return NSLocalizedString("Found and will discard a quake missing a valid code, magnitude, place, or time.", comment: "Missing data error description")
        case .networkError:
            return NSLocalizedString("", comment: "")
        }
    }
}
