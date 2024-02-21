//
//  SelectListViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/20.
//

import UIKit
import RealmSwift

class SelectListViewController: BaseViewController {

    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let listRepository = PlannerListRepository()
    
    var select: PlannerList?
    var selectList: ((PlannerList) -> Void)?

    var listName: Results<PlannerList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listName = listRepository.fetchList()
        view.backgroundColor = .black
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let select = self.select {
            selectList?(select)
        }
    
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "List")
        tableView.rowHeight = 60
    }

}

extension SelectListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath) as! ListTableViewCell
    
        cell.title.text = listName[indexPath.row].name
        cell.count.text = "\(listName[indexPath.row].plan.count)"
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(listName[indexPath.row].id)")
        select = listName[indexPath.row]
    }
    
}


#Preview {
    SelectListViewController()
}
