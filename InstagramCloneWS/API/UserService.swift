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
    
    // 위에 메소드랑 차이가 있는데, 위에 메소드는 로그인한 계정의 정보만 가져온다면, 아래 메소드는 가입된 계정정보를 모두 가져온다.
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        // 1. 해당 경로에서 데이터를 가져온다.
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            // 2. 가져온 결과물을 옵셔널체이닝한다.
            guard let snapshot = snapshot else { return }
            
            // 공부용) snapshot에 있는 각각의 값들에 대해 처리해줄 로직들을 작성한다.
//            snapshot.documents.forEach { (document) in
//                // print("DEBUG: Document Service : \(document.data())") // 확인용
//                // users array에 user의 각각의 데이터를 appending한다.
//                // cf) 받는 데이터가 dictionary이므로 User의 구성과 완전히 동일해야만 값이 input된다.
//                let user = User(dictionary: document.data())
//                users.append(user) 
//            }
//            completion(users)
            
            // 3. .map으로 forEach에서 구현한 과정을 모두 해줌.
            let users = snapshot.documents.map({ User(dictionary: $0.data()) })
              
            // 4. users는 가입된 계정정보들이 있는 데이터이고 이 메소드를 호출한 곳에서 이 데이터를 활용할 수 있게된다.
            completion(users)
        }
    }
}
