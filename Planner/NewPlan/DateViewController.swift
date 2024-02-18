//
//  DateViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit

class DateViewController: BaseViewController {

    let datePicker = UIDatePicker()
    
    var deadLine: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.post(name: NSNotification.Name("DeadLineReceived"), object: nil, userInfo: ["deadLine" : deadLine])
    }
    
    override func configureHierarchy() {
        view.addSubview(datePicker)
    }
    
    override func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {

        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func dateChanged() {

        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"

        let date = dateformat.string(from: datePicker.date)
        deadLine = dateformat.date(from: date)!
        print("저장: \(deadLine)")
        
    }
    

    
    
}

#Preview {
    DateViewController()
}
