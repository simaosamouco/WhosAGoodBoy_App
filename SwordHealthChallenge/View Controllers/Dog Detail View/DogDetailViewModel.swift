//
//  DogDetailViewModel.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 12/08/2023.
//

import Foundation
import UIKit
class DogDetailViewModel {
    
    var dogProfile: DogProfile
    private let services: ServicesManagerProtocol
    
    init(dogProfile: DogProfile, services: ServicesManagerProtocol) {
        self.dogProfile = dogProfile
        self.services = services
    }
    
    func fetchImageFromURL(completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: dogProfile.imageUrl) {
            services.downloadImage(from: url) { downloadedImage in
                self.dogProfile.image = downloadedImage
                completion(downloadedImage)
            }
        }
    }
}
