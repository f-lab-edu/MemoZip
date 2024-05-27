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
    // MARK: UI
    lazy var xButton: UIButton = {
        let button = UIButton()
        let xMarkImage = UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(xMarkImage, for: .normal)
        button.addTarget(self, action: #selector(tappedXButton), for: .touchUpInside)
        return button
    }()
    
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
        case .colorCell:
            let cell = collectionView.dequeueReusableCell(BookColorCell.self, for: indexPath)
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
        initView()
        
        reactor.action.onNext(.initiate)
        
        bindReactor()
    }
    
    private func initView() {
        initCollectionView()
        
        // 닫기버튼 설정
        view.addSubview(xButton)
        xButton.topToSuperview(offset: 16)
        xButton.trailingToSuperview(offset: 16)
        xButton.height(24)
        xButton.width(24)
    }
    
    private func initCollectionView() {
        self.collectionView.register(BookTitleCell.self)
        self.collectionView.register(BookColorCell.self)
        
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionView.contentInset = UIEdgeInsets(top: 28, left: 16, bottom: 0, right: 16)
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
    
    @objc func tappedXButton() {
        self.dismiss(animated: true)
    }
}

extension AddReadingViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch dataSource.sectionModels[indexPath.section].items[indexPath.item] {
        case .titleCell(_):
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 80)
        case .colorCell:
            return CGSize(width: UIScreen.main.bounds.width, height: 72)
        }
    }
}

public enum BookColorType: CaseIterable {
    case blue
    case green
    case pink
    case purple
    case yellow
    case mint
    case orange
    
    var colorCode: String {
        switch self {
        case .blue:
            return "#AEC6CF"
        case .green:
            return "#B2E1B7"
        case .pink:
            return "#FFB6C1"
        case .purple:
            return "#C9A9E2"
        case .yellow:
            return "#FDFD96"
        case .mint:
            return "#98FF98"
        case .orange:
            return "#FFDAB9"
        }
    }
}
