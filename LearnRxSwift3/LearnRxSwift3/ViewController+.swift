//
//  ViewController+.swift
//  LearnRxSwift3
//
//  Created by AIR on 2022/08/03.
//

import RxSwift

#if os(iOS)
    import UIKit
    typealias OSViewController = UIViewController
#elseif os(macOS)
    import Cocoa
    typealias OSViewController = NSViewController
#endif

class ViewController1: OSViewController {
    var disposeBag = DisposeBag()
}
