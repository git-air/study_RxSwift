//
//  GithubSignup1ViewModel.swift
//  LearnRxSwift3
//
//  Created by AIR on 2022/06/17.
//

import Foundation
import RxSwift
import RxCocoa

class GithubSignup1ViewModel {
    
    let validatedUsername: Observable<ValidationResult>
    let validatedPassword: Observable<ValidationResult>
    let validatedPasswordRepeated: Observable<ValidationResult>
    
    // signupボタンの状態
    let signupEnabled: Observable<Bool>
    
    // サインインしているかどうか
    let signedIn: Observable<Bool>
    
    let signingIn: Observable<Bool>
    
    init(input: (
        username: Observable<String>,
        password: Observable<String>,
        repeatedPassword: Observable<String>,
        loginTaps: Observable<Void>
    ),
         dependency: (
            API: GitHubAPI,
            validationService: GitHubValidationService
//            wireframe: Wireframe)
    ) {
        
    }
    
    
}
