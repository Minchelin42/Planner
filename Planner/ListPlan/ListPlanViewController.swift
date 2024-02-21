//
//  ListPlanViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/20.
//

import UIKit
import Toast
import RealmSwift

class ListPlanViewController: BaseViewController {
    
    let tableView = UITableView()
    
    var updateCount: (() -> Void)?

    var listName: PlannerList!
    
    lazy var listPlan: Results<PlannerTable> = {
        return self.listName.plan.sorted(byKeyPath: "regDate", ascending: false)
    }()
    
    private let repository = PlannerTableRepository()

    lazy var sortDateLate = UIAction(title: "마감일 느린순") { action in
        print(#function)
        self.listPlan = self.repository.fetchSortedData("deadLine", ascending: false, list: self.listPlan)
        self.tableView.reloadData()
    }
    
    lazy var sortDateEarly = UIAction(title: "마감일 빠른순") { action in
        print(#function)
        self.listPlan = self.repository.fetchSortedData("deadLine", ascending: true, list: self.listPlan)
        self.tableView.reloadData()
    }
    
    lazy var sortTitle = UIAction(title: "제목순") { action in
        self.listPlan = self.repository.fetchSortedData("title", ascending: true, list: self.listPlan)
        self.tableView.reloadData()
    }
    
    lazy var menu: UIMenu = {
        return UIMenu(title: "", children: [sortDateLate, sortDateEarly, sortTitle])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        updateCount?()
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }

    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem!.menu = menu

        tableView.backgroundColor = .clear
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllPlanTableViewCell.self, forCellReuseIdentifier: "AllPlanTableViewCell")
        tableView.allowsSelection = false
    }
    
    func changeDateFormat(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        let result = format.string(from: date)
        return result
    }
    
}

extension ListPlanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPlan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPlanTableViewCell", for: indexPath) as! AllPlanTableViewCell
        
        let row = listPlan[indexPath.row]
        
        cell.titleLabel.text = row.title
        cell.memoLabel.text = row.memo
        cell.dateLabel.text = row.deadLine != nil ? changeDateFormat(row.deadLine!) : ""
        switch row.priority {
        case "높음": cell.priorityLabel.text = "⭐️⭐️⭐️"
        case "중간": cell.priorityLabel.text = "⭐️⭐️"
        case "낮음": cell.priorityLabel.text = "⭐️"
        default :  cell.priorityLabel.text = ""
        }
        cell.tagLabel.text = row.tag.isEmpty ? "" : "#\(row.tag)"
        cell.checkButton.setImage(row.complete ? UIImage(systemName: "checkmark.circle.fill") : nil, for: .normal)
        cell.checkButton.tag = indexPath.row
        cell.checkButton.addTarget(self, action: #selector(checkButtonClicked(_:)), for: .touchUpInside)
        cell.checkButton.tintColor = .gray
        cell.image.image = loadImageToDocument(filename: "\(row.id)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("delete 버튼 클릭")
            var style = ToastStyle()
            style.messageColor = .white
            style.backgroundColor = .gray
            
            self.repository.deleteItem(self.listName.plan[indexPath.row])
            self.view.makeToast("삭제되었습니다", duration: 2.0, position: .bottom, style: style)
            tableView.deleteRows(at: [indexPath], with: .middle)
        }
        
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .systemRed
        
        let edit = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("pencil 버튼 클릭")
            let vc = PlanNewViewController()
            
            vc.updateCount = { delete in
                var style = ToastStyle()
                style.messageColor = .white
                style.backgroundColor = .gray

                if delete {
                    self.view.makeToast("삭제되었습니다", duration: 2.0, position: .bottom, style: style)
                    self.repository.deleteItem(self.listName.plan[indexPath.row])
                    tableView.deleteRows(at: [indexPath], with: .middle)
                }
                
                tableView.reloadData()
            }
            
            vc.type = .edit
            
            vc.editingData = self.listName.plan[indexPath.row]
            
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)

        }
        
        edit.image = UIImage(systemName: "pencil")
        edit.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }

    @objc func checkButtonClicked(_ sender: UIButton) {

        if sender.currentImage == UIImage(systemName: "checkmark.circle.fill") {
            sender.setImage(nil, for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        
        repository.updateComplete(self.listName.plan[sender.tag])
    }

}


#Preview {
    AllPlanViewController()
}
