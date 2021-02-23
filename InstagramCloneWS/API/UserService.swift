//
//  UserService.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/21.
//

import Firebase

// 유저 정보를 가져오기
struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void) { // completion에 User가 있어서 이 메소드를 
                                                        // 사용하는 곳에서 user라는 input Data를 사용할 수 있음.
        // 1. uid값을 상수에 할당
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        // 2. "COLLECTION_USERS"의 경로에서 uid와 일치하는 데이터를 가져온다.
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            
            // 3. "dictionary"라는 상수에 데이터를 할당하고 
            guard let dictionary = snapshot?.data() else {return}
            
            // 4. User 모델에 데이터를 input 한다.
            let user = User(dictionary: dictionary)
            completion(user)
            
        }
    }
}
