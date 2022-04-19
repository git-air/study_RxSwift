//
//  ViewController.swift
//  LearnRxSwift1
//
//  Created by AIR on 2022/04/07.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private let count: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindButtonToValue()
        bindCountToText()
        // Do any additional setup after loading the view.
    }
    
    private func bindButtonToValue() {
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.increment()
            })
            .disposed(by: disposeBag)
    }
    
    private func increment() {
        count.accept(count.value + 1)
    }
    
    private func bindCountToText() {
        count.asObservable()
            .map{ String($0) }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
//        count.asObservable()
//            .subscribe(onNext: { [weak self] count in
//                self?.label.text = String(count)
//            })
//            .disposed(by: disposeBag)
    }
    
    
}

