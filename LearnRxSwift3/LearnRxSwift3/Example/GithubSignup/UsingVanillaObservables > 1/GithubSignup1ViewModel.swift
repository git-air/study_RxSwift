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
            validationService: GitHubValidationService,
            wireframe: Wireframe
         )
    ){
        let API = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe
        
        validatedUsername = input.username
            .flatMapLatest { username in
                return validationService.validateUsername(username)
                    .observe(on: MainScheduler.instance)
                    .catchAndReturn(.failed(message: "Error contacting server"))
            }
            .share(replay: 1)
        
        validatedPassword = input.password
            .map { password in
                return validationService.validatePassword(password)
            }
            .share(replay: 1)
        
        validatedPasswordRepeated = Observable.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
            .share(replay: 1)
        
        let signinigIn = ActivityIndicator()
        self.signingIn = signinigIn.asObservable()
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { (username: $0, password: $1 )}
        
        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return API.signup(pair.username, password: pair.password)
                    .observe(on: MainScheduler.instance)
                    .asObservable().catchAndReturn(false)
                    .trackActivity(signinigIn)
            }
            .flatMapLatest { loggedIn -> Observable<Bool> in
                let message = loggedIn ? "Mock: Sifned in to GitHub." : "Mock: Sign in to GitHub failed"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    .map { _ in
                        loggedIn
                    }
            }
            .share(replay: 1)
        
        signupEnabled = Observable.combineLatest(
            validatedUsername,
            validatedPassword,
            validatedPasswordRepeated,
            signingIn.asObservable()
        ) { username, password, repeatPassword, signingIn in
            username.isValid &&
            password.isValid &&
            repeatPassword.isValid &&
            !signingIn
        }
        .distinctUntilChanged()
    }
    
    
}
