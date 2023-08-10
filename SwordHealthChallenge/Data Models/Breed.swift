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
    let breedGroup: String
    let lifeSpan: String
    let temperament: String
    let origin: String?
    let referenceImageId: String
    
    private enum CodingKeys: String, CodingKey {
        case weight, height, id, name, countryCode, bredFor, breedGroup, lifeSpan, temperament, origin, referenceImageId
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
