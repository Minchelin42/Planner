//
//  PriorityViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/15.
//

import UIKit

class PriorityViewController: BaseViewController {

    let segmentedControl = UISegmentedControl(items: ["낮음", "중간","높음"])
    
    var priority: String = ""
    
    var delegate: PassDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        delegate?.priorityReceived(priority: priority)
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
