//
//  User.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/21.
//

import Foundation
import Firebase

struct User {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let username: String
    let uid: String
    
    var isFollowed = false
    
    var state: UserStates!
    
    // 사용자인지 혹은 다른 사람 프로필인지 확인하기 위한 용도의 연산프로퍼티
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    // UserService에서 구현해야할 데이터 저장과정을 이곳에 바로 함.
    init(dictionary: [String:Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.state = UserStates(followers: 0, following: 0)
    }
}

// Profile에서 정보를 보여주기 위한 Model
struct UserStates {
    let followers: Int
    let following: Int
//    let posts: Int
}
