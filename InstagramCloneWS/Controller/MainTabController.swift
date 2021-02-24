//
//  MainTabController.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/18.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController {
    
    //MARK: Properties
    
    private var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewController(withUser: user)
        }
    }
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkIfUserIsLoggedIn()
        fetchUser()
//        logout()
        
    }
    
    //MARK: - API
    
    func fetchUser() {
        UserService.fetchUser { (user) in
            self.user = user
        }
    }
    
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                
                // LoginController를 present하기 전에 delegate를 지정해준다.
                // 보통의 경우 viewDidLoad() 에서 하지만 이곳에서 하는 이유 :
                // 굳이 viewDidLoad의 순간에는 Delegate가 필요없다. 
                // LoginController의 인스턴스를 생성하기 직전에 지정해주는게 메모리 사용을 최소화할 수 있다.
                controller.delegate = self
                
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        }
    }
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    
    
    
    //MARK: - Helpers
    
    func configureViewController(withUser user: User) {
        
        // UITabBarControllerDelegate의 Delegate임.(extension에 있음)
        self.delegate = self
        
        // TabBar의 각각 할당될 Controller의 인스턴스를 생성.
        
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        let notification = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        
        let profileController = ProfileController(user: user)
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)
        
        // UITabBarController에서 사용하는 Array 
        viewControllers = [feed, search, imageSelector, notification, profile]
        
        tabBar.tintColor = .black
    }
    
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    
    // 이미지를 선택한 다음 할 행동 메소드(extension YP...에서 사용중.)
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { (items, _) in
            picker.dismiss(animated: false) { 
                // 선택한 이미지를 "selectedImage" 에 저장.
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                // UploadController로 이동(선택한 이미지와 함께)
                let controller = UploadPostController()
                
                // 포스팅 종료 후, FeedController 이동을 위한 프로토콜 구현했으므로
                // Delegate 지정 (UploadPostControllerDelegate)
                controller.delegate = self
                
                // 이미지 전달
                controller.selectedImage = selectedImage
                
                // 화면 전환
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        }
    }
    
    
}

//MARK: - AuthenticationDelegate
// LoginController의 로직을 대리수행할 func 구현

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    
    // TabBar가 클릭 될 때마다 호출되는 메소드로, 몇 번째를 클릭했는지는 index를 통해서 알 수 있음.
    // (viewControllers?.firstIndex(of: viewController)
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        // + 버튼을 눌렀을 때,
        if index == 2 {
            // YPImagePicker 라이브러리 사용. (cocopod + import)
            var config = YPImagePickerConfiguration()       // 인스턴스 생성
            config.library.mediaType = .photo               // 사용할 라이브러리는 photo
            config.shouldSaveNewPicturesToAlbum = false     // 저장은 하지 않는다.
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1             // 사진 최대 선택 개수.
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            // 여기까지만하면 Error가 발생함. why? info.plist에서 카메라 or 앨범 사용 허용설정을 안해서.
            
            // 이미지를 선택한 다음 할 행동 메소드(Helper에 정의해둠)
            didFinishPickingMedia(picker)
        }
        
        return true
    }
}


//MARK: - UploadPostControllerDelegate

extension MainTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0                                   // FeedController를 보여줌.
        controller.dismiss(animated: true, completion: nil) // 포스팅아친 후 포스팅controlelr dismiss
    }
    
    
}
