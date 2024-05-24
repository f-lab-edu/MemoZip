//
//  AddReadingViewController.swift
//
//
//  Created by 박세라 on 5/23/24.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import TinyConstraints
import RxDataSources

import Model
import ViewModel
import Repository


public class AddReadingViewController: UICollectionViewController {
    
    // MARK: Properties
    private let reactor: Reactor
    private var disposeBag: DisposeBag = .init()
    
    typealias Reactor = ReadingViewReactor
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<ReadingSection>
    lazy var dataSource = DataSource(configureCell: { dataSource, collectionView, indexPath, item in
        
        switch item {
        case .titleCell(let reactor):
            let cell = collectionView.dequeueReusableCell(BookTitleCell.self, for: indexPath)
            cell.reactor = reactor
            return cell
        }
    })
    
    public init(reactor: ReadingViewReactor) {
        self.reactor = reactor
        // self.routing = routing
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        initCollectionView()
        
        reactor.action.onNext(.initiate)
        
        bindReactor()
        
    }
    
    private func initCollectionView() {
        self.collectionView.register(BookTitleCell.self)
        
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    public func bindReactor() {
        
        // ui
        reactor.state.map { $0.sections }
            .asObservable()
            .do(onNext: { sections in
                print("Sections:\(sections)")
            })
            .bind(to: self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension AddReadingViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch dataSource.sectionModels[indexPath.section].items[indexPath.item] {
        case .titleCell(_):
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 80)
        }
    }
    
}
