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
    let dogListManager: DogListManagerProtocol
    
    // MARK: - Initialization
    init(services: ServicesManagerProtocol, realm: RealmManagerProtocol, dogListManager: DogListManagerProtocol) {
        self.services = services
        self.realm = realm
        self.dogListManager = dogListManager
    }
    
    func getDogs() {
        isFetchingRelay.onNext(true)
        services.getDogsList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let dogs):
                let dogProfiles = dogs.map { DogProfile(dog: $0) }
                self.dogsProfileList.accept(self.dogsProfileList.value + dogProfiles)
                self.isSortedAlphabetically = false
                self.isFetchingRelay.onNext(false)
            case .failure(_):
                self.somethingWentWrongRelay.onNext(())
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
        let sortedList = dogListManager.sortAlphabetically(dogsProfileList.value)
        dogsProfileList.accept(sortedList)
        isSortedAlphabetically = true
    }
    
    // MARK: - Navigation
    func cellSelected(_ dogProfile: DogProfile) {
        var dog = dogProfile
        if let cachedImage = imageCache.object(forKey: NSString(string: dog.imageUrl)) {
            dog.image = cachedImage
        }
        let detailViewModel = DogDetailViewModel(dogProfile: dog, services: services, realm: realm)
        let detailVC = DogDetailViewController(viewModel: detailViewModel)
        navigateToDetailViewRelay.onNext(detailVC)
    }
}
