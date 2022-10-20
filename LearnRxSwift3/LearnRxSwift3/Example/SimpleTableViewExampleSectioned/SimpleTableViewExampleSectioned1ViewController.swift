//
//  SimpleTableViewExampleSectioned1ViewController.swift
//  LearnRxSwift3
//
//  Created by AIR on 2022/10/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SimpleTableViewExampleSectioned1ViewController: UIViewController1, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>(
        configureCell: { (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(indexPath.row)"
            return cell
        },
        titleForHeaderInSection: { dataSouce, sectionIndex in
            return dataSouce[sectionIndex].model
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = self.dataSource
        
        let items = Observable.just([
            SectionModel(model: "First section", items: [
                1.0,
                2.0,
                3.0
            ]),
            SectionModel(model: "Second section", items: [
                1.0,
                2.0,
                3.0
            ]),
            SectionModel(model: "Third section", items: [
                1.0,
                2.0,
                3.0
            ])
        ])
        
        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { pair in
                DefaultWireframe.presentAlert("Tapped `\(pair.1)` @ \(pair.0)")
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
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
