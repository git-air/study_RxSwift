import RxSwift

/// HTTP通信を行うユーティリティクラス
class HTTP {
    /// GET
    static func get(url: URL) -> Observable<String> {
        
        return Observable<String>.create({ observer in
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                }
                else {
                    observer.onNext(String(data: data!, encoding: .utf8)!)
                    observer.onCompleted()
                }
            }
            task.resume()
            
            return Disposables.create()
        })
    }
}

/// RSSユーティリティクラス
class RSS {
    /// タイトル一覧取得
    static func getTitles(_ xml: String) -> Observable<String> {
        
        return Observable<String>.create { observer in
            do {
                // 正規表現でタイトル抽出
                let pattern = "<title>([^<]+)</title>"
                let regex = try NSRegularExpression(pattern: pattern, options: [
                    .anchorsMatchLines, .dotMatchesLineSeparators
                ])
                let range = NSRange(location: 0, length: xml.count)
                let results = regex.matches(in: xml, options: [], range: range)
                
                for result in results {
                    let start = xml.index(xml.startIndex, offsetBy: result.range(at: 1).location)
                    let end = xml.index(start, offsetBy: result.range(at: 1).length)
                    let text = String(xml[start..<end])
                    observer.onNext(text)
                }
                
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
}

/// API通信クラス
class API {
    /// RSSのURL定義
    private static let rssURLs = [
        "https://www.fsa.go.jp/fsaNewsListAll_rss2.xml",
        "https://www.fsa.go.jp/fsaProcurementList_rss2.xml",
    ]
    
    /// サブスレッド処理用のスケジューラー
    private static let scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "hogehoge")

    /// RSSのタイトル一覧取得
    static func getRSSTitles() -> Observable<[String]> {
        
        return Observable<String>
            .from(rssURLs)
            .flatMap({ url in
                return HTTP.get(url: URL(string: url)!)
            })
            .flatMap({ xml in
                return RSS.getTitles(xml)
                    .skip(1) // 1個目はRSSのタイトルなので飛ばす
                    .take(3) // 最新3件だけ
            })
            .buffer(timeSpan: .never, count: 0, scheduler: scheduler)
            .observeOn(MainScheduler.instance) // UI処理とかしやすいようにメインスレッドにして返してあげる
            .subscribeOn(scheduler) // サブスレッドで処理
    }
}

let disposeBag = DisposeBag()

func asyncSample() {

    API.getRSSTitles()
        .subscribe(onNext: { element in
            print(element.joined(separator: "\n"))
        })
        .disposed(by: disposeBag)
}

asyncSample()
