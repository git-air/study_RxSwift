//
//  ViewController.swift
//  RxSwiftSample
//
//  Created by AIR on 2022/03/06.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.rx.text.orEmpty
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    


}

