//
//  PlannerListRepository.swift
//  Planner
//
//  Created by 민지은 on 2024/02/22.
//

import UIKit
import RealmSwift

final class PlannerListRepository {
    private let realm = try! Realm()
    
    func createList(_ list: PlannerList) {
        do{
            try realm.write {
                realm.add(list)
            }
        } catch {
            print(error)
        }
    }
    
    func fetchList() -> Results<PlannerList> {
        return realm.objects(PlannerList.self)
    }
    
    func inputPlan(_ list: PlannerList, plan: PlannerTable) {
        do {
            try realm.write {
                list.plan.append(plan)
            }
        } catch {
            print(error)
        }
    }
    
    func createMemo(_ list: PlannerList, memo: Memo) {
        do {
            try realm.write {
                list.memo = memo
            }
        } catch {
            print(error)
        }
    }
    
    func deleteList(_ list: PlannerList) {
        do {
            try realm.write {
                realm.delete(list.plan)
                realm.delete(list)
            }
        } catch {
            print(error)
        }
    }

}
