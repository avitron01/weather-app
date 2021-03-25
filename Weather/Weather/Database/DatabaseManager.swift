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
    
    func saveValue<T: Object>(_ object: T) {
        try! localRealm.write {
            localRealm.add(object, update: .modified)
        }
    }
}
