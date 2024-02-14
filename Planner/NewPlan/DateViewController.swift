//
//  DateViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit

class DateViewController: BaseViewController {

    let datePicker = UIDatePicker()
    
    var deadLine: String = ""
    
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
        print(changeDateFormat())
        deadLine = changeDateFormat()
    }
    
    func changeDateFormat() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        let result = format.string(from: datePicker.date)
        return result
    }
    
    
}

#Preview {
    DateViewController()
}
