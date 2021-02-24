//
//  UserService.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/21.
//

import Firebase

typealias FirestoreCompletion = (Error?) -> Void

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
    
    
    static func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // 사용자Uid의 컬랙션 중 "user-following"으로 이동하고, (선택한)uid를 추가한다.
        // 그리고 Completion 블럭 내에 같은 로직이지만 테이블만 "user-follower"로 변경하여 uid를 똑같이 넣는다.
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { (error) in                  // 여기까지로직은 내 데이터에 내가 팔로우했으니가 상대방의 id를 넣는다.
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion) // 여기로직은 내가 팔로워가 되고 내 데이터를 상대방에게 넣는다.
        }
    }
    
    
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        // Following 테이블에 가서 (내 계정의) 언팔할 uid를 삭제한다.
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete { (error) in
            // Follower 테이블 가서 (상대방계정) 내 uid를 삭제한다.
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    
 
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void ) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        // 내 id로 가서 "user-following"에 들어가고, 내가 (선택한)특정 계정의 id 정보를 가져온다.
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument { (snapshot, error) in
            // 그 결과로 snapshot이 나오는데 그 결과가 만약에 있으면 true, 없으면 false ==> 이를 통해 follow 여부 확인.
            // 내가만약 언팔한 상태라면 내가 선택한 계정에 uid가 없을 것이고, 팔로우상태면 있을 것이므로.
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
    
    // 현재 following과 follower을 보여주기 위한 fetch 메소드
    // ProfileCotnroller - Header 에서 사용하기 위해 만듦.
    static func fetchUserState(uid: String, completion: @escaping(UserStates) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, error) in
            // table로 이동한다음에 거기서 결과값을 follower에 저장
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { (snapshot, error) in
            // table로 이동한 다음에 거기서 결과값을 following에 저장
                let following = snapshot?.documents.count ?? 0
                
                // 두 결과 값을 completion으로 전달하는데 model에 맞춰 전달한다.
                completion(UserStates(followers: followers, following: following))
            }
        }
    }
    
    
}
