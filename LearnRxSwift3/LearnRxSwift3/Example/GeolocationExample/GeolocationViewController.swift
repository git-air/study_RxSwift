//
//  GeolocationViewController.swift
//  LearnRxSwift3
//
//  Created by AIR on 2022/05/24.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

private extension Reactive where Base: UILabel {
    var coordinates: Binder<CLLocationCoordinate2D> {
        return Binder(base) { label, location in
            label.text = "緯度：\(location.latitude)\n軽度：\(location.longitude)"
        }
    }
}

class GeolocationViewController: UIViewController {

    @IBOutlet var neoGeolocationView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(neoGeolocationView)
        
        let geolocationService = GeolocationService.instance
        
        geolocationService.authorized
            .drive(neoGeolocationView.rx.isHidden)
            .disposed(by: disposeBag)
        
        geolocationService.location
            .drive(label.rx.coordinates)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .bind { [weak self] _ -> Void in
                self?.openAppPreferences()
            }
            .disposed(by: disposeBag)
        
        button2.rx.tap
            .bind{ [weak self] _ -> Void in
                self?.openAppPreferences()
            }
            .disposed(by: disposeBag)
    }
    
    private func openAppPreferences() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
}
