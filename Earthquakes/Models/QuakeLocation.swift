//
//  QuakeLocation.swift
//  Earthquakes
//
//  Created by Mitul Vaghamshi on 2022-11-06.
//

import Foundation

struct QuakeLocation: Decodable {
    var latitude: Double { properties.products.origin.first!.properties.letitude }
    var longitude: Double { properties.products.origin.first!.properties.longitude }
    
    private var properties: RootProperties
    
    init(lat: Double, lng: Double) {
        self.properties = RootProperties(products: Products(origin: [
            Origin(properties: OriginProperties(letitude: lat, longitude: lng))
        ]))
    }
}

extension QuakeLocation {
    struct RootProperties: Decodable {
        var products: Products
    }
    
    struct Products: Decodable {
        var origin: [Origin]
    }
    
    struct Origin: Decodable {
        var properties: OriginProperties
    }
    
    struct OriginProperties: Decodable {
        let letitude: Double
        let longitude: Double
    }
}

extension QuakeLocation.OriginProperties {
    private enum OriginPropertiesCodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OriginPropertiesCodingKeys.self)
        
        let letitude = try container.decode(String.self, forKey: .latitude)
        let longitude = try container.decode(String.self, forKey: .longitude)
        
        guard let letitude = Double(letitude), let longitude = Double(longitude) else {
            throw QuakeError.missingData
        }
        
        self.letitude = letitude
        self.longitude = longitude
    }
}
