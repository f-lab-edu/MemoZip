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
import Common

public protocol HomeRouting {
    func addMemoViewController(messageHandler: @escaping (String) -> ()) -> UIViewController
    func addReadingViewController(openViewType: OpenViewType, book: Book?, dataHandler: @escaping (Book) -> ()) -> UICollectionViewController
}

public class HomeViewController: UICollectionViewController, MemoListCellDelegate {
    
    typealias Reactor = HomeViewReactor
    
    private let reactor: Reactor
    private var state: Reactor.State { self.reactor.currentState }
    private var disposeBag: DisposeBag = .init()
    private let routing: HomeRouting
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<HomeSection>
    lazy var dataSource = DataSource { dataSource, collectionView, indexPath, item in
        switch item {
        case let .title(title):
            let cell = collectionView.dequeueReusableCell(HeaderCell.self, for: indexPath)
            cell.configure(with: title) { [weak self] in
                self?.addItem()
            }
            return cell
        case let .todo(reactor):
            let cell = collectionView.dequeueReusableCell(TodoListCell.self, for: indexPath)
            cell.reactor = reactor
            return cell
        case let .planType(planType):
            let cell = collectionView.dequeueReusableCell(PlanTypesCell.self, for: indexPath)
            cell.configure(selectedPlanType: planType)
            cell.selectionHandler = { [weak self] selectedPlanType in // 선택된 카테고리 index
                self?.reactor.action.onNext(.planTypeSelected(selectedPlanType))
            }
            return cell
        case let .memo(memo):
            let cell = collectionView.dequeueReusableCell(MemoListCell.self, for: indexPath)
            cell.configure(with: memo.content)
            cell.delegate = self
            return cell
        case let .book(reactor):
            let cell = collectionView.dequeueReusableCell(BookListCell.self, for: indexPath)
            cell.reactor = reactor
            return cell
        }
    }
    
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
        self.collectionView.register(HeaderCell.self)
        self.collectionView.register(TodoListCell.self)
        self.collectionView.register(PlanTypesCell.self)
        self.collectionView.register(MemoListCell.self)
        self.collectionView.register(BookListCell.self)
        
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    public func bindReactor() {
        
        // bookListCell Selected Action
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let item = self.dataSource[indexPath]
                switch item {
                case let .book(reactor):
                    let item = reactor.currentState
                    
                    let viewController = self.routing.addReadingViewController(openViewType: .update, book: item) { [weak self] book in
                        guard let self = self else { return }
                        
                        Observable.just(book)
                            .map { HomeViewReactor.Action.updateBook($0) }
                            .bind(to: self.reactor.action)
                            .disposed(by: self.disposeBag)
                    }
                    
                    self.present(viewController, animated: true)
                case .memo(_):  break // TODO: 메모 셀 선택시
                default:            break
                }
            })
            .disposed(by: disposeBag)
        
        
        // state
        reactor.state.map { $0.bookView }
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self ] bookView in
                guard let self = self else { return }
                
                let viewController = self.routing.addReadingViewController(openViewType: .create, book: nil) { [weak self] book in
                    guard let self = self else { return }
                    
                    Observable.just(book)
                        .map { HomeViewReactor.Action.addBook($0) }
                        .bind(to: self.reactor.action)
                        .disposed(by: self.disposeBag)
                }
                
                self.present(viewController, animated: true)
            }).disposed(by: disposeBag)
        
        // TODO: memoView 구현
        
        // ui
        reactor.state.map { $0.sections }
            .asObservable()
            .bind(to: self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    // ActionSheet 설정 (카테고리 선택 후 item 추가)
    private func addItem() {
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
            let viewController = self.routing.addReadingViewController(openViewType: .create, book: nil) { [weak self] book in
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
    }
    
    // MARK: - MemoListCellDelegate
    func memoListCellDeleteTapped(of cell: MemoListCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        let memo = self.state.memos[indexPath.item]
        self.reactor.action.onNext(.deleteMemo(memo))
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    // TODO: 유동적인 높이 구현.
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource.sectionModels[indexPath.section].items[indexPath.item] {
        case let .title(title):
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = title.isEmpty ? 16 : 60 // header가 없을 경우 default Header Height 설정
            return CGSize(width: width, height: height)
        case .todo(_):
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 44)
        case .planType(_):
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 44)
        case .memo(_):
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 80)
        case .book(_):
            return CGSize(width: (UIScreen.main.bounds.width - 44.0) / 2, height: (UIScreen.main.bounds.width - 44.0) * 0.6 )
        }
    }
}
