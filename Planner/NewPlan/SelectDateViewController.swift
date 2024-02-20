//
//  SelectDateViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/21.
//

import UIKit
import RealmSwift
import FSCalendar

class SelectDateViewController: BaseViewController {
    
    let tableView = UITableView()
    let calendar = FSCalendar()
    
    var deadLine: Date = Date()
    
    var list: Results<PlannerTable>!
    
    let realm = try! Realm()
    
    let repository = PlannerTableRepository()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        list = repository.fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.post(name: NSNotification.Name("DeadLineReceived"), object: nil, userInfo: ["deadLine" : deadLine])
    }
    
    override func configureHierarchy() {
        view.addSubview(calendar)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        
        calendar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.headerTitleColor = UIColor.white
        calendar.appearance.weekdayTextColor = UIColor.white.withAlphaComponent(0.2)
        calendar.appearance.titlePlaceholderColor = UIColor.white.withAlphaComponent(0.2)
        calendar.appearance.titleDefaultColor = UIColor.white.withAlphaComponent(0.8)
        
        tableView.backgroundColor = .clear
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(AllPlanTableViewCell.self, forCellReuseIdentifier: "AllPlanTableViewCell")
    }
    
    func changeDateFormat(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        let result = format.string(from: date)
        return result
    }

}

extension SelectDateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPlanTableViewCell", for: indexPath) as! AllPlanTableViewCell
        
        let row = list[indexPath.row]
        
        cell.titleLabel.text = row.title
        cell.memoLabel.text = row.memo
        cell.dateLabel.text = row.date != nil ? changeDateFormat(row.date!) : ""
        switch row.priority {
        case "높음": cell.priorityLabel.text = "⭐️⭐️⭐️"
        case "중간": cell.priorityLabel.text = "⭐️⭐️"
        case "낮음": cell.priorityLabel.text = "⭐️"
        default :  cell.priorityLabel.text = ""
        }
        cell.tagLabel.text = row.tag.isEmpty ? "" : "#\(row.tag)"
        cell.checkButton.setImage(row.complete ? UIImage(systemName: "checkmark.circle.fill") : nil, for: .normal)
        cell.checkButton.tintColor = .gray
        cell.checkButton.addTarget(self, action: #selector(checkButtonClicked(_:)), for: .touchUpInside)
        cell.checkButton.tag = indexPath.row
        cell.image.image = loadImageToDocument(filename: "\(row.id)")
        
        return cell
    }
    
    @objc func checkButtonClicked(_ sender: UIButton) {

        if sender.currentImage == UIImage(systemName: "checkmark.circle.fill") {
            sender.setImage(nil, for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }

        repository.updateComplete(list[sender.tag])

    }
}

extension SelectDateViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        print(#function, date)

        let start = Calendar.current.startOfDay(for: date)
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? date

        let predicate = NSPredicate(format: "date >= %@ && date < %@", start as NSDate, end as NSDate)
        
        list = realm.objects(PlannerTable.self).filter(predicate)
        
        tableView.reloadData()
        
        return list.count
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(#function, date)

        let start = Calendar.current.startOfDay(for: date)

        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? date

        let predicate = NSPredicate(format: "date >= %@ && date < %@", start as NSDate, end as NSDate)
        
        //해당 날짜로 일정 저장하기
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"

        let date = dateformat.string(from: date)
        deadLine = dateformat.date(from: date)!
        
        //해당 날짜 일정 불러오기
        list = realm.objects(PlannerTable.self).filter(predicate)
        
        tableView.reloadData()
    }
}



#Preview {
    SelectDateViewController()
}
