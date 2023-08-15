//
//  DogProfile.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 12/08/2023.
//

import Foundation
import UIKit

struct DogProfile {
    let id: String
    let breedName: String
    let breedGroup: String
    let origin: String
    let imageUrl: String
    let width: Int
    let height: Int
    let temperament: String
    let bredFor: String
    var image: UIImage? = nil
    
    init(dog: Dog){
        self.id = dog.id
        self.imageUrl = dog.url
        self.height = dog.height
        self.width = dog.width
        let breed = dog.breeds.first!
        self.bredFor = breed.bredFor ?? "(not specified)"
        self.breedGroup = breed.breedGroup ?? "(not specified)"
        self.breedName = breed.name ?? "(not specified)"
        self.origin = breed.origin ?? "(not specified)"
        self.temperament = breed.temperament ?? "(not specified)"
    }
    
    init(id: String, breedName: String, breedGroup: String, origin: String, imageUrl: String, width: Int, height: Int, temperament: String, bredFor: String) {
        self.id = id
        self.breedName = breedName
        self.breedGroup = breedGroup
        self.origin = origin
        self.imageUrl = imageUrl
        self.width = width
        self.height = height
        self.temperament = temperament
        self.bredFor = bredFor
    }
}
