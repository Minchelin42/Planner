//
//  RealmModel.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import Foundation
import RealmSwift
//제목, 메모, 마감일, 태그, 우선순위

final class PlannerList: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var regDate: Date
    
    @Persisted var plan: List<PlannerTable>
    
    @Persisted var memo: Memo?
    
    convenience init(name: String, regDate: Date) {
        self.init()
        self.name = name
        self.regDate = regDate
    }
}

class Memo: EmbeddedObject {
    @Persisted var writer: String
    @Persisted var regDate: Date
    @Persisted var editDate: Date
}


final class PlannerTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted(indexed: true) var deadLine: Date?
    @Persisted var tag: String
    @Persisted var priority: String
    @Persisted(indexed: true) var complete: Bool
    @Persisted var regDate: Date
    @Persisted var writer: String?
    
    @Persisted(originProperty: "plan") var list: LinkingObjects<PlannerList>
    
    convenience init(
        title: String,
        memo: String? = nil,
        deadLine: Date? = nil,
        tag: String,
        priority: String) {
        self.init()
        self.title = title
        self.memo = memo
        self.deadLine = deadLine
        self.tag = tag
        self.priority = priority
        self.complete = false
        self.regDate = Date()
        self.writer = nil
    }
}
