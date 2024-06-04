//
//  BookListCell.swift
//
//
//  Created by 박세라 on 4/3/24.
//
import UIKit
import ReactorKit
import ViewModel
import Common

class BookListCell: UICollectionViewCell, View {
    
    typealias Reactor = BookListCellReactor
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - view
    let titleLabel = UILabel()
    // ...
    
    let progressLabel = UILabel()
    
    let progressView = UIView()
    let progressBaseView = UIView()
    
    override func prepareForReuse() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, progressLabel, progressView, progressBaseView].forEach {
            self.addSubview($0)
        }
    
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        titleLabel.leadingToSuperview(offset: 8)
        titleLabel.trailingToSuperview(offset: 8)
        titleLabel.top(to: self, offset: 32)
        titleLabel.centerXToSuperview()
        
        
        progressLabel.textAlignment = .center
        progressLabel.text = "D-25"
        progressLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        progressLabel.centerXToSuperview()
        progressLabel.centerYToSuperview()

        progressBaseView.bottomToSuperview(offset: -32)
        progressBaseView.leadingToSuperview(offset: 8)
        progressBaseView.trailingToSuperview(offset: 8)
        progressBaseView.height(8)
        progressBaseView.layer.cornerRadius = 4
        progressBaseView.backgroundColor = .white
        progressBaseView.layer.opacity = 0.2
        
        progressView.bottomToSuperview(offset: -32)
        progressView.leadingToSuperview(offset: 8)
        progressView.height(8)
        progressView.layer.cornerRadius = 4
        progressView.backgroundColor = .white
        
        self.bringSubviewToFront(progressView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: BookListCellReactor) {
        self.backgroundColor = UIColor(hex: reactor.currentState.colorCode, alpha: 1.0)
        
        // 부분 cornerRadius 적용
        self.roundCorners(cornerRadius: 12, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner])
        self.titleLabel.text = reactor.currentState.title
        self.titleLabel.textColor = reactor.currentState.colorCode == BookColorType.yellow.colorCode ? .black : .white
        self.progressLabel.textColor = reactor.currentState.colorCode == BookColorType.yellow.colorCode ? .black : .white
        self.progressBaseView.backgroundColor = reactor.currentState.colorCode == BookColorType.yellow.colorCode ? .black : .white
        self.progressView.backgroundColor = reactor.currentState.colorCode == BookColorType.yellow.colorCode ? .black : .white
        
        // 달성률 표기 방식
        if reactor.currentState.isDisplayDday {
            // d-day 형식으로 표기
            if let startAt = reactor.currentState.startAt,
               let endAt = reactor.currentState.endAt {
                if let dDay = endAt.calculateDDay(format: "yyyy.MM.dd") {
                    self.progressLabel.text = dDay == -1 ? "독서완료" : "D-\(dDay)"
                    
                    if dDay != -1 {
                        if let totalDay = startAt.daysBetween(endAt, dateFormat: "yyyy.MM.dd") {
                            let ratio = CGFloat(totalDay - dDay) / CGFloat(totalDay)
                            progressView.widthAnchor.constraint(equalTo: progressBaseView.widthAnchor, multiplier: CGFloat(ratio)).isActive = true
                        }
                    } else {
                        progressView.widthAnchor.constraint(equalTo: progressBaseView.widthAnchor, multiplier: 1.0).isActive = true
                    }
                }
            }
        } else {
            // 페이지 표기 방식
            if let startPage = reactor.currentState.startPage,
               let endPage = reactor.currentState.endPage {
                progressLabel.text = startPage == endPage ? "독서완료" : "\(startPage)p 읽는 중"
                
                if endPage != 0 {
                    let ratio = CGFloat(startPage) / CGFloat(endPage)
                    progressView.widthAnchor.constraint(equalTo: progressBaseView.widthAnchor, multiplier: CGFloat(ratio)).isActive = true
                }
            }
        }
    }
}
    
