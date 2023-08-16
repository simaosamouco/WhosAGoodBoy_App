//
//  DogProfileRealm.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 15/08/2023.
//

import Foundation
import RealmSwift

class DogProfileRealm: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var breedName: String = ""
    @Persisted var breedGroup: String = ""
    @Persisted var origin: String = ""
    @Persisted var imageUrl: String = ""
    @Persisted var width: Int = 0
    @Persisted var height: Int = 0
    @Persisted var temperament: String = ""
    @Persisted var bredFor: String = ""
    
    convenience init(dog: DogProfile) {
        self.init()
        self.id = dog.id
        self.imageUrl = dog.imageUrl
        self.height = dog.height
        self.width = dog.width
        self.bredFor = dog.bredFor
        self.breedGroup = dog.breedGroup
        self.breedName = dog.breedName
        self.origin = dog.origin
        self.temperament = dog.temperament
    }
}
