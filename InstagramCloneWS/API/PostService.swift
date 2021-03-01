//
//  PostService.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/02/24.
//

import UIKit
import Firebase

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion)) {
        // 로직) + 버튼 클릭 -> PostController present -> 입력한 text와 image를 Firebase에 저장
        guard let uid = Auth.auth().currentUser?.uid else { return } // 사용자 uid 획득.
        
        ImageUploader.uploadImage(image: image) { (imageUrl) in
            // firebase 에 저장할 데이터 구조
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageUrl,
                        "ownerUid": uid,
                        "ownerImageUrl": user.profileImageUrl,
                        "ownerUsername": user.username] as [String: Any]
            
            // COLLECTION_POSTS 경로에 데이터를 추가하는 로직
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    // 이미지를 선택한 이후에, Firebase에 데이터를 저장하는 메소드
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        // order 메소드로 시간순으로 정렬했음. 실수 유의!!!
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            // For-statement 대신해서 map으로 대체.
            // postId를 == documentId 라고 생각.
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        // 작성자의 uid를 파라미터로 받고, post된 데이터(table)에서 찾아서 일치하는 것을 query에 할당
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid)            
        // whereField : Firebase 기능으로 uid를 기준으로 필터링해준다.
        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            var posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            
            posts.sort { (post1, post2) -> Bool in
                return post1.timeStamp.seconds > post2.timeStamp.seconds
            }
            
            completion(posts)
            
        }
    }
}


