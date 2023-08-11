//
//  ServicesManager.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 10/08/2023.
//

import Foundation
import Alamofire

typealias APICompletion<T: Decodable> = (Result<T, Error>) -> Void

protocol ServicesManagerProtocol: AnyObject {
    func getDogsList(completion: @escaping APICompletion<[Dog]>)
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

class ServicesManager: ServicesManagerProtocol {
    
    private let baseURL = "https://api.thedogapi.com/v1/images/search?"
    private let apiKey = "live_nWyKMkMyWVKzB7IQIvk837QmwLPRSnnS19i5NODFqw9H6615UAY1YcmUzDeFY7tP"
    
    init() {}
    
    private func callApi<T: Decodable>(endpoint: String, method: HTTPMethod, parameters: Parameters? = nil, completion: @escaping APICompletion<T>) {
        
        AF.request(endpoint, method: method, parameters: parameters)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getDogsList(completion: @escaping APICompletion<[Dog]>) {
        //It might be needed to add "page" in the parameters later
        let parameters: Parameters = [
            "limit": 20,
            "has_breeds": 1,
            "api_key": apiKey
        ]
        
        callApi(endpoint: baseURL, method: .get, parameters: parameters, completion: completion)
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            AF.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        completion(image)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print("Error downloading image: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
}
