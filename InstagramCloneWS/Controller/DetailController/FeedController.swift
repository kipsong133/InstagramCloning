//
//  FeedController.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/18.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var posts = [Post]()
    
    // post는 ProfileController에서 특정 Cell을 클릭했을 때, 사용할 프로퍼티로
    // 1 개의 값만 있으면 된다.
    var post: Post? // ProfileController 에서 값을 받을 예정.
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        fetchPosts()
    }
    
    //MARK: - Actions
    
    // collectionView를 아래로 당기면, refresh되도록 수행하는 코드

    @objc func handleRefresh() {
//        posts.removeAll() // 잘은 모르겠는데, posts를 비우고나면, 데이터가 없어지므로, indexPath out of range 에러 발생.
        fetchPosts()
    }
    
    @objc func handleLogout() { // 로그아웃을 누르면 호출될 메소드
        do {
            // 1. Firebase에서 signOut 로직을 실행
            try Auth.auth().signOut()
            
            // 2. LoginController 인스턴스 생성
            let controller = LoginController()
            
            // 3. LoginController의 델리게이트 변수가 있는데, 그걸 MainTabController로 지정
            // 만약 여기서 Delegate를 지정하지 않는다면, 데이터관점에서는 로그인이되지만, 
            // LoginController가 dismiss가 안된다. 왜냐하면 DelegateProtocol function으로
            // dismiss를 구현해준 상황이므로.
            controller.delegate = self.tabBarController as? MainTabController
            
            // 4. present로 화면전환
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            
        } catch {
            print("DEBUG: Failed to sign out ")
        }
    }
    
    
    //MARK: - API
    
    func fetchPosts() {
        guard post == nil else { return }
        
        // fetcgPosts 메소드를 통해서 데이터를 읽어오는 로직
        PostService.fetchPosts { (posts) in
            // 읽어온 데이터를 controller의 인스턴스에 할당.
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(handleLogout))
        }
        
        navigationItem.title = "Feed"
        
        // collectionView를 아래로 당기면, refresh되도록 수행하는 코드
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    
    
}



//MARK: - UICollectionViewDataSource

extension FeedController {
    
    // Cell 갯수 생성 메소드
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {  // post가 nil인 경우 == 1 개의 cell을 클릭한 상황, 그 때는 셀이 1개만 필요하므로 3항 연산자 사용.
        return post == nil ? posts.count : 1
    }
    
    // Cell 생성 메소드
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        // post에 값이 있는 경우 == 1 개의 cell을 클릭한 상황, 그때는 1개의 cell만 보여주면 되므로 로직을 2 개로 쪼갬
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        
        return cell
    }
    
}



//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    // Cell Size 설정 메소드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
}
