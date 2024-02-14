//
//  TagViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit

class TagViewController: BaseViewController {

    let inputTextField = UITextField()
    
    var setTag: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        setTag?(inputTextField.text!)
    }
    
    override func configureHierarchy() {
        view.addSubview(inputTextField)
    }
    
    override func configureLayout() {
        inputTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        inputTextField.backgroundColor = .darkGray
        inputTextField.clipsToBounds = true
        inputTextField.layer.cornerRadius = 10
        inputTextField.placeholder = "태그 값을 입력해주세요"
        inputTextField.textColor = .white
        inputTextField.addLeftPadding()
    }
    
}

extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}

#Preview {
    TagViewController()
}
