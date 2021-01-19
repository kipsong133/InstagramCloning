//
//  AuthenticationViewModel.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/19.
//

import Foundation

struct LoginViewModel {
    var email: String?
    var password: String?
    
    var formValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
}

struct RegistrationViewModel {
    
    
}
