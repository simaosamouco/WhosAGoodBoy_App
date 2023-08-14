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
    
    
    var stubImageFetch: UIImage?
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let image = stubImageFetch {
            completion(image)
        }
    }
}


