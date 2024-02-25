//
//  BaseViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/14.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureView() {
        
    }
    
    func changeDateFormat(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        let result = format.string(from: date)
        return result
    }

}
