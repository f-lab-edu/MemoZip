//
// HomeViewController.swift
// MemoZip
//
// Created by 박세라 on 3/9/24.
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

public protocol HomeRouting {
    func addMemoViewController(messageHandler: @escaping (String) -> ()) -> UIViewController
    func addReadingViewController(dataHandler: @escaping (Book) -> ()) -> UICollectionViewController
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
            cell.selectedHandler = { [weak self] catIndex in // 선택된 카테고리 index
                guard let self = self else { return }
                let selectedPlanType = PlanType.allCases[catIndex]
                self.reactor.action.onNext(.planTypeSelected(selectedPlanType))
            }
            return cell
        case let .planTypesCell(planType):
            let cell = collectionView.dequeueReusableCell(PlanTypesCell.self, for: indexPath)
            cell.configure(selectedPlanType: planType)
            cell.selectionHandler = { [weak self] selectedPlanType in // 선택된 카테고리 index
                self?.reactor.action.onNext(.planTypeSelected(selectedPlanType))
            }
            return cell
        case .bookCell(let reactor):
            let cell = collectionView.dequeueReusableCell(BookListCell.self, for: indexPath)
            cell.reactor = reactor
            return cell
        case .memoCell(let reactor):
            let cell = collectionView.dequeueReusableCell(MemoListCell.self, for: indexPath)
            cell.reactor = reactor
            cell.deleteButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.reactor.action.onNext(.deleteMemo(indexPath))
                })
                .disposed(by: self.disposeBag)
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
                    self.reactor.action.onNext(.moveToAddMemo(indexPath))
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
        self.collectionView.register(PlanTypesCell.self)
        self.collectionView.register(BookListCell.self)
        self.collectionView.register(MemoListCell.self)
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
                
                // ActionSheet 설정 (카테고리 선택 후 item 추가)
                let actionsheetController = UIAlertController(title: "작성하실 형식을 선택해주세요.", message: "", preferredStyle: .actionSheet)
                
                let actionMemo = UIAlertAction(title: "메모", style: .default, handler: { _ in
                    let viewController = self.routing.addMemoViewController { [weak self] memo in
                        guard let self = self else { return }
                       
                        Observable.just(memo)
                            .map { HomeViewReactor.Action.addMemo($0) }
                            .bind(to: self.reactor.action)
                            .disposed(by: self.disposeBag)
                    }
                    self.present(viewController, animated: true)
                })
                let actionBook = UIAlertAction(title: "독서계획", style: .default, handler: { _ in
                    let viewController = self.routing.addReadingViewController() { [weak self] book in
                        guard let self = self else { return }
                        
                        Observable.just(book)
                            .map { HomeViewReactor.Action.addBook($0) }
                            .bind(to: self.reactor.action)
                            .disposed(by: self.disposeBag)
                        
                    }
                    self.present(viewController, animated: true)
                })

                let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

                actionsheetController.addAction(actionMemo)
                actionsheetController.addAction(actionBook)
                actionsheetController.addAction(actionCancel)
                
                self.present(actionsheetController, animated: true)
                
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
        case .categoryCell, .planTypesCell:
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 32)
        case .bookCell(_):
            return CGSize(width: (UIScreen.main.bounds.width - 44.0) / 2, height: (UIScreen.main.bounds.width - 44.0) * 0.6 )
        case .memoCell(_):
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 80)
            
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
