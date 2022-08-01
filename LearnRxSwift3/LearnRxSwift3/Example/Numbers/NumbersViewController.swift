//
//  NumbersViewController.swift
//  LearnRxSwift3
//
//  Created by AIR on 2022/05/04.
//

import UIKit
import RxSwift
import RxCocoa

class NumbersViewController: UIViewController {
    
    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number2: UITextField!
    
    @IBOutlet weak var result: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty) {
            (textValue1, textValue2) in
            return textValue1 + textValue2
        }
            .map{$0.description}
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
