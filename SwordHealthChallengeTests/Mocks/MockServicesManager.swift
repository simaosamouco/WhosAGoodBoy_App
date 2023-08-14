//
//  MockServicesManager.swift
//  SwordHealthChallengeTests
//
//  Created by Simão Neves Samouco on 14/08/2023.
//

import UIKit

@testable import SwordHealthChallenge

class MockServicesManager: ServicesManagerProtocol {
    
    var stubDogsList: Result<[Dog], Error>?
    func getDogsList(completion: @escaping APICompletion<[Dog]>) {
        if let stub = stubDogsList {
            completion(stub)
        }
    }
    
    
    var stubImageFetch: Result<UIImage?, Error>?
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        if let image = stubImageFetch {
            completion(image)
        }
    }
}


