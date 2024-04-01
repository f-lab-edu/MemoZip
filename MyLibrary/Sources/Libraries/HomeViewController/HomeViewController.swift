//
//  HomeViewController.swift
//  MemoZip
//
//  Created by 박세라 on 3/9/24.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import TinyConstraints
import RxDataSources

typealias ManageMentDataSource = RxCollectionViewSectionedReloadDataSource<HomeSection>

public class HomeViewController: UICollectionViewController, View {
    
    public typealias Reactor = HomeViewReactor
    
    // MARK: - Constants
    /*
    struct Reusable { // cell 등록
        static let todoListCell = ReusableCell<TodoListCell>()
    }*/
    
    public var disposeBag = DisposeBag()
    let dataSource: ManageMentDataSource = ManageMentDataSource(configureCell: { _, collectionView, indexPath, items -> UICollectionViewCell in
    
        switch items {
        case .defaultCell(let reactor):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListCell", for: indexPath)
            // cell.reactor = reactor
            return cell
        }
        
    })
    
    
    public init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        self.collectionView.register(TodoListCell.self, forCellWithReuseIdentifier: "TodoListCell")
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGroundUI()
        
    }
    
    public func bind(reactor: HomeViewReactor) {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // action
        collectionView.rx.itemSelected
            .map{ Reactor.Action.cellSelected($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // state
        reactor.state.map { $0.selectedIndexPath }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.collectionView.deselectItem(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
        
        // ui
        reactor.state.map {$0.sections}.asObservable()
            .bind(to: self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    
    
    private func setBackGroundUI() {
        self.view.backgroundColor = .red
        
    }
}

