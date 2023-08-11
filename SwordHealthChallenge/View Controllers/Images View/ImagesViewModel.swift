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
    
    let dogsList = BehaviorRelay<[Dog]>(value: [])
    
    let services: ServicesManagerProtocol
    
    init(services: ServicesManagerProtocol) {
        self.services = services
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
    
    func fetchImageFromURL(from url: URL, completion: @escaping (UIImage?) -> Void) {
        services.downloadImage(from: url, completion: completion)
    }
}
