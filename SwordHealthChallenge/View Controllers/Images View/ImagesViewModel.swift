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
    
    // MARK: - Properties
    
    private let bag = DisposeBag()
    let dogsProfileList = BehaviorRelay<[DogProfile]>(value: [])
    
    private let navigateToDetailView = PublishSubject<DogDetailViewController>()
    var actionNavigateToDetailView: Observable<DogDetailViewController> {
        return navigateToDetailView.asObservable()
    }
    
    private let isFetchingRelay = PublishSubject<Bool>()
    var isFetching: Observable<Bool> {
        return isFetchingRelay.asObservable()
    }
    
    private var isSortedAlphabetically: Bool = false
    
    let services: ServicesManagerProtocol
    
    // MARK: - Initialization
    
    init(services: ServicesManagerProtocol) {
        self.services = services
    }
    
    // MARK: - Public Methods
    
    func getDogsList() {
        isFetchingRelay.onNext(true)
        services.getDogsList { [weak self] result in
            switch result {
            case .success(let dogs):
                self?.isFetchingRelay.onNext(false)
                let dogProfiles = dogs.map { DogProfile(dog: $0) }
                self?.fetchImagesForDogProfiles(dogProfiles)
                self?.isSortedAlphabetically = false
            case .failure(let error):
                self?.isFetchingRelay.onNext(false)
                print("Error retrieving Dogs List: \(error.localizedDescription)")
            }
        }
    }
    
    func cellSelected(_ dogProfile: DogProfile) {
        let detailViewModel = DogDetailViewModel(dogProfile: dogProfile, services: services)
        let detailVC = DogDetailViewController(viewModel: detailViewModel)
        navigateToDetailView.onNext(detailVC)
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
    
    // MARK: - Private Methods
    
    private func fetchImagesForDogProfiles(_ dogProfiles: [DogProfile]) {
        var dogProfilesAux = dogProfiles
        for (index, dog) in dogProfilesAux.enumerated() {
            self.fetchImageFromURL(from: URL(string: dog.imageUrl)!, completion: { image in
                dogProfilesAux[index].image = image
                var currentValues = self.dogsProfileList.value
                currentValues.append(dogProfilesAux[index])
                self.dogsProfileList.accept(currentValues)
            })
        }
    }
   
    private func fetchImageFromURL(from url: URL, completion: @escaping (UIImage?) -> Void) {
        services.downloadImage(from: url, completion: completion)
    }
}
