//
//  ViewRealm.swift
//  SimbirDiary
//
//  Created by Кирилл on 13.10.2021.
//

import RealmSwift
import Foundation

@available (iOS 12, *)
class ViewModel: Object {
    
    @Persisted var viewDate = Date()
    @Persisted var viewTime = Date()
    @Persisted var viewTFName: String = "Без названия"
    @Persisted var viewTFFullName: String = ""
    @Persisted var viewWeekday: Int = 1
    
}
