//
//  UserService.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/21.
//

import Firebase

// 유저 정보를 가져오기
struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
            
        }
    }
}
