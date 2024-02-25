//
//  SelectImageViewController.swift
//  Planner
//
//  Created by 민지은 on 2024/02/24.
//

import UIKit

class SelectImageViewController: BaseViewController, PassDataDelegate {
    
    let selectImage = UIImageView()
    let albumButton = UIButton()
    let cameraButton = UIButton()
    let searchButton = UIButton()
    
    var delegate: PassDataDelegate?
    
    var getImage : ((UIImage?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        getImage?(selectImage.image ?? nil)
    }
    
    override func configureHierarchy() {
        view.addSubview(selectImage)
        view.addSubview(albumButton)
        view.addSubview(cameraButton)
        view.addSubview(searchButton)
    }
    
    override func configureLayout() {
        selectImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(150)
            make.size.equalTo(200)
        }
        
        albumButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(selectImage.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(albumButton.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cameraButton.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        selectImage.backgroundColor = .systemPink
        albumButton.setTitle("앨범에서 고르기", for: .normal)
        albumButton.imageSelectButtonStyle()
        cameraButton.setTitle("카메라로 촬영하기", for: .normal)
        cameraButton.imageSelectButtonStyle()
        searchButton.setTitle("이미지 검색하기", for: .normal)
        searchButton.imageSelectButtonStyle()
        
        albumButton.addTarget(self, action: #selector(albumButtonClicked), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(cameraButtonClicked), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        
    }
    
    func priorityReceived(priority: String) {
        let url = URL(string: priority)
        self.selectImage.kf.setImage(with: url, placeholder: UIImage(systemName: "suit.heart"))
    }
    
    @objc func albumButtonClicked() {
        print(#function)
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @objc func cameraButtonClicked() {
        print(#function)
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @objc func searchButtonClicked() {
        print(#function)
        let vc = SearchImageViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension SelectImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("이미지 추가됨")
            self.selectImage.image = pickedImage
        }
        
        dismiss(animated: true)
    }
}

extension UIButton {
    func imageSelectButtonStyle() {
        clipsToBounds = true
        layer.cornerRadius = 10
        backgroundColor = .orange
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
    }
}
