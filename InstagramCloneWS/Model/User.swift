//
//  User.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/21.
//

import Foundation

struct User {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let username: String
    let uid: String
    
    // UserService에서 구현해야할 데이터 저장과정을 이곳에 바로 함.
    init(dictionary: [String:Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
