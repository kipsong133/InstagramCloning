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
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        
    }
    
    //MARK: - Actions
    
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
    
    
    
    
    //MARK: - Helpers
    
    func configureUI() {
        
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleLogout))
        navigationItem.title = "Feed"
        
    }
    
    
    
}



//MARK: - UICollectionViewDataSource

extension FeedController {
    
    // Cell 갯수 생성 메소드
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    // Cell 생성 메소드
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
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
