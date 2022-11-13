//
//  ImageService.swift
//  LearnRxSwift3
//
//  Created by AIR on 2022/11/13.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol ImageService {
    func imageFromURL(_ url: URL, reachabilityService: ReachabilityService) -> Observable<DownloadableImage>
}

class DefaultImageService: ImageService {
    
}
