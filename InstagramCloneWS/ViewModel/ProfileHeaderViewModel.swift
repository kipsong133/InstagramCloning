//
//  ProfileHeaderViewModel.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/21.
//
// ViewModel을 만들 때, 기준이 있다.
// 1. 데이터가 업데이트 됨에 따라서 UI 변경되어야 한다.
// 2. 변경될 여지가 상당히 많다.
// ex) 내 정보(프로필)화면, 카테고리에 따른 테이블 뷰 혹은 컬렉션뷰 데이터 변화 등...

import Foundation
import UIKit

// 내 정보 페이지 최 상단에 들어갈 Header에 데이터를 가져오고 그 값을 활용하기 위해 작성된 struct.
struct ProfileHeaderViewModel {
    
    // user에 가져온 값들이 모두 있기에 초기화를 해줌.
    let user: User
    
    // 직접 값을 할당하는 것이 아니라 원본을 받고 그 값을 연산프로퍼티를 이용해서 나머지를 할당한다.
    var fullname: String {
        return user.fullname
    }
    
    // 이미지를 직접 저장하는 것보다 URL로 받을 가능성이 상당히 농후하므로 잘 봐두자.
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var followButtonText: String {
        if user.isCurrentUser { // 사용자가 자신의 프로필을 보러온 경우,
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    init(user: User) {
        // 원본 user에서 이 struct로 가져오기 위한 코드.
        // 이 구조체를 호출하는 곳에서 호출 할 때, user 값을 넣겠지?
        // 그러면 이 구조체 내부에 연산프로퍼티로 fullname과 profileImageUrl에 값이 생긴다.
        self.user = user
        
    }
    
}
