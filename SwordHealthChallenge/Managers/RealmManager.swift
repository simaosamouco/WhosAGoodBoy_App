//
//  RealmManager.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 15/08/2023.
//

import Foundation
import RealmSwift

enum RealmManagerError: Error {
    case nonExistentID
}

protocol RealmManagerProtocol: AnyObject {
    func saveObject<T: Object>(_ object: T) throws
    func getAllObjects<T: Object>(ofType type: T.Type) throws -> [T]
    func deleteObject<T: Object>(_ object: T) throws
    func getObject<T: Object>(ofType type: T.Type, primaryKey: Any) throws -> T
    var realmQueue: DispatchQueue { get }
}

class RealmManager: RealmManagerProtocol {
    
    let realmQueue = DispatchQueue(label: "dbQueue")
    private let realm: Realm
    
    public init() {
        do {
            realm = try initialiseRealm(in: realmQueue)
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    func saveObject<T: Object>(_ object: T) throws {
        
        try realmQueue.sync {
            do {
                try realm.write {
                    realm.add(object)
                }
            } catch {
                print("Failed to save object: \(error)")
                throw error
            }
        }
    }
    
    func getAllObjects<T: Object>(ofType type: T.Type) throws -> [T] {
        let objects = realm.objects(type)
        return Array(objects)
    }
    
    func deleteObject<T: Object>(_ object: T) throws {
        try realmQueue.sync {
            do {
                try realm.write {
                    realm.add(object, update: .modified)
                    realm.delete(object)
                }
            } catch {
                print("Failed to delete object: \(error)")
                throw error
            }
        }
    }
    
    func getObject<T: Object>(ofType type: T.Type, primaryKey: Any) throws -> T {
        try realmQueue.sync { () -> T in
            guard let object = realm.object(ofType: type, forPrimaryKey: primaryKey) else {
                throw RealmManagerError.nonExistentID
            }
            
            return object
        }
    }
}

private func initialiseRealm(in queue: DispatchQueue) throws -> Realm {
    try queue.sync {
        try Realm(queue: queue)
    }
}
