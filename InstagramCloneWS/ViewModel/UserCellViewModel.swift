//
//  UserCellViewModel.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/02/23.
//

import Foundation

struct UserCellViewModel {
    // 1. user 데이터를 받을 그릇을 만든다.
    private let user : User
    
    // 3. 받은 데이터 중 url만 가져온다.
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    // 4. 받은 데이터 중 username만 가져온다.
    var username: String {
        return user.username
    }
    
    // 5. 받은 데이터 중 fullname만 가져온다.
    var fullname: String {
        return user.fullname
    }
    
    // 2. Controller에서 이 ViewModel을 생성할 때, 데이터를 넘겨줄 파라미터를 만들고
    // 바로 private let에 저장한다.
    init(user: User) {
        self.user = user
    }
}
