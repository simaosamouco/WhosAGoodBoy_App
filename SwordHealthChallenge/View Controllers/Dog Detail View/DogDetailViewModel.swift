//
//  DogDetailViewModel.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 12/08/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DogDetailViewModel {
    
    let isInDatabase = BehaviorRelay<Bool>(value: false)
    
    var dogProfile: DogProfile
    private let services: ServicesManagerProtocol
    private let realm: RealmManagerProtocol
    
    init(dogProfile: DogProfile, services: ServicesManagerProtocol, realm: RealmManagerProtocol) {
        self.dogProfile = dogProfile
        self.services = services
        self.realm = realm
    }
    
    func fetchImageFromURL(completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: dogProfile.imageUrl) {
            services.downloadImage(from: url) { result in
                switch result {
                case .success(let image):
                    if let image = image {
                        completion(image)
                    } else {
                        completion(UIImage(named: "dog_icon"))
                    }
                case .failure(_):
                    completion(UIImage(named: "dog_icon"))
                }
            }
        }
    }
    
    func bookMarkButtonTapped(){
        isInDatabase.value ? deleteDogFromDatabase(dogProfile) : addDogToDatabase(dogProfile)
        checkIfDogIsInDatabase()
    }
    
    //MARK: - Realm Interactions
    func checkIfDogIsInDatabase() {
        isInDatabase.accept(retrieveDogFromDatabase() != nil)
   }
    
    private func addDogToDatabase(_ dog: DogProfile) {
        
        let dogRealm = DogProfileRealm(dog: dog)
        
        do {
            try realm.saveObject(dogRealm)
        } catch {
            print("Error adding Dog to database: \(error)")
            return
        }
    }
    
    private func deleteDogFromDatabase(_ dog: DogProfile) {
        let dogRealm = DogProfileRealm(dog: dog)
        do {
            try realm.deleteObject(dogRealm)
        } catch {
            print("Error deleting Dog from the database: \(error)")
            return
        }
    }
    
    private func retrieveDogFromDatabase() -> DogProfileRealm? {
        let dogRealm = DogProfileRealm(dog: dogProfile)
        do {
            return try realm.getObject(ofType: DogProfileRealm.self, primaryKey: dogRealm.id)
        } catch {
            return nil
        }
    }
}
