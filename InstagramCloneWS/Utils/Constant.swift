//
//  Constant.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/21.
//

import Firebase

// FireStore의 collection 중 "users"로 이동
let COLLECTION_USERS = Firestore.firestore().collection("users")

// FireStore의 collection 중 각각 "" 내부의 이름으로 이동
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")

