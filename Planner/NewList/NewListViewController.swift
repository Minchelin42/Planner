//
//  NewListViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/20.
//

import UIKit
import RealmSwift
import Toast

class NewListViewController: BaseViewController {
    
    let backView = UIView()
    let imageBackView = UIView()
    let image = UIImageView()
    let nameTextField = UITextField()
    
    var list: Results<PlannerList>!
    
    let realm = try! Realm()
    
    private let repository = PlannerListRepository()
    
    var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        list = repository.fetchList()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        update?()
    }
    
    override func configureHierarchy() {
        view.addSubview(backView)
        view.addSubview(imageBackView)
        view.addSubview(image)
        view.addSubview(nameTextField)
    }

    override func configureLayout() {
        backView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(220)
        }
        
        imageBackView.snp.makeConstraints { make in
            make.centerX.equalTo(backView)
            make.top.equalTo(backView.snp.top).offset(20)
            make.size.equalTo(100)
        }
        
        image.snp.makeConstraints { make in
            make.centerX.equalTo(imageBackView)
            make.edges.equalTo(imageBackView).inset(15)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(30)
            make.bottom.equalTo(backView.snp.bottom).inset(15)
            make.horizontalEdges.equalTo(backView).inset(20)
        }
    }

    @objc func saveButtonClicked() {
        print(#function)
        let data = PlannerList(name: nameTextField.text!, regDate: Date())
        
        if !nameTextField.text!.isEmpty {
            repository.createList(data)
            
            let memo = Memo()
            memo.editDate = Date()
            memo.regDate = Date()
            memo.writer = "\(nameTextField.text!) 생성자: 지은"

            repository.createMemo(data, memo: memo)
            
            dismiss(animated: true)
        } else {
            var style = ToastStyle()
            style.messageColor = .white
            style.backgroundColor = .gray
            
            view.makeToast("목록 이름을 입력해주세요", duration: 2.0, position: .bottom, style: style)
        }
        
    }
    
    override func configureView() {
        
        navigationItem.title = "새로운 목록"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        
        backView.backgroundColor = .gray
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 10
        
        imageBackView.backgroundColor = .orange
        imageBackView.clipsToBounds = true
        imageBackView.layer.cornerRadius = 50
        
        image.image = UIImage(systemName: "suit.heart")
        image.tintColor = .white
        
        nameTextField.placeholder = "목록 이름"
        nameTextField.textColor = .white
        nameTextField.font = .systemFont(ofSize: 15, weight: .bold)
        nameTextField.textAlignment = .center
        nameTextField.backgroundColor = .darkGray
        nameTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 12
    }
    
}

#Preview {
    NewListViewController()
}
