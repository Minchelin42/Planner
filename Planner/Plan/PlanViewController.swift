//
//  AllTypeViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/14.
//

import UIKit
import RealmSwift
import Toast

struct PlanOption {
    var image: String
    var title: String
    var count: Int
    var color: UIColor
}

class PlanViewController: BaseViewController {
    
    let searchBar = UISearchBar()
    let resultTableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let bottomView = UIView()
    let newPlan = UIButton()
    let newList = UIButton()
    
    private let repository = PlannerTableRepository()
    private let listRepository = PlannerListRepository()

    var list: Results<PlannerTable>!
    var listName: Results<PlannerList>!
    
    let realm = try! Realm()
    
    lazy var planList: [PlanOption] = [PlanOption(image: "calendar", title: "오늘", count: self.repository.fetchTodayFilter().count, color: .systemBlue),
                                  PlanOption(image: "calendar.badge.clock", title: "예정", count: self.repository.fetchLaterFilter().count, color: .red),
                                  PlanOption(image: "tray.fill", title: "전체", count: self.repository.fetchCompleteFilter(false).count, color: .gray),
                                  PlanOption(image: "flag.fill", title: "깃발 표시", count: 0, color: .orange),
                                  PlanOption(image: "checkmark", title: "완료", count: -1, color: .gray)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        print(realm.configuration.fileURL)
        
        list = repository.fetchCompleteFilter(false)
        listName = listRepository.fetchList()
        
        //Scheme Version 확인
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Realm Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        planList[0].count = self.repository.fetchTodayFilter().count
        planList[1].count = self.repository.fetchLaterFilter().count
    }
    
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(bottomView)
        view.addSubview(newPlan)
        view.addSubview(newList)
        view.addSubview(resultTableView)
    }
    
    override func configureLayout() {
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(tableView.snp.top)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).inset(10)
            make.bottom.equalTo(bottomView.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        newPlan.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        newList.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(90)
            make.height.equalTo(40)
        }
        
        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func configureView() {
        searchBar.delegate = self
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PlanCollectionViewCell.self, forCellWithReuseIdentifier: "Plan")
        collectionView.backgroundColor = .black
        
        bottomView.backgroundColor = .black
        
        newPlan.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        newPlan.setTitle("  새로운 할 일", for: .normal)
        newPlan.tintColor = .systemBlue
        newPlan.setTitleColor(.systemBlue, for: .normal)
        newPlan.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)

        newPlan.addTarget(self, action: #selector(newPlanButtonClicked), for: .touchUpInside)
        
        newList.setTitle("목록 추가 ", for: .normal)
        newList.tintColor = .systemBlue
        newList.setTitleColor(.systemBlue, for: .normal)
        newList.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)

        newList.addTarget(self, action: #selector(newListButtonClicked), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "List")
        tableView.rowHeight = 60
        
        resultTableView.backgroundColor = .black
        resultTableView.rowHeight = 80
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(AllPlanTableViewCell.self, forCellReuseIdentifier: "AllPlanTableViewCell")
        resultTableView.allowsSelection = false
        resultTableView.isHidden = true
    }
    
    @objc func newPlanButtonClicked() {
        let vc = PlanNewViewController()
        
        vc.updateCount = { delete in
            var style = ToastStyle()
            style.messageColor = .white
            style.backgroundColor = .gray
            
            self.planList[0].count = self.repository.fetchTodayFilter().count
            self.planList[1].count = self.repository.fetchLaterFilter().count
            self.planList[2].count = self.list.count
            
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
        
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc func newListButtonClicked() {
        let vc = NewListViewController()
        
        vc.update = {
            self.tableView.reloadData()
        }
        
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc func checkButtonClicked(_ sender: UIButton) {

        if sender.currentImage == UIImage(systemName: "checkmark.circle.fill") {
            sender.setImage(nil, for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        let row = list[sender.tag]

        repository.updateComplete(row)
        self.resultTableView.reloadData()

    }
    
    static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 50) / 2, height: (UIScreen.main.bounds.width - 30) / 4)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .vertical

        return layout
        
    }

}

extension PlanViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.resultTableView.isHidden = false
        self.list = realm.objects(PlannerTable.self).where {
            $0.title.contains(searchText, options: .caseInsensitive)
        }
        self.resultTableView.reloadData()
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resultTableView.isHidden = true
        searchBar.searchTextField.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
}

