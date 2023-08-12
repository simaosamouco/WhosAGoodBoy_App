//
//  ImagesViewModel.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 11/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class ImagesViewModel {
    
    private let bag = DisposeBag()
    
    let dogsProfileList = BehaviorRelay<[DogProfile]>(value: [])
    
    var isSortedAlphabetically: Bool = false
    
    let services: ServicesManagerProtocol
    
    init(services: ServicesManagerProtocol) {
        self.services = services
    }
    
    func orderListAlphabetically() {
        if !isSortedAlphabetically {
            let dogsd = dogsProfileList.value
            
            let sortedDogs = dogsd.map { dogs in
                return dogsd.sorted { (dog1, dog2) -> Bool in
                    let breedName1 = dog1.breedName
                    let breedName2 = dog2.breedName
                    return breedName1.localizedCaseInsensitiveCompare(breedName2) == .orderedAscending
                }
            }
            dogsProfileList.accept(sortedDogs.first!)
            isSortedAlphabetically.toggle()
        }
    }
    
    func getDogsList() {
        services.getDogsList(completion: { [weak self] result in
            switch result {
            case .success(let dogs):
                let dogProfiles = dogs.map { DogProfile(dog: $0) }
                self?.fetchImagesForDogProfiles(dogProfiles)
            case .failure(let error):
                print("Error retrieving Dogs List: \(error.localizedDescription)")
            }
        })
    }
    
    private func fetchImagesForDogProfiles(_ dogProfiles: [DogProfile]) {
        var dogProfilesAux = dogProfiles
        for (index, dog) in dogProfilesAux.enumerated() {
            self.fetchImageFromURL(from: URL(string: dog.imageUrl)!, completion: { image in
                dogProfilesAux[index].image = image
                self.dogsProfileList.accept(dogProfilesAux)
            })
        }
    }
   
    private func fetchImageFromURL(from url: URL, completion: @escaping (UIImage?) -> Void) {
        services.downloadImage(from: url, completion: completion)
    }
}
