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
    
    private let somethingWentWrongRelay = PublishSubject<Void>()
    func somethingWentWrong() -> Observable<Void> {
        return somethingWentWrongRelay.asObservable()
    }
    
    private var isSortedAlphabetically: Bool = false
    
    let imageCache = NSCache<NSString, UIImage>()
    
    let services: ServicesManagerProtocol
    let realm: RealmManagerProtocol
    
    // MARK: - Initialization
    init(services: ServicesManagerProtocol, realm: RealmManagerProtocol) {
        self.services = services
        self.realm = realm
    }
    
    func getDogs() {
        isFetchingRelay.onNext(true)
        services.getDogsList { [weak self] result in
            switch result {
            case .success(let dogs):
                let dogProfiles = dogs.map { DogProfile(dog: $0) }
                self?.dogsProfileList.accept((self?.dogsProfileList.value)! + dogProfiles)
                self?.isSortedAlphabetically = false
                self?.isFetchingRelay.onNext(false)
            case .failure(_):
                self?.somethingWentWrongRelay.onNext(())
            }
        }
    }
    
    func getImage(from dog: DogProfile, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: dog.imageUrl) else {
            completion(UIImage(named: "dog_icon")!)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: NSString(string: dog.imageUrl)) {
            completion(cachedImage)
            return
        }
        
        services.downloadImage(from: url) { [weak self] result in
            switch result {
            case .success(let image):
                if let image = image {
                    self?.imageCache.setObject(image, forKey: NSString(string: dog.imageUrl))
                    completion(image)
                } else {
                    completion(UIImage(named: "dog_icon")!)
                }
            case .failure(_):
                completion(UIImage(named: "dog_icon")!)
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
}
