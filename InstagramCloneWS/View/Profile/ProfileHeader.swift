//
//  ProfileHeader.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/20.
//

import UIKit
import SDWebImage


// View에서는 API통신처리를 안하기 위해서 Protocol을 통해서 구현함.
protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
}

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    // ProfileHeaderViewModel에 데이터가 모두 있기 때문에 인스턴스를 생성해준다.
    // 다만 그 내부에 configure() 메소드가 있는데,
    // 이 함수를 통해서 각 View의 UI 구성요소의 값들을 업데이트 해주는 최종 단계가 되는 것이다.
    // 여기있는 값은 Controller에서왓고 controller에 온 값은 Firebase에서 왔다.
    
    var viewModel: ProfileHeaderViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)        // follow <-> unfollow 간 조금 시간이 걸리므로 loading으로기입.
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    private let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()    
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    
    
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80/2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16,
                                       paddingLeft: 24, paddingRight: 24)
        
        let stack = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor,
                     paddingLeft: 12, paddingRight: 12, height: 50)
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        let bottonDivider = UIView()
        bottonDivider.backgroundColor = .lightGray
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        addSubview(topDivider)
        addSubview(bottonDivider)
        
        buttonStack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        topDivider.anchor(top: buttonStack.topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        bottonDivider.anchor(top: buttonStack.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
    @objc func handleEditProfileFollowTapped() {
        // 사용자가 edit 버튼을 눌렀을 때 진행할 로직.
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    
    //MARK: - Helpers
    
    func configure() {
        // ViewModel은 View에서 옵셔널로 생성하기 때문에 옵셔널 체이닝을 무조건 한다고 
        // 오해해버려도 사용상 지장 없음.
        guard let viewModel = viewModel else {return}
        
        // viewModel에 있는 데이터를 UI와 연결해준다.(ViewModel 로직에서 나눠둔 상태니까)
        nameLabel.text = viewModel.fullname                          
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    
        // 사용자가 프로필에 접속한 경우와 다른사람의 계정을 본 경우를 viewModel에 로직을 구현했고,
        // 그 결과에 따라 버튼의 UI를 변경해주고 있는 코드
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonBackgroundColor
        
        postLabel.attributedText = viewModel.numberOfPosts
        followersLabel.attributedText = viewModel.numberOfFollowers
        followingLabel.attributedText = viewModel.numberOfFollowing
        
    }
    
    
    
    
    
}


