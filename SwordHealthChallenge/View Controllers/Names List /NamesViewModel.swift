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
    
    // MARK: - Properties
    
    let dogsProfileList = BehaviorRelay<[DogProfile]>(value: [])
    let filteredDogsList = BehaviorRelay<[DogProfile]>(value: [])
    let searchQuery = BehaviorRelay<String>(value: "")
    
    private let navigateToDetailView = PublishSubject<DogDetailViewController>()
    var actionNavigateToDetailView: Observable<DogDetailViewController> {
        return navigateToDetailView.asObservable()
    }
    
    let somethingWentWrongRelay = PublishSubject<Void>()
    func somethingWentWrong() -> Observable<Void> {
        return somethingWentWrongRelay.asObservable()
    }
    
    private let bag = DisposeBag()
    let services: ServicesManagerProtocol
    let realm: RealmManagerProtocol
    
    // MARK: - Initialization
    
    init(services: ServicesManagerProtocol, realm: RealmManagerProtocol) {
        self.services = services
        self.realm = realm
        
        Observable.combineLatest(dogsProfileList, searchQuery)
            .map { array, query in
                if query.isEmpty {
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
    
    // MARK: - Methods
    
    func getDogsList() {
        services.getDogsList { [weak self] result in
            switch result {
            case .success(let dogs):
                let dogProfiles = dogs.map { DogProfile(dog: $0) }
                self?.dogsProfileList.accept(dogProfiles)
            case .failure(_):
                self?.somethingWentWrongRelay.onNext(())
            }
        }
    }
    
    func cellSelected(_ dogProfile: DogProfile) {
        let detailViewModel = DogDetailViewModel(dogProfile: dogProfile, services: services, realm: realm)
        let detailVC = DogDetailViewController(viewModel: detailViewModel)
        navigateToDetailView.onNext(detailVC)
    }
}
