//
//  MockRealmManager.swift
//  SwordHealthChallengeTests
//
//  Created by Simão Neves Samouco on 16/08/2023.
//

import Foundation
import RealmSwift
@testable import SwordHealthChallenge

class MockRealmManager: RealmManagerProtocol {
    var realmQueue: DispatchQueue { DispatchQueue(label: "mockDbQueue") }
    
    private var mockObjects: [Object] = []
    
    func saveObject<T: Object>(_ object: T) throws {
        mockObjects.append(object)
    }
    
    func getAllObjects<T: Object>(ofType type: T.Type) throws -> [T] {
        return mockObjects.compactMap { $0 as? T }
    }
    
    func deleteObject<T: Object>(_ object: T) throws {
        mockObjects.removeAll { $0.isEqual(object) }
    }
    
    func getObject<T: Object>(ofType type: T.Type, primaryKey: Any) throws -> T {
        guard let object = mockObjects.first(where: { $0.isEqual(primaryKey) }) as? T else {
            throw RealmManagerError.nonExistentID
        }
        return object
    }
}
