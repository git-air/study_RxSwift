//
//  Protocols.swift
//  LearnRxSwift3
//
//  Created by AIR on 2022/06/17.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

enum SignupState {
    case signedUp(signedUp: Bool)
}



