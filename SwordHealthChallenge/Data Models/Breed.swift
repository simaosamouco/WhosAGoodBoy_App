//
//  Breed.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 10/08/2023.
//

import Foundation
struct Breed: Codable {
    let weight: Weight?
    let height: Height?
    let id: Int
    let name: String?
    let countryCode: String?
    let bredFor: String?
    let breedGroup: String?
    let lifeSpan: String?
    let temperament: String?
    let origin: String?
    let referenceImageId: String?
    
    private enum CodingKeys: String, CodingKey {
        case weight, height, id, name, temperament, origin
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case lifeSpan = "life_span"
        case referenceImageId = "reference_image_id"
        case countryCode = "country_code"
    }
    
    init(id: Int, name: String?, breedGroup: String?, origin: String?, temperament: String?, weight: Weight?, height: Height?) {
           self.weight = weight
           self.height = height
           self.id = id
           self.name = name
           self.countryCode = nil
           self.bredFor = nil
           self.breedGroup = breedGroup
           self.lifeSpan = nil
           self.temperament = temperament
           self.origin = origin
           self.referenceImageId = nil
       }
}

struct Weight: Codable {
    let imperial: String
    let metric: String
    
    init(imperial: String, metric: String) {
        self.imperial = imperial
        self.metric = metric
    }
}

struct Height: Codable {
    let imperial: String
    let metric: String
    
    init(imperial: String, metric: String) {
        self.imperial = imperial
        self.metric = metric
    }
}
