//
//  PlanNewViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit
import RealmSwift
import Toast

enum PlanWriteType {
    case new
    case edit
}

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
    
    private let repository = PlannerTableRepository()
    
    var updateCount: ((_ delete: Bool) -> Void)?
    var delete: Bool = false
    
    var selectList: PlannerList? = nil
    
    let realm = try! Realm()
    
    lazy var selectImage: UIImage? = loadImageToDocument(filename: "\(editingData.id)")
    
    var type: PlanWriteType = .new
    
    var editingData: PlannerTable = PlannerTable(title: "", deadLine: nil, tag: "", priority: "")
    lazy var changeDate: Date? = editingData.deadLine
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    lazy var planList: [PlanList] = [PlanList(title: "마감일", subTitle: "\(editingData.deadLine != nil ? changeDateFormat(editingData.deadLine!) : "")"),
                                PlanList(title: "태그", subTitle: "\(editingData.tag)"),
                                PlanList(title: "우선순위", subTitle: "\(editingData.priority)"),
                                PlanList(title: "이미지 추가", subTitle: ""),
                                     PlanList(title: "목록", subTitle: "\(editingData.list.first?.name ?? "")")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(deadLineReceivedNotification), name: NSNotification.Name("DeadLineReceived"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        updateCount?(delete)
    }

    @objc func deadLineReceivedNotification(notification: NSNotification) {
        if let value = notification.userInfo?["deadLine"] as? Date {
            changeDate = value
            planList[0].subTitle = "\(changeDateFormat(value))"
            self.collectionView.reloadData()
        }
    }
    
    func priorityReceived(priority: String) {
        planList[2].subTitle = "\(priority)"
        self.collectionView.reloadData()
    }
    
    func changeDateFormat(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        let result = format.string(from: date)
        return result
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
        
        if titleTextField.text!.isEmpty {
            var style = ToastStyle()
            style.messageColor = .white
            style.backgroundColor = .gray
            self.view.makeToast("제목을 입력해주세요", duration: 2.0, position: .bottom, style: style)
            
        } else {
            
            if type == .new {
                
                let data = PlannerTable(title: titleTextField.text!, memo: memoTextField.text!, deadLine: changeDate, tag: planList[Plan.tag.rawValue].subTitle, priority: planList[Plan.priority.rawValue].subTitle)
                
                if let selectList = self.selectList {
                    do {
                        try realm.write {
                            selectList.plan.append(data)
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    repository.createItem(data)
                }
                print("이미지지지지ㅣ지지짖지지지지지직")
                if let image = self.selectImage {
                    saveImageToDocument(image: image, filename: "\(data.id)")
                }

            } else { //edit
                if let selectList = self.selectList {
                    //240221의 나에게..맡김..!
                } else {
                    repository.updateItem(id: editingData.id, title: titleTextField.text!, memo: memoTextField.text!, deadLine: changeDate, tag: planList[Plan.tag.rawValue].subTitle, priority: planList[Plan.priority.rawValue].subTitle)
                    
                    if let image = self.selectImage {
                        saveImageToDocument(image: image, filename: "\(editingData.id)")
                    }
                }
            }
            
            dismiss(animated: true)
        }
    }
    
    @objc func deleteButtonClicked() {
        print(#function)
        
        delete = true
        
        dismiss(animated: true)
    }
    
    override func configureView() {
        
        navigationItem.title = type == .new ? "새로운 할 일" : "세부사항"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        
        if type == .edit {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteButtonClicked))
        }
        
        textInputView.backgroundColor = .darkGray
        textInputView.clipsToBounds = true
        textInputView.layer.cornerRadius = 14
        
        grayLine.backgroundColor = .gray
        
        titleTextField.placeholder = "제목"
        titleTextField.textColor = .white
        titleTextField.text = type == .new ? "" : editingData.title
        
        memoTextField.placeholder = "메모"
        memoTextField.textColor = .white
        memoTextField.text = type == .new ? "" : editingData.memo
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(NewPlanCollectionViewCell.self, forCellWithReuseIdentifier: "Plan")
        collectionView.register(NewPlanMemoCollectionViewCell.self, forCellWithReuseIdentifier: "Memo")
        collectionView.register(NewImageCollectionViewCell.self, forCellWithReuseIdentifier: "PlanImage")
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
        let vc = SelectDateViewController()
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
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func selectListClicked() {
        let vc = SelectListViewController()
        
        vc.selectList = { value in
            self.selectList = value
            self.planList[4].subTitle = value.name
            self.collectionView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PlanNewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("이미지 추가됨")
            self.selectImage = pickedImage
            collectionView.reloadData()
        }
        
        dismiss(animated: true)
    }
}

extension PlanNewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if planList[indexPath.row].title != "이미지 추가" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Plan", for: indexPath) as! NewPlanCollectionViewCell
            
            cell.title.text = planList[indexPath.row].title
            cell.subTitle.text = planList[indexPath.row].subTitle
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanImage", for: indexPath) as! NewImageCollectionViewCell
            
            cell.title.text = planList[indexPath.row].title
            cell.subTitle.text = planList[indexPath.row].subTitle
            
            if let image = self.selectImage {
                cell.selectImage.image = image
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: deadLineClicked()
        case 1: tagClicked()
        case 2: gradeClicked()
        case 3: plusImageClicked()
        case 4: selectListClicked()
        default: print("오류발생")
        }
    }
    
    
}

#Preview {
    PlanNewViewController()
}
