//
//  RealmStorage.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/11/24.
//

import Foundation
import RealmSwift

class RealmStorage {
    static let shared = RealmStorage()
    private init() {
        self.realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    let realm: Realm
    
    // TODO: 마이그레이션 작업 필요 시 작성
    func configurateSchemaVersion() {
        
    }
}
