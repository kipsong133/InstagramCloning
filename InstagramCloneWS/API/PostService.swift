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
        COLLECTION_POSTS.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            // For-statement 대신해서 map으로 대체.
            // postId를 == documentId 라고 생각.
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            completion(posts)
        }
    }
}
