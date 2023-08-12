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
    
    let dogsProfileList = BehaviorRelay<[DogProfile]>(value: [])
    let filteredDogsList = BehaviorRelay<[DogProfile]>(value: [])
    let searchQuery = BehaviorRelay<String>(value: "")
    
    private let navigateToDetailView = PublishSubject<DogDetailViewController>()
    var actionNavigateToDetailView: Observable<DogDetailViewController> {
        return navigateToDetailView.asObservable()
    }
    
    private let bag = DisposeBag()
    
    let services: ServicesManagerProtocol
    
    init(services: ServicesManagerProtocol) {
        self.services = services
        
        Observable.combineLatest(dogsProfileList, searchQuery)
            .map { array, query in
                if query == "" {
                    return array
                } else {
                    return array.filter { dog in
                        return dog.breedName.lowercased().contains(query.lowercased())
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
                let dogProfiles = dogs.map { DogProfile(dog: $0) }
                self?.dogsProfileList.accept(dogProfiles)
            case .failure(let error):
                print("Error retrieving Dogs List: \(error.localizedDescription)")
            }
        })
    }
    
    func cellSelected(_ dogProfile: DogProfile) {
        let detailViewModel = DogDetailViewModel(dogProfile: dogProfile, services: services)
        let detailVC = DogDetailViewController(viewModel: detailViewModel)
        navigateToDetailView.onNext(detailVC)
    }
    
}
