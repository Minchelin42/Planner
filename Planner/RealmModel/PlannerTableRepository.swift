//
//  PlannerTableRepository.swift
//  Planner
//
//  Created by 민지은 on 2024/02/18.
//

import Foundation
import RealmSwift

final class PlannerTableRepository {
    private let realm = try! Realm()
    
    func createItem(_ item: PlannerTable) {
        do{
            try! realm.write {
                realm.add(item)
                print("Realm Create")
            }
        } catch {
            print(error)
        }
    }
    
    func fetch() -> Results<PlannerTable> {
        return realm.objects(PlannerTable.self)
    }
    
    func fetchCompleteFilter(_ complete: Bool) -> Results<PlannerTable> {
        realm.objects(PlannerTable.self).where {
            $0.complete == complete
        }
    }
    
    func fetchLaterFilter() -> Results<PlannerTable> {

        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let today = dateformat.date(from: dateformat.string(from: Date()))!

        return realm.objects(PlannerTable.self).filter("date >= %@", Date(timeInterval: 86400, since: today)).where {
            $0.complete == false
        }

    }
    
    func fetchTodayFilter() -> Results<PlannerTable> {
        
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let today = dateformat.date(from: dateformat.string(from: Date()))!

        return realm.objects(PlannerTable.self).filter("date > %@ AND date < %@", Date(timeInterval: -86400, since: today), Date(timeInterval: 86400, since: today)).where {
            $0.complete == false
        }
    }
    
    func fetchSortedData(_ keyPath: String, ascending: Bool, list: Results<PlannerTable>) -> Results<PlannerTable> {
        if keyPath == "date" {
            return list.where {
                $0.date != nil
            }.sorted(byKeyPath: keyPath, ascending: ascending)
        } else {
            return list.sorted(byKeyPath: keyPath, ascending: ascending)
        }
    }
    
    func updateItem(id: ObjectId, title: String, memo: String, date: Date, tag: String, priority: String) {
        do {
            try realm.write {
                realm.create(PlannerTable.self, value: [
                    "id" : id, "title" : title,
                    "memo" : memo,
                    "date" : date,
                    "tag" : tag,
                    "priority" : priority],
                    update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func updatComplete(_ item: PlannerTable) {
        do {
            try realm.write {
                item.complete.toggle()
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ item: PlannerTable) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
 }
