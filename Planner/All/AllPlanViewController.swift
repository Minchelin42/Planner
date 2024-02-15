//
//  AllPlanViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit
import RealmSwift

class AllPlanViewController: BaseViewController {
    
    let tableView = UITableView()
    
    var list: Results<PlannerTable>!

    //마감일, 제목, 우선순위 낮음
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let realm = try! Realm()
        
        list = realm.objects(PlannerTable.self)
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
    }
}

extension AllPlanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPlanTableViewCell", for: indexPath) as! AllPlanTableViewCell
        
        let row = list[indexPath.row]
        
        cell.titleLabel.text = row.title
        cell.memoLabel.text = row.memo
        cell.dateLabel.text = row.date
        cell.priorityLabel.text = row.priority
        cell.tagLabel.text = row.tag
        
        return cell
    }
    
    
}


#Preview {
    AllPlanViewController()
}
