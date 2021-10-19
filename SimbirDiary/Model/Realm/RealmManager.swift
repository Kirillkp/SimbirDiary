//
//  RealmManager.swift
//  SimbirDiary
//
//  Created by Кирилл on 13.10.2021.
//

import RealmSwift

@available (iOS 12, *)
class RealmManager {
    
    static let shared = RealmManager()
    
    private init() {}
    
    let localRealm = try! Realm()
    
    func saveViewModel(model: ViewModel) {
        try! localRealm.write {
            localRealm.add(model)
        }
    }
    
    func deleteViewModel(model: ViewModel) {
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
    
    func editViewModel(model: ViewModel, textView: String) {
        try! localRealm.write {
            model.viewTFFullName = textView
        }
    }
    
}
