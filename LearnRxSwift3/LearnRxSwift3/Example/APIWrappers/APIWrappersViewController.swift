//
//  APIWrappersViewController.swift
//  LearnRxSwift3
//
//  Created by AIR on 2022/08/13.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

extension UILabel {
    open override var accessibilityValue: String! {
        get {
            return self.text
        }
        set {
            self.text = newValue
            self.accessibilityValue = newValue
        }
    }
}

class APIWrappersViewController: ViewController1 {
    
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var openActionSheet: UIButton!
    @IBOutlet weak var openAlertView: UIButton!
    @IBOutlet weak var bbitem: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var mypan: UIPanGestureRecognizer!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.date = Date(timeIntervalSince1970: 0)
        
        bbitem.rx.tap
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIBarButtonItem Tapped")
            })
            .disposed(by: disposeBag)
        
        let segmentedValue = BehaviorRelay(value: 0)
        _ = segmentedControl.rx.value <-> segmentedValue
        
        segmentedValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UISegementedControl value \(x)")
            })
            .disposed(by: disposeBag)
        
        let switchValue = BehaviorRelay(value: true)
        _ = switcher.rx.value <-> switchValue
        
        switchValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UISwitch value \(x)")
            })
            .disposed(by: disposeBag)
        
        switcher.rx.value
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIButton Tapped")
            })
            .disposed(by: disposeBag)
        
        let sliderValue = BehaviorRelay<Float>(value: 1.0)
        _ = slider.rx.value <-> sliderValue
        
        sliderValue.asObservable()
            .subscribe(onNext: {[weak self] x in
                self?.debug("UISlider value \(x)")
            })
            .disposed(by: disposeBag)
        
        let dateValue = BehaviorRelay(value: Date(timeIntervalSince1970: 0))
        _ = datePicker.rx.date <-> dateValue
        
        dateValue.asObservable()
            .subscribe(onNext: {[weak self] x in
                self?.debug("UIDatePicer date \(x)")
            })
            .disposed(by: disposeBag)
        
        if #available(iOS 11.2, *) {
            let textValue = BehaviorRelay(value: "")
            _ = textField.rx.textInput <-> textValue
            
            textValue.asObservable()
                .subscribe(onNext: { [weak self] x in
                    self?.debug("UITextField text \(x)")
                })
                .disposed(by: disposeBag)
            
            let attributedTextValue = BehaviorRelay<NSAttributedString?>(value: NSAttributedString(string: ""))
            _ = textField2.rx.attributedText <-> attributedTextValue
            
            attributedTextValue.asObservable()
                .subscribe(onNext: { [weak self] x in
                    self?.debug("UITextField attributedText \(x?.description ?? "")")
                })
                .disposed(by: disposeBag)
        }
        
        mypan.rx.event
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIGestureRecognizer event \(x.state.rawValue)")
            })
            .disposed(by: disposeBag)
        
        let textViewValue = BehaviorRelay(value: "")
        _ = textView.rx.textInput <-> textViewValue

        textViewValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextView text \(x)")
            })
            .disposed(by: disposeBag)

        let attributedTextViewValue = BehaviorRelay<NSAttributedString?>(value: NSAttributedString(string: ""))
        _ = textView2.rx.attributedText <-> attributedTextViewValue

        attributedTextViewValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextView attributedText \(x?.description ?? "")")
            })
            .disposed(by: disposeBag)
        
        manager.requestWhenInUseAuthorization()

        manager.rx.didUpdateLocations
            .subscribe(onNext: { x in
                print("rx.didUpdateLocations \(x)")
            })
            .disposed(by: disposeBag)

        _ = manager.rx.didFailWithError
            .subscribe(onNext: { x in
                print("rx.didFailWithError \(x)")
            })
        
        manager.rx.didChangeAuthorizationStatus
            .subscribe(onNext: { status in
                print("Authorization status \(status)")
            })
            .disposed(by: disposeBag)
        
        manager.startUpdatingLocation()
    }
    
    
    func debug(_ string: String) {
        print(string)
        debugLabel.text = string
    }
    
}
