//
//  RealmModel.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import Foundation
import RealmSwift
//제목, 메모, 마감일, 태그, 우선순위

class PlannerTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted(indexed: true) var date: String
    @Persisted var tag: String
    @Persisted var priority: String
    @Persisted(indexed: true) var complete: Bool
    
    convenience init(
        title: String,
        memo: String? = nil,
        date: String,
        tag: String,
        priority: String) {
        self.init()
        self.title = title
        self.memo = memo
        self.date = date
        self.tag = tag
        self.priority = priority
        self.complete = false
    }
}
