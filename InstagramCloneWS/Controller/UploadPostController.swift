//
//  UploadPostController.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/02/24.
//

import UIKit

// ViewController에서 TabBarContrller 컨트롤이 불가능해서 protocol 이용.
// 목적 : posting이 끝난 다음에 FeedController의 화면에 머물게 하고 싶음.
// MainTabBarController에서 메소드 로직 구현.
protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) 
}

class UploadPostController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: UploadPostControllerDelegate?
    
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // textField에서 placeholer의 역할을 하고 있음.
    // Utils에 custom Class 만든 상태.
    // TextField로 만들었다면, 그냥 placeholer로 지정하고 끝내면되지만, 게시물의 특성상, textField의 정도로입력하지 않고,
    // 더 긴 text를 입력하므로 textView를 했고, placeholer를 생성하기 위해 좀더 로직이 필요함.
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter caption..."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.delegate = self
        return tv
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    //MARK: - Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDone() {
        // 이미지와 텍스트를 firebase에 저장.
        // API -> PostService에 구현한 상태 (PostService.swift)
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        
        showLoader(true)    // 로딩이미지 (extension)
        
        // 텍스트와 이미지를 input으로 하고 firebase에 로드하는 전역메소드이용.
        PostService.uploadPost(caption: caption, image: image) { (error) in
            self.showLoader(false) // 이미지 업로드 완료 시, 로딩이미지 false
            
            // error 처리
            if let error = error {
                print("DEBUG: Failed to upload post with error \(error.localizedDescription)")
                return
            }
            
            // Posting을 마친다음에 홈화면으로 돌아기기 위한 코드
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
        
    }
    
    
    //MARK: - Helpers
    
    // textView의 글자수를 제한하기 위해 만든 커스텀메소드
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Upload Post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                               paddingRight: 12, height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor,
                                   paddingBottom: -8,paddingRight: 12)
        
        
    }
}


//MARK: - UITextViewDelegate

extension UploadPostController: UITextViewDelegate {
    
    // textView가 변경될 때마다 아래 메소드가 호출된다.
    // 그래서 글자 수를 확인해서 글자수를 label.text에 기입해주고, checkMaxLength 메소드를 호출하여 글자수가 100자가 넘어가면
    // 작성되지 않도록 처리한 상태이다.
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
        
        // InputTextView에서 글자 입력시, placeHolder했던 부분을 주석처리하고 아래 코드를 실행해도 똑같은 로직으로 
        // 글자 입력시, placeholor가 없어진다.
        // 하지만 이걸사용하지 않은 이유는, Textview에서 그부분을 제거하면 아래 코드를 사용할 때마다 추가해야하는데,
        // 까먹고 작성하지 않을 우려가 있다. 즉, 복사 붙여넣기만해서 사용하기에 불편해서이다.
        // cf) 아래코드를 사용할라면 placeholderLabel private을 뺴줘야함!!
//        captionTextView.placeholderLabel.isHidden = !captionTextView.text.isEmpty
    }
}
