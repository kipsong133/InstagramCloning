//
//  PostViewModel.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/02/24.
//

import Foundation

struct PostViewModel {
    private let post: Post
    
    var imageUrl: URL? { return URL(string: post.imageUrl) }
    
    var caption: String { return post.caption }
    
    var likes: Int { return post.likes}
    
    init(post: Post) {
        self.post = post
    }
}
