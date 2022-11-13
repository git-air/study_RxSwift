//
//  WikipediaSearchCell.swift
//  LearnRxSwift3
//
//  Created by AIR on 2022/11/13.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public class WikipediaSearchCell1: UITableViewCell {
    
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var URLOutlet: UILabel!
    @IBOutlet weak var imagesOutlet: UICollectionView!
    
    var disposeBag: DisposeBag?
    
    let imageService = DefaultImageService.sharedImageService
    
    
    
}
