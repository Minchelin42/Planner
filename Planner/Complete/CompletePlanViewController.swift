//
//  CompletePlanViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/18.
//

import UIKit
import RealmSwift
import Toast

class CompletePlanViewController: BaseViewController {
    
    let tableView = UITableView()
    
    var updateCount: (() -> Void)?
    
    var list: Results<PlannerTable>! = {
        let realm = try! Realm()
        return realm.objects(PlannerTable.self).where {
            $0.clear == true
        }
    }()

    lazy var sortDateLate = UIAction(title: "마감일 느린순") { action in
        let realm = try! Realm()
        
        self.list = realm.objects(PlannerTable.self).sorted(byKeyPath: "date", ascending: false)
        
        self.tableView.reloadData()
    }
    
    lazy var sortDateEarly = UIAction(title: "마감일 빠른순") { action in
        let realm = try! Realm()
        
        self.list = realm.objects(PlannerTable.self).sorted(byKeyPath: "date", ascending: true)
        
        self.tableView.reloadData()
    }
    
    lazy var sortTitle = UIAction(title: "제목순") { action in
        let realm = try! Realm()
        
        self.list = realm.objects(PlannerTable.self).sorted(byKeyPath: "title", ascending: true)
        
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
}

extension CompletePlanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPlanTableViewCell", for: indexPath) as! AllPlanTableViewCell
        
        let row = list[indexPath.row]
        
        cell.titleLabel.text = row.title
        cell.memoLabel.text = row.memo
        cell.dateLabel.text = row.date
        switch row.priority {
        case "높음": cell.priorityLabel.text = "⭐️⭐️⭐️"
        case "중간": cell.priorityLabel.text = "⭐️⭐️"
        case "낮음": cell.priorityLabel.text = "⭐️"
        default :  cell.priorityLabel.text = ""
        }
        cell.tagLabel.text = row.tag.isEmpty ? "" : "#\(row.tag)"
        cell.checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        cell.checkButton.tintColor = .gray
        cell.checkButton.addTarget(self, action: #selector(checkButtonClicked(_:)), for: .touchUpInside)
        cell.checkButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("delete 버튼 클릭")
            let realm = try! Realm()
            
            realm.objects(PlannerTable.self).where {
                $0.clear == true
            }
            
            try! realm.write {
                realm.delete(self.list[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .middle)
        }
        
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .systemRed
        
        let edit = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("pencil 버튼 클릭")
            let vc = PlanNewViewController()
            
            vc.type = .edit
            
            vc.editingData = self.list[indexPath.row]
            
            vc.updateCount = { delete in
                var style = ToastStyle()
                style.messageColor = .white
                style.backgroundColor = .gray
                self.view.makeToast(delete ? "삭제되었습니다" : "수정되었습니다", duration: 2.0, position: .bottom, style: style)

                if delete {
                    let realm = try! Realm()
                    
                    try! realm.write {
                        realm.delete(self.list[indexPath.row])
                    }
                    
                    tableView.deleteRows(at: [indexPath], with: .middle)
                }
                
                tableView.reloadData()
            }
            
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)

        }
        
        edit.image = UIImage(systemName: "pencil")
        edit.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    @objc func checkButtonClicked(_ sender: UIButton) {
        let realm = try! Realm()
        
        if sender.currentImage == UIImage(systemName: "checkmark.circle.fill") {
            sender.setImage(nil, for: .normal)
            try! realm.write {
                list[sender.tag].clear.toggle()
            }
            
        } else {
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            sender.tintColor = .gray
            
            try! realm.write {
                list[sender.tag].clear.toggle()
            }
        }
    }
    
}


#Preview {
    CompletePlanViewController()
}
