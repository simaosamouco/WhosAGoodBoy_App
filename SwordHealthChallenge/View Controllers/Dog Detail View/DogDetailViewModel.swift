//
//  DogDetailViewModel.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 12/08/2023.
//

import Foundation
class DogDetailViewModel {
    
    var dogProfile: DogProfile
    
    init(dogProfile: DogProfile, services: ServicesManagerProtocol) {
        self.dogProfile = dogProfile
    }
}
