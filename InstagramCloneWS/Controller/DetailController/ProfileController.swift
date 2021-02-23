//
//  ProfileController.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/18.
//

import UIKit

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var user: User
    
//    {
//        // fetchUser() 에서 데이터가 Model로 넘어가서 값을 변경한 다음에 .title의 값을 변경해주어야 하므로 didSet 활용.
//        didSet { collectionView.reloadData() }
//    }
    
    //MARK: - LifeCycle
    
    init(user: User) {
        // 이전에는 데이터를 ProfileController에서 직접 받았지만, TabBar에서 1 번만 받고 거기서 ProfileController를
        // 호출할 때, 초기화 파라미터로 데이터를 전달해주는 것이 메모리 절약의 효과가 있이므로 초기화메소드를 사용했다.
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()         // fuxxing Simple Logic.
        configrueCollectionView()   // CollectionView 구현한다.
//        fetchUser()                 // Load되면 데이터를 받아온다.
        
    }
    
    //MARK: - API
    
 
    
    //MARK: - Helpers
    
    func configrueCollectionView() {
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
    }
    
}


//MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        return cell
    }
    
    // 헤더 생성하는 메소드
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 프로필 화면으로 이동하면, 헤더화면을 구성해야할 것이다. 
        // 그러므로 ProfileHeader라는 View를 생성한 후, 사용자 정보에 맞는 데이터를 UI로 구현해야한다.
        // 그러므로 인스턴스 생성 -> viewModel 데이터 이동 이 두 과정을 controller 에서 해야한다.
        
        // 1. ProfileHeader 인스턴스를 생성한다.
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        // 2. user(데이터)를 ViewModel에 넣은 후, 결과값을 위에서 생성한 인스턴스의 viewModel에
        // 넣는다.( ProfileHeader의 변수로 viewModel을 만들어 준 상황임. )
        // Controller의 역할인 Input 데이터 넣는 과정이 바로 여기다.
        
        header.viewModel = ProfileHeaderViewModel(user: user)
         
        
        return header
    }
    
    
}

//MARK: - UICollectionViewDelegate

extension ProfileController {
    
}


//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    // cell 간격을 설정하는 메소드(가로)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // cell 간격을 설정하는 메소드(세로)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Cell의 사이즈를 설정하는 메소드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    // header의 사이즈를 설정하는 메소드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}
