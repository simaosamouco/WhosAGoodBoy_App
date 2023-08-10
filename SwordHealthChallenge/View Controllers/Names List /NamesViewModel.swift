//
//  NamesViewModel.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 10/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class NamesViewModel {
    
    let dogsList = BehaviorRelay<[Dog]>(value: [])
    let filteredDogsList = BehaviorRelay<[Dog]>(value: [])
    let searchQuery = BehaviorRelay<String>(value: "")
    
    private let bag = DisposeBag()
    
    let services: ServicesManagerProtocol
    
    init(services: ServicesManagerProtocol) {
        self.services = services
        
        Observable.combineLatest(dogsList, searchQuery)
            .map { array, query in
                if query == "" {
                    return array
                } else {
                    return array.filter { dog in
                        if let dog = dog.breeds.first {
                            return dog!.name.lowercased().contains(query.lowercased())
                        } else { return false }
                    }
                }
            }
            .bind(to: filteredDogsList)
            .disposed(by: bag)
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
    
}
