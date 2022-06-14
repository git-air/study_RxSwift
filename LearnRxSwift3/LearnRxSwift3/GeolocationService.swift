//
//  GeolocationService.swift
//  LearnRxSwift3
//
//  Created by AIR on 2022/05/29.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class GeolocationService {
    
    static let instance = GeolocationService()
    /*
     private (set)
     setだけprivateにできるやつ
     Driver<Bool>
     メインスレッドで通知
     エラーが発生しない
     */
    private (set) var authorized: Driver<Bool>
    private (set) var location: Driver<CLLocationCoordinate2D>
    
    // CLLocationManager()宣言
    private let locationManager = CLLocationManager()
    
    private init() {
        
        // 位置情報取得間隔
        locationManager.distanceFilter = kCLDistanceFilterNone
        // 取得精度の設定
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // subscribeされるたびにObservableを新しく生成する
        authorized = Observable.deferred { [weak locationManager] in
//            let status = CLLocationManager.authorizationStatus()
            let manager = CLLocationManager()
            // 認証状況
            let status = manager.authorizationStatus
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            
            return locationManager
            // didChangeAuthorizationStatus がでりげいと
                .rx.didChangeAuthorizationStatus
                .startWith(status)
        }
        // driverに関する処理をまとめたもの
        // CLAuthorizationStatus.notDetermined
        // このアプリケーションに関して、ユーザーはまだ選択をしていません。
        .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
        .map {
            // statusによってbool返却
            switch $0 {
            case .authorizedAlways:
                return true
            case .authorizedWhenInUse:
                return true
            default:
                return false
            }
        }
        
        // delegateメソッド
        location = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }
            .map { $0.coordinate }
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}
