//
//  PlanNewViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit
import RealmSwift
import Toast

enum Plan: Int {
    case date
    case tag
    case priority
    case inputImage
}

struct PlanList {
    var title: String
    var subTitle: String
}

protocol PassDataDelegate {
    func priorityReceived(priority: String)
}

class PlanNewViewController: BaseViewController, PassDataDelegate {
    
    let textInputView = UIView()
    let grayLine = UIView()
    let titleTextField = UITextField()
    let memoTextField = UITextField()
    
    var updateCount: (() -> Void)?
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    var planList: [PlanList] = [PlanList(title: "마감일", subTitle: ""),
                                PlanList(title: "태그", subTitle: ""),
                                PlanList(title: "우선순위", subTitle: ""),
                                PlanList(title: "이미지 추가", subTitle: "")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(deadLineReceivedNotification), name: NSNotification.Name("DeadLineReceived"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        updateCount?()
    }

    @objc func deadLineReceivedNotification(notification: NSNotification) {
        if let value = notification.userInfo?["deadLine"] as? String {
            planList[0].subTitle = "\(value)"
            self.collectionView.reloadData()
        }
    }
    
    func priorityReceived(priority: String) {
        planList[2].subTitle = "\(priority)"
        self.collectionView.reloadData()
    }
    
    override func configureHierarchy() {
        view.addSubview(textInputView)
        view.addSubview(grayLine)
        view.addSubview(titleTextField)
        view.addSubview(memoTextField)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        textInputView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(150)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(textInputView).inset(14)
            make.top.equalTo(textInputView)
        }
        
        grayLine.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.horizontalEdges.equalTo(textInputView).inset(10)
            make.height.equalTo(1)
        }
        
        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(grayLine.snp.bottom)
            make.horizontalEdges.equalTo(textInputView).inset(14)
            make.bottom.greaterThanOrEqualTo(textInputView).offset(-60)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(textInputView.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func saveButtonClicked() {
        print(#function)
        
        if titleTextField.text!.isEmpty || planList[Plan.date.rawValue].subTitle.isEmpty ||
        planList[Plan.tag.rawValue].subTitle.isEmpty || planList[Plan.priority.rawValue].subTitle.isEmpty {
            
            let alert = UIAlertController(title: "저장 실패", message: "필수 내용을 입력해주세요!", preferredStyle: .alert)

            let oneButton = UIAlertAction(title: "확인", style: .cancel)
            
            alert.addAction(oneButton)

            present(alert, animated: true)
            
        } else {
            
            let realm = try! Realm()
            print(realm.configuration.fileURL)
            
            let data = PlannerTable(title: titleTextField.text!, memo: memoTextField.text!, date: planList[Plan.date.rawValue].subTitle, tag: planList[Plan.tag.rawValue].subTitle, priority: planList[Plan.priority.rawValue].subTitle)
            
            try! realm.write {
                realm.add(data)
                print("Realm Create")
            }
            
            var style = ToastStyle()
            style.messageColor = .white
            self.view.makeToast("입력하신 내용이 추가되었습니다", duration: 2.0, position: .bottom, style: style)

            dismiss(animated: true)
        }
    }
    
    override func configureView() {
        
        navigationItem.title = "새로운 할 일"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        
        textInputView.backgroundColor = .darkGray
        textInputView.clipsToBounds = true
        textInputView.layer.cornerRadius = 14
        
        grayLine.backgroundColor = .gray
        
        titleTextField.placeholder = "제목"
        titleTextField.textColor = .white
        memoTextField.placeholder = "메모"
        memoTextField.textColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(NewPlanCollectionViewCell.self, forCellWithReuseIdentifier: "Plan")
        collectionView.register(NewPlanMemoCollectionViewCell.self, forCellWithReuseIdentifier: "Memo")
    }

    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 50)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .horizontal

        return layout
        
    }
    
    func deadLineClicked() { //notiofication
        let vc = DateViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tagClicked() { //closure
        let vc = TagViewController()
        vc.setTag = { value in
            self.planList[1].subTitle = "\(value)"
            self.collectionView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func gradeClicked() { //delegate
        let vc = PriorityViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func plusImageClicked() {

    }
    
}

extension PlanNewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Plan", for: indexPath) as! NewPlanCollectionViewCell
        
        cell.title.text = planList[indexPath.row].title
        cell.subTitle.text = planList[indexPath.row].subTitle
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: deadLineClicked()
        case 1: tagClicked()
        case 2: gradeClicked()
        case 3: plusImageClicked()
        default: print("오류발생")
        }
    }
    
    
}

#Preview {
    PlanNewViewController()
}
