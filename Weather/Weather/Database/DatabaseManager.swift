//
//  DatabaseManager.swift
//  Weather
//
//  Created by Avinash P on 25/03/21.
//

import Foundation
import RealmSwift



class DatabaseManager {
    static let shared = DatabaseManager()
    let localRealm: Realm
    
    init() {
        localRealm = try! Realm()
    }
    
    func fetchValues<Type: Object>(of type: Type.Type) -> Results<Type> {
        localRealm.objects(type)
    }
    
    func fetchValues<Type: Object, KeyType>(of type: Type.Type, primaryKey: KeyType) -> Type? {
        localRealm.object(ofType: type, forPrimaryKey: primaryKey)
    }
    
    func saveValue<T: Object>(_ object: T) {
        try! localRealm.write {
            localRealm.add(object, update: .modified)
        }
    }
    
    func deleteValue<T: Object>(_ object: T) {
        localRealm.delete(object)        
    }
    
    func addObserver<Type: Object>(for type: Type.Type, observer: @escaping (RealmCollectionChange<Results<Type>>) -> Void)
    -> NotificationToken {
        let results = fetchValues(of: type)
        return results.observe(observer)
    }
}


