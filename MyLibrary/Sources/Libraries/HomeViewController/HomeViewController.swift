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
import Model
import ViewModelImp
import ViewModel

public protocol HomeRouting {
    func addMemoViewController() -> UIViewController
}

public class HomeViewController: UICollectionViewController {
    
    typealias Reactor = HomeViewReactor
    
    private let reactor: Reactor
    private var disposeBag: DisposeBag = .init()
    private let routing: HomeRouting

    typealias DataSource = RxCollectionViewSectionedReloadDataSource<HomeSection>
    lazy var dataSource = DataSource(configureCell: { dataSource, collectionView, indexPath, item in
        
        switch item {
        case .defaultCell(let reactor):
            let cell = collectionView.dequeueReusableCell(TodoListCell.self, for: indexPath)
            cell.reactor = reactor
            return cell
        case .categoryCell(let items):
            let cell = collectionView.dequeueReusableCell(CategoryCell.self, for: indexPath)
            cell.initCellWithItems(items: items)
            return cell
        case .planCell(let reactor):
            let cell = collectionView.dequeueReusableCell(PlanListCell.self, for: indexPath)
            cell.reactor = reactor
            return cell
        }
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            // 재사용 가능한 헤더셀을 가져옴
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as? HeaderCell else {
                return UICollectionReusableView()
            }
            
            header.reactor = HeaderCellReactor(headerTitle: dataSource[indexPath.section].header)
        
            header.addButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.reactor.action.onNext(.addItem(indexPath))
                })
                .disposed(by: header.disposeBag)
            
            return header
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    })
    
    public init(reactor: HomeViewReactor, routing: HomeRouting) {
        self.reactor = reactor
        self.routing = routing
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        
        bindReactor()
        
        reactor.action.onNext(.initiate)
    }
    
    private func initCollectionView() {
        self.collectionView.register(TodoListCell.self)
        self.collectionView.register(CategoryCell.self)
        self.collectionView.register(PlanListCell.self)
        self.collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCell")
        
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    public func bindReactor() {
        
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
        
        reactor.state.map { $0.move }
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self ] indexPath in
                guard let self = self else { return }
                let viewController = self.routing.addMemoViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
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
        
        switch dataSource.sectionModels[indexPath.section].items[indexPath.item] {
        case .defaultCell(_):
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 44)
        case .categoryCell(_):
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 32)
        case .planCell(_):
            return CGSize(width: (UIScreen.main.bounds.width - 44.0) / 2, height: (UIScreen.main.bounds.width - 44.0) * 0.6 )
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            return header
        default:
            return UICollectionReusableView()
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        var height: CGFloat = 60
        // header가 없을 경우 default Header Height 설정
        if dataSource.sectionModels[section].header == "" {
            height = 16
        }
        return CGSize(width: width, height: height)
    }
}
