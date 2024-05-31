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

// Cell들로부터 입력받은 값을 받는 delegate
public protocol SendDelegate { // FIXME: 이름... 수정하기
    func getValue(type: ReadingSectionItem, data: [String: Any])
}

public class AddReadingViewController: UICollectionViewController {
    // MARK: UI
    lazy var xButton: UIButton = {
        let button = UIButton()
        let xMarkImage = UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(xMarkImage, for: .normal)
        button.addTarget(self, action: #selector(tappedXButton), for: .touchUpInside)
        return button
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .systemGray3
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(tappedOKButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Properties
    private let reactor: Reactor
    private var disposeBag: DisposeBag = .init()
    public var book: Book
    public var dataHandler: ((Book)-> ())?
    
    typealias Reactor = ReadingViewReactor
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<ReadingSection>
    lazy var dataSource = DataSource(configureCell: { dataSource, collectionView, indexPath, item in
        
        switch item {
        case .titleCell:
            let cell = collectionView.dequeueReusableCell(BookTitleCell.self, for: indexPath)
            cell.delegate = self
            return cell
        case .dateCell:
            let cell = collectionView.dequeueReusableCell(BookDateCell.self, for: indexPath)
            cell.delegate = self
            return cell
        case .pageCell:
            let cell = collectionView.dequeueReusableCell(BookPageCell.self, for: indexPath)
            cell.showAlertAction = { [weak self] in
                guard let self = self else { return }
                self.sendPage(dataHandler: { result in
                    guard let startPageStr = result["startPage"] as? String,
                          let endPageStr = result["endPage"] as? String,
                          let startPage = Int(startPageStr),
                          let endPage = Int(endPageStr)
                    else {
                        return
                    }
                    cell.updatePage(startPage: startPage, endPage: endPage)
                })
            }
            return cell
        case .colorCell:
            let cell = collectionView.dequeueReusableCell(BookColorCell.self, for: indexPath)
            cell.delegate = self
            return cell
        case .progressTypeCell:
            let cell = collectionView.dequeueReusableCell(BookProgressTypeCell.self, for: indexPath)
            cell.delegate = self
            return cell
        }
    })
    
    public init(reactor: ReadingViewReactor) {
        self.reactor = reactor
        self.book = Book()
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
        
        
        [xButton, okButton].forEach {
            self.view.addSubview($0)
        }
        
        // 닫기버튼 설정
        xButton.topToSuperview(offset: 16)
        xButton.trailingToSuperview(offset: 16)
        xButton.height(24)
        xButton.width(24)
        
        // 확인버튼 설정
        okButton.bottomToSuperview(offset: -16, usingSafeArea: true)
        okButton.centerXToSuperview()
        okButton.height(48)
        okButton.width(UIScreen.main.bounds.width - 32.0)
    }
    
    private func initCollectionView() {
        self.collectionView.register(BookTitleCell.self)
        self.collectionView.register(BookDateCell.self)
        self.collectionView.register(BookPageCell.self)
        self.collectionView.register(BookColorCell.self)
        self.collectionView.register(BookProgressTypeCell.self)
        
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionView.contentInset = UIEdgeInsets(top: 28, left: 16, bottom: 0, right: 16)
    }
    
    public func bindReactor() {
        
        // ui
        reactor.state.map { $0.sections }
            .asObservable()
            .bind(to: self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    @objc func tappedXButton() {
        self.dismiss(animated: true)
    }
    
    @objc func tappedOKButton() {
        dataHandler?(book)
        self.dismiss(animated: true)
    }
    
    private func sendPage(dataHandler: @escaping ([String: Any]) -> ()) {
        let alertController = UIAlertController(title: "페이지 입력", message: "읽은 페이지를 입력해주세요", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "읽은 페이지"
            textField.keyboardType = .numberPad
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "총 페이지 수"
            textField.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "저장", style: .default) { _ in
            guard let startPage = alertController.textFields?[0].text,
                  let endPage = alertController.textFields?[1].text else {
                return
            }
            dataHandler(["startPage": startPage, "endPage": endPage])
            
            self.book.startPage = Int(startPage)
            self.book.endPage = Int(endPage)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension AddReadingViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch dataSource.sectionModels[indexPath.section].items[indexPath.item] {
        case .titleCell:
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 80)
        case .dateCell, .progressTypeCell:
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 72)
        case .pageCell:
            return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 80)
        case .colorCell:
            return CGSize(width: UIScreen.main.bounds.width, height: 72)
        }
    }
}

extension AddReadingViewController: SendDelegate {
    public func getValue(type: ViewModel.ReadingSectionItem, data: [String : Any]) {
        switch type {
        case .titleCell:
            guard let bookTitle = data["bookTitle"],
                  let title = bookTitle as? String else { return }
            book.title = title
        case .dateCell:
            if let startDate = data["startDate"] as? String {
                book.startAt = startDate
            }
            if let endDate = data["endDate"] as? String {
                book.endAt = endDate
            }
        case .pageCell:
            guard let startPage = data["startPage"] as? String,
                  let endPage = data["endPage"] as? String,
                  let bookStartPage = Int(startPage),
                  let bookEndPage = Int(endPage) else { return }
            book.startPage = bookStartPage
            book.endPage = bookEndPage
        case .colorCell:
            guard let colorCode = data["colorCd"],
                  let bookColorCode = colorCode as? String else { return }
            book.colorCode = bookColorCode
        case .progressTypeCell:
            guard let type = data["progressType"],
                  let progressType = type as? Int else {
                return
            }
            book.isDisplayDday = progressType == ProgressType.d_day.rawValue
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
            return "#76DCB0"
        case .orange:
            return "#FFDAB9"
        }
    }
}
