//
//  HomeViewController.swift
//  MemoZip
//
//  Created by 박세라 on 3/9/24.
//

import UIKit
import ReactorKit
import RepositoryImp
import RxCocoa
import RxSwift
import TinyConstraints
import RxDataSources
import Model

typealias ManageMentDataSource = RxCollectionViewSectionedReloadDataSource<HomeSection>

public class HomeViewController: UICollectionViewController, View {
    
    public typealias Reactor = HomeViewReactor
    
    public var disposeBag = DisposeBag()

    let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSection>(configureCell: { dataSource, collectionView, indexPath, item in
        
        switch item {
        case .defaultCell(let reactor):
            let cell = collectionView.dequeueReusableCell(TodoListCell.self, for: indexPath)
            cell.reactor = reactor
            return cell
        case .planCell(let reactor):
            let cell = collectionView.dequeueReusableCell(PlanListCell.self, for: indexPath)
            cell.reactor = reactor
            return cell
        }
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as? HeaderCell else {
                return UICollectionReusableView()
            }
            header.reactor = HeaderCellReactor(state: Title(title: dataSource[indexPath.section].header))
            return header
        default:
            assert(false, "Unexpected element kind")
        }
    })
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        
        let reactor = Reactor(todoRepository: TodoRepositoryImp())
        self.bind(reactor: reactor)
        reactor.action.onNext(.initiate)
    }
    
    private func initCollectionView() {
        self.collectionView.register(TodoListCell.self)
        self.collectionView.register(PlanListCell.self)
        self.collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCell")
        
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    public func bind(reactor: HomeViewReactor) {
        
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
        reactor.state.map { $0.sections }
            .asObservable()
            .bind(to: self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    
         
    }

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    // TODO: 유동적인 높이 구현.
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 44)
        case 1:
            return CGSize(width: (UIScreen.main.bounds.width - 44.0) / 2, height: (UIScreen.main.bounds.width - 44.0) * 0.6 )
        default: return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 44)
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            return header
            /*
             case UICollectionView.elementKindSectionFooter:
             let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyHeaderFooterView", for: indexPath) as! MyHeaderFooterView
             return footer
             */
        default:
            return UICollectionReusableView()
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 60
        return CGSize(width: width, height: height)
    }
}

