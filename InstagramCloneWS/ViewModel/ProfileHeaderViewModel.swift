//
//  ProfileHeaderViewModel.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/21.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    init(user: User) {
        self.user = user
        
    }
    
}
