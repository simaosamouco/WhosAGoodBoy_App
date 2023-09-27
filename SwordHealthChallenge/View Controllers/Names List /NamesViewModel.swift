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
    
    private let navigateToDetailViewRelay = PublishSubject<DogDetailViewController>()
    var navigateToDetailView: Observable<DogDetailViewController> {
        return navigateToDetailViewRelay.asObservable()
    }
    
    let somethingWentWrongRelay = PublishSubject<Void>()
    func somethingWentWrong() -> Observable<Void> {
        return somethingWentWrongRelay.asObservable()
    }
    
    private let bag = DisposeBag()
    let services: ServicesManagerProtocol
    let realm: RealmManagerProtocol
    let dogListManager: DogListManagerProtocol
    
    // MARK: - Initialization
    
    init(services: ServicesManagerProtocol, realm: RealmManagerProtocol, dogListManager: DogListManagerProtocol) {
        self.services = services
        self.realm = realm
        self.dogListManager = dogListManager
        
        setUpBindings()
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
    
    func setUpBindings() {
        Observable.combineLatest(dogsProfileList, searchQuery)
            .map { [weak self] array, query in
                if query.isEmpty {
                    return array
                } else {
                    return self?.dogListManager.filterByName(array, query: query) ?? array
                }
            }
            .bind(to: filteredDogsList)
            .disposed(by: bag)
    }
    
    //MARK: - Navigaiton
    func cellSelected(_ dogProfile: DogProfile) {
        let detailViewModel = DogDetailViewModel(dogProfile: dogProfile, services: services, realm: realm)
        let detailVC = DogDetailViewController(viewModel: detailViewModel)
        navigateToDetailViewRelay.onNext(detailVC)
    }
}
