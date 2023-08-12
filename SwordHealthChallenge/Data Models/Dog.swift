//
//  Dog.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 10/08/2023.
//

import Foundation

struct Dog: Codable {
    let breeds: [Breed]
    let id: String
    let url: String
    let width: Int
    let height: Int
    
    private enum CodingKeys: String, CodingKey {
            case id, url, width, height, breeds
        }
}
