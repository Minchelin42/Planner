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
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    let bottomView = UIView()
    
    let newPlan = UIButton()
    
    let repository = PlannerTableRepository()

    var list: Results<PlannerTable>!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        planList[0].count = self.repository.fetchTodayFilter().count
        planList[1].count = self.repository.fetchLaterFilter().count
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(bottomView)
        view.addSubview(newPlan)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
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
    }
    
    override func configureView() {
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
        }
        
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 30) / 2, height: (UIScreen.main.bounds.width - 30) / 4)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .vertical

        return layout
        
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
