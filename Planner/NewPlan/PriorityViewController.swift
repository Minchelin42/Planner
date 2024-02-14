//
//  PriorityViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit

class PriorityViewController: BaseViewController {

    let segmentedControl = UISegmentedControl(items: ["짱중요", "왕중요", "대박중요", "완전중요한데 하기싫음", "완전하고싶은데 제일 쓸데 없음"])
    
    var priority: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.post(name: NSNotification.Name("PriorityReceived"), object: nil, userInfo: ["priority" : priority])
    }
    
    override func configureHierarchy() {
        view.addSubview(segmentedControl)
    }
    
    override func configureLayout() {
        segmentedControl.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(100)
        }
    }
    
    override func configureView() {
        segmentedControl.addTarget(self, action: #selector(segmentSelected), for: .valueChanged)
    }
    
    @objc func segmentSelected() {
        priority = segmentedControl.titleForSegment(at:    segmentedControl.selectedSegmentIndex)!
    }
}

#Preview {
    PriorityViewController()
}
