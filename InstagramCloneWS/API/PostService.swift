//
//  PostService.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/02/24.
//

import UIKit
import Firebase

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        // 로직) + 버튼 클릭 -> PostController present -> 입력한 text와 image를 Firebase에 저장
        guard let uid = Auth.auth().currentUser?.uid else { return } // 사용자 uid 획득.
        
        ImageUploader.uploadImage(image: image) { (imageUrl) in
            // firebase 에 저장할 데이터 구조
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageUrl,
                        "ownerUid": uid] as [String: Any]
            
            // COLLECTION_POSTS 경로에 데이터를 추가하는 로직
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
}
