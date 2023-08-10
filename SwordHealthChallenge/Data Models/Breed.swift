//
//  Breed.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 10/08/2023.
//

import Foundation
struct Breed: Codable {
    let weight: Weight
    let height: Height
    let id: Int
    let name: String
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
}

struct Weight: Codable {
    let imperial: String
    let metric: String
}

struct Height: Codable {
    let imperial: String
    let metric: String
}