extension PlanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.resultTableView {
            return list.count
        } else {
            return listName.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.resultTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllPlanTableViewCell", for: indexPath) as! AllPlanTableViewCell
            
            let row = list[indexPath.row]
            
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
            cell.checkButton.tintColor = .gray
            cell.checkButton.addTarget(self, action: #selector(checkButtonClicked(_:)), for: .touchUpInside)
            cell.checkButton.tag = indexPath.row
            cell.image.image = loadImageToDocument(filename: "\(row.id)")

            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath) as! ListTableViewCell
            
            cell.title.text = listName[indexPath.row].name
            cell.count.text = "\(listName[indexPath.row].plan.count)"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ListPlanViewController()
        
        vc.listName = listName[indexPath.row]
        
        vc.updateCount = {
            
            self.planList[0].count = self.repository.fetchTodayFilter().count
            self.planList[1].count = self.repository.fetchLaterFilter().count
            self.planList[2].count = self.repository.fetchCompleteFilter(false).count
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("delete 버튼 클릭")
            var style = ToastStyle()
            style.messageColor = .white
            style.backgroundColor = .gray

            self.listRepository.deleteList(self.listName[indexPath.row])
            
            self.view.makeToast("삭제되었습니다", duration: 2.0, position: .bottom, style: style)
            tableView.deleteRows(at: [indexPath], with: .middle)
            
            self.planList[0].count = self.repository.fetchTodayFilter().count
            self.planList[1].count = self.repository.fetchLaterFilter().count
            self.planList[2].count = self.repository.fetchCompleteFilter(false).count
            self.collectionView.reloadData()
        }
        
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .systemRed
        
       
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}

extension PlanViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Plan", for: indexPath) as! PlanCollectionViewCell
        
        cell.imageBack.backgroundColor = planList[indexPath.row].color
        
        cell.image.image = UIImage(systemName: planList[indexPath.row].image)
        cell.image.tintColor = .white
        
        cell.title.text = planList[indexPath.row].title
        cell.count.text = planList[indexPath.row].count != -1 ? String(planList[indexPath.row].count) : ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if planList[indexPath.row].title == "전체" {
            let vc = AllPlanViewController()
            
            vc.type = .all
            
            vc.updateCount = {
                
                self.planList[0].count = self.repository.fetchTodayFilter().count
                self.planList[1].count = self.repository.fetchLaterFilter().count
                self.planList[2].count = self.repository.fetchCompleteFilter(false).count
                self.collectionView.reloadData()
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if planList[indexPath.row].title == "완료" {
            let vc = AllPlanViewController()
            
            vc.type = .complete
            
            vc.updateCount = {
                self.planList[0].count = self.repository.fetchTodayFilter().count
                self.planList[1].count = self.repository.fetchLaterFilter().count
                self.planList[2].count = self.repository.fetchCompleteFilter(false).count
                self.collectionView.reloadData()
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if planList[indexPath.row].title == "오늘" {
            let vc = AllPlanViewController()
            
            vc.type = .today
            
            vc.updateCount = {
                self.planList[0].count = self.repository.fetchTodayFilter().count
                self.planList[1].count = self.repository.fetchLaterFilter().count
                self.planList[2].count = self.repository.fetchCompleteFilter(false).count
                self.collectionView.reloadData()
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if planList[indexPath.row].title == "예정" {
            let vc = AllPlanViewController()
            
            vc.type = .later
            
            vc.updateCount = {
                self.planList[0].count = self.repository.fetchTodayFilter().count
                self.planList[1].count = self.repository.fetchLaterFilter().count
                self.planList[2].count = self.repository.fetchCompleteFilter(false).count
                self.collectionView.reloadData()
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

#Preview {
    PlanViewController()
}
