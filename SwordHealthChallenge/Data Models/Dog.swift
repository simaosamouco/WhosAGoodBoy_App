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
    
    init(breeds: [Breed], id: String, url: String, width: Int, height: Int) {
        self.breeds = breeds
        self.id = id
        self.url = url
        self.width = width
        self.height = height
    }
}
