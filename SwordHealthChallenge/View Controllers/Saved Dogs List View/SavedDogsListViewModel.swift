//
//  SavedDogsListViewModel.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 15/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class SavedDogsListViewModel {

    // MARK: - Properties

    let dogsProfileList = BehaviorRelay<[DogProfile]>(value: [])
    let listIsEmpty = BehaviorRelay<Bool>(value: true)

    private let navigateToDetailView = PublishSubject<DogDetailViewController>()
    var actionNavigateToDetailView: Observable<DogDetailViewController> {
        return navigateToDetailView.asObservable()
    }

    let somethingWentWrongRelay = PublishSubject<Void>()
    func somethingWentWrong() -> Observable<Void> {
        return somethingWentWrongRelay.asObservable()
    }

    let services: ServicesManagerProtocol
    let realm: RealmManagerProtocol

    // MARK: - Initialization

    init(service: ServicesManagerProtocol, realm: RealmManagerProtocol) {
        self.services = service
        self.realm = realm
    }

    // MARK: - Public Methods

    func getDogsList() {
        realm.realmQueue.sync {
            if let savedDogProfiles = getDogsFromDatabase()?.map({ DogProfile(savedDog: $0) }) {
                dogsProfileList.accept(savedDogProfiles)
                listIsEmpty.accept(savedDogProfiles.isEmpty)
            }
        }
    }

    // MARK: - Private Methods

    private func getDogsFromDatabase() -> [DogProfileRealm]? {
        do {
            return try realm.getAllObjects(ofType: DogProfileRealm.self)
        } catch {
            somethingWentWrongRelay.onNext(())
            print("Error retrieving objects: \(error)")
            return nil
        }
    }

    // MARK: - Navigation

    func cellSelected(_ dogProfile: DogProfile) {
        let detailViewModel = DogDetailViewModel(dogProfile: dogProfile, services: services, realm: realm)
        let detailVC = DogDetailViewController(viewModel: detailViewModel)
        navigateToDetailView.onNext(detailVC)
    }

}
