//
//  DogListManager.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 27/09/2023.
//

import Foundation

protocol DogListManagerProtocol {
    func sortAlphabetically(_ dogList: [DogProfile]) -> [DogProfile]
    func filterByName(_ dogList: [DogProfile], query: String) -> [DogProfile]
}

class DogListManager: DogListManagerProtocol {
    func sortAlphabetically(_ dogList: [DogProfile]) -> [DogProfile] {
        return dogList.sorted {
            $0.breedName.localizedCaseInsensitiveCompare($1.breedName) == .orderedAscending
        }
    }
    
    func filterByName(_ dogList: [DogProfile], query: String) -> [DogProfile] {
        return dogList.filter { dog in
            return dog.breedName.lowercased().contains(query.lowercased())
        }
    }
}
