//
//  ImageUploader.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/19.
//

import FirebaseStorage

struct ImageUploader {
    
    // 이미지 upload(firebase에) 구현 메소드
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        // image를 0.75 압축한 후 객체에 저장
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        // uuid를 생성하여 경로를 저장
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "profile_images/\(filename)")
        
        // 그 경로에, 이미지를 넣는 로직
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: Falied to upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else {return}
                completion(imageUrl)
            }  
        }
    }
}
