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
    
    private let navigateToDetailViewRelay = PublishSubject<DogDetailViewController>()
    var navigateToDetailView: Observable<DogDetailViewController> {
        return navigateToDetailViewRelay.asObservable()
    }
    
    private let isFetchingRelay = PublishSubject<Bool>()
    var isFetching: Observable<Bool> {
        return isFetchingRelay.asObservable()
    }
    
    let somethingWentWrongRelay = PublishSubject<Void>()
    func somethingWentWrong() -> Observable<Void> {
        return somethingWentWrongRelay.asObservable()
    }
    
    private var isSortedAlphabetically: Bool = false
    
    let services: ServicesManagerProtocol
    let realm: RealmManagerProtocol
    
    // MARK: - Initialization
    
    init(services: ServicesManagerProtocol, realm: RealmManagerProtocol) {
        self.services = services
        self.realm = realm
    }
    
    // MARK: - Public Methods
    
    func getDogs() {
        getDogsListFromService { dogProfiles, error in
            if let dogProfiles = dogProfiles {
                self.fetchImagesForDogProfiles(dogProfiles)
                self.isSortedAlphabetically = false
            } else if error != nil {
                self.somethingWentWrongRelay.onNext(())
            }
        }
    }
    
    func getDogsListFromService(completion: @escaping ([DogProfile]?, Error?) -> Void) {
        isFetchingRelay.onNext(true)
        services.getDogsList { [weak self] result in
            self?.isFetchingRelay.onNext(false)
            switch result {
            case .success(let dogs):
                let dogProfiles = dogs.map { DogProfile(dog: $0) }
                completion(dogProfiles, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchImagesForDogProfiles(_ dogProfiles: [DogProfile]) {
        for (index, dog) in dogProfiles.enumerated() {
            
            if let url = URL(string: dog.imageUrl) {
                
                self.fetchImageFromURL(from: url, completion: { [weak self] image in
                    var dogAux = dogProfiles[index]
                    dogAux.image = image
                    if var currentValues = self?.dogsProfileList.value {
                        currentValues.append(dogAux)
                        self?.dogsProfileList.accept(currentValues)
                    }
                })
            }
        }
    }
    
    func orderListAlphabetically() {
        guard !isSortedAlphabetically else {
            return
        }
        let sortedDogs = dogsProfileList.value.sorted {
            $0.breedName.localizedCaseInsensitiveCompare($1.breedName) == .orderedAscending
        }
        dogsProfileList.accept(sortedDogs)
        isSortedAlphabetically = true
    }
    
    // MARK: - Navigation
    
    func cellSelected(_ dogProfile: DogProfile) {
        let detailViewModel = DogDetailViewModel(dogProfile: dogProfile, services: services, realm: realm)
        let detailVC = DogDetailViewController(viewModel: detailViewModel)
        navigateToDetailViewRelay.onNext(detailVC)
    }
    
    private func fetchImageFromURL(from url: URL, completion: @escaping (UIImage?) -> Void) {
        services.downloadImage(from: url) { result in
            switch result {
            case .success(let image):
                if let image = image {
                    completion(image)
                } else {
                    completion(UIImage(named: "dog_icon"))
                }
            case .failure(let error):
                print("Error downloading image: \(error.localizedDescription)")
            }
        }
    }
}
