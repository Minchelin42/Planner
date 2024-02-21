//
//  AppDelegate.swift
//  Planner
//
//  Created by 민지은 on 2024/02/14.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let configuration = Realm.Configuration(schemaVersion: 4) { migration, oldSchemaVersion in
            
            // 1: PlannerList에 Memo 추가
            if oldSchemaVersion < 1 {
                print("Schema 0 -> 1")
            }
            
            // 2: PlannerTable에 regDate 추가
            if oldSchemaVersion < 2 {
                print("Schema 1 -> 2")
            }
            
            // 3: PlannerTable의 date 컬럼명을 deadLine으로 변경
            if oldSchemaVersion < 3 {
                print("Schema 2 -> 3")
                migration.renameProperty(onType: PlannerTable.className(), from: "date", to: "deadLine")
            }
            
            // 4: PlannerTable에 writer 추가 + writer 컬럼에 컨텐츠 넣기
            if oldSchemaVersion < 4 {
                print("Schema 3 -> 4")
                migration.enumerateObjects(ofType: PlannerTable.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    new["writer"] = "지은"
                }
            }
            
            
        }
        
        Realm.Configuration.defaultConfiguration = configuration
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

