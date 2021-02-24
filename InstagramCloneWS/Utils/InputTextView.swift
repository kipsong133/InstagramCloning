//
//  InputTextView.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/02/24.
//
// 아래 TextView는 프로젝트하면서 재활용을 그대로 할 수 있으므로, 복붙할 것.

import UIKit

class InputTextView: UITextView {
    
    //MARK: - Properties
    
    var placeholderText: String? {
        didSet { placeholderLabel.text = placeholderText }
    }
    
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 8)
        
        // textView에서 Text가 변하고 있으면 Noti-Center에서 알려주고 기입된 콜백함수개 호출된다.
        // Textview를 작성할 때, observer생성하여 UI 동기화를 위해 작성했다고 생각하면 된다.
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    //MARK: - Actions
    
    @objc func handleTextDidChange() {
        // textView에서 작성중일 때마다 아래 로직이 호출된다.
        // text가 작성되었다면 isHidden되고, 아무것도 적혀있지 않다면(isEmpty == true), placeholder가 보일 것이다.
        placeholderLabel.isHidden = !text.isEmpty
    }
}
