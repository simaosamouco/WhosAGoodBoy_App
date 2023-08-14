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
    
    func getDogs() {
        getDogsListFromService { dogProfiles, error in
            if let dogProfiles = dogProfiles {
                self.fetchImagesForDogProfiles(dogProfiles)
                self.isSortedAlphabetically = false
            } else if let error = error {
                print("Error fetching dogProfiles: \(error.localizedDescription)")
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
                print("Error retrieving Dogs List: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchImagesForDogProfiles(_ dogProfiles: [DogProfile]) {
        for (index, dog) in dogProfiles.enumerated() {
            
            if let url = URL(string: dog.imageUrl) {
                
                self.fetchImageFromURL(from: url, completion: { image in
                    var dogAux = dogProfiles[index]
                    dogAux.image = image
                    
                    var currentValues = self.dogsProfileList.value
                    currentValues.append(dogAux)
                    
                    self.dogsProfileList.accept(currentValues)
                })
            }
        }
    }
    
    func cellSelected(_ dogProfile: DogProfile) {
        let detailViewModel = DogDetailViewModel(dogProfile: dogProfile, services: services)
        let detailVC = DogDetailViewController(viewModel: detailViewModel)
        navigateToDetailView.onNext(detailVC)
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
                // Handle the error
                print("Error downloading image: \(error.localizedDescription)")
            }
        }
    }
}
