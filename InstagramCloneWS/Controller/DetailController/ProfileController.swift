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
    
    // 원래는 아래 코드처럼 didSet을 사용했었으나, 여기에서는 var로 변경하고 View에서 didSet으로 변경함.
    // 이유 : 이 Controller에서 데이터통신을하는 것이 아니라, MainTabBarController에서 데이터를 수신하고,
    // 여기서는 init(user:)의 파라피터를 이용해서 데이터를 받을 것이기 때문이다. 그리고 로그아웃하고 다시 로그인하면
    // 프로필이 업데이트 된다. 이유는 MainTabBarController에서 새롭게 controller 인스턴스를 생성하므로
    // 데이터도 그에 맞게 업데이트 될 것이다.
    private var user: User 
//    {
//        // fetchUser() 에서 데이터가 Model로 넘어가서 값을 변경한 다음에 .title의 값을 변경해주어야 하므로 didSet 활용.
//        didSet { collectionView.reloadData() }
//    }
        
    private var posts = [Post]()
    
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
        checkIfUserIsFollowed()
        fetchUserStates()
        fetchPosts()
    }
    
    //MARK: - API
    
    func checkIfUserIsFollowed() {
        // UserService에서 구현한 메소드 호출하기 위해 만든 메소드임.
        UserService.checkIfUserIsFollowed(uid: user.uid) { (isFollowed) in
            // 내 계정의 팔로우 목록중 상대방Uid가 있는지 확인하고 그 결과를 isFollowed로 전달받으니까
            // 그걸 controller에서 데이터를 업데이트해주는 것임.
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
            
            
        }
    }
 
    // 사용자의 following follower의 상태를 알기 위해서 사용하는 메소드임.
    func fetchUserStates() {
        UserService.fetchUserState(uid: user.uid) { (stats) in
            self.user.state = stats
            self.collectionView.reloadData()
             
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts(forUser: user.uid) { (posts) in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
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
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
    
    // 헤더 생성하는 메소드
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 프로필 화면으로 이동하면, 헤더화면을 구성해야할 것이다. 
        // 그러므로 ProfileHeader라는 View를 생성한 후, 사용자 정보에 맞는 데이터를 UI로 구현해야한다.
        // 그러므로 인스턴스 생성 -> viewModel 데이터 이동 이 두 과정을 controller 에서 해야한다.
        
        // 1. ProfileHeader 인스턴스를 생성한다.
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self
        
        // 2. user(데이터)를 ViewModel에 넣은 후, 결과값을 위에서 생성한 인스턴스의 viewModel에
        // 넣는다.( ProfileHeader의 변수로 viewModel을 만들어 준 상황임. )
        // Controller의 역할인 Input 데이터 넣는 과정이 바로 여기다.
        
        header.viewModel = ProfileHeaderViewModel(user: user)
         
        
        return header
    }
    
    
}

//MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // ProfileController에 있는 Cell을 클릭해면 해당 게시물로 이동하는 로직
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        // 클릭하면 해당 게시물로 이동하기 위해서 선택된 데이터를 controller의 객체로 넘겨줌.
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
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

//MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        
        if user.isCurrentUser {
            // 자신의 프로필을 변경하려 할때, 아래 로직을 진행한다.
            print("DEBUG: show edit profile here...")
        } else if user.isFollowed {
            // unfollow 시 아래 로직을 진행한다.
            UserService.unfollow(uid: user.uid) { (error) in
                // follow버튼을 클릭했을 때, 아래 로직을 진행한다.
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.follow(uid: user.uid) { (error) in
                // follow버튼을 클릭했을 때, 아래 로직을 진행한다.
                self.user.isFollowed = true
                self.collectionView.reloadData()
            }
        }
    }
    
    
}
