import RxSwift

func timerSample() {

    // 一定時間後に発行するObservableの作成
    let observable = Observable<Int>
        .timer(.seconds(3), scheduler: MainScheduler.instance)

    print(Date())
    
    // Observer購読
    _ = observable
        .subscribe(onNext: { element in
            print("Observer: \(element), Date: \(Date())")
        })
}

timerSample()
