//
//  ViewController.swift
//  LearnRxSwift2
//
//  Created by AIR on 2022/04/20.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.rx.tap
            .subscribe { [unowned self] _ in
                print("aaa")
            }
            .disposed(by: disposeBag)
        
    }


}

