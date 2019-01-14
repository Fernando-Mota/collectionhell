//
//  ViewController.swift
//  UICollectionViewHell
//
//  Created by Fernando Mota on 14/01/2019.
//  Copyright © 2019 Fernando Mota. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources


class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let array: Array<Dado> = [
        Dado(descricao: "Item 1"),
        Dado(descricao: "Item 2"),
        Dado(descricao: "Item 3"),
        Dado(descricao: "Item 4"),
        Dado(descricao: "Item 5"),
        Dado(descricao: "Item 6"),
        Dado(descricao: "Item 7")
    ]
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<Dados>(configureCell: {(dataSource, collectionView, indexPath, item: Dado) -> UICollectionViewCell in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celula", for: indexPath)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 17))
        label.text = item.descricao
        cell.addSubview(label)
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelToCollectionView()
    }
    
    private func bindViewModelToCollectionView(){
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
            header.frame.size.height = 500
            return header
        }
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
            return footer
        }
        
        let items = Observable.just([Dados(descricoes: array)])
        
        items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    

}

struct Dado {
    
    let descricao: String
    
}

struct Dados {
    
    var descricoes: [Dado]
    
}


extension Dados: SectionModelType {
    
    typealias Item = Dado
    
    var items: [Dado] {
        return descricoes
    }
    
    init(original: Dados, items: [Dado]) {
        self = original
        descricoes = items
    }
}

