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
    
    let dogsList = BehaviorRelay<[Dog]>(value: [])
    
    var isSortedAlphabetically: Bool = false
    
    let services: ServicesManagerProtocol
    
    init(services: ServicesManagerProtocol) {
        self.services = services
    }
    
    func orderListAlphabetically() {
        if !isSortedAlphabetically {
            let dogsd = dogsList.value
            
            let sortedDogs = dogsd.map { dogs in
                return dogsd.sorted { (dog1, dog2) -> Bool in
                    let breedName1 = dog1.breeds.first??.name ?? ""
                    let breedName2 = dog2.breeds.first??.name ?? ""
                    return breedName1.localizedCaseInsensitiveCompare(breedName2) == .orderedAscending
                }
            }
            dogsList.accept(sortedDogs.first!)
            isSortedAlphabetically.toggle()
        }
    }
    
    func getDogsList() {
        services.getDogsList(completion: { [weak self] result in
            switch result {
            case .success(let dogs):
                print(dogs.count)
                self?.dogsList.accept(dogs)
            case .failure(let error):
                print("Error retrieving Dogs List: \(error.localizedDescription)")
            }
        })
    }
    
    func fetchImageFromURL(from url: URL, completion: @escaping (UIImage?) -> Void) {
        services.downloadImage(from: url, completion: completion)
    }
}
