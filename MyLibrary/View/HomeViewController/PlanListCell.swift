//
//  PlanListCell.swift
//
//
//  Created by 박세라 on 4/3/24.
//
import UIKit
import ReactorKit
import ViewModel

class PlanListCell: UICollectionViewCell, View {
    
    typealias Reactor = PlanListCellReactor
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - view
    let titleLabel = UILabel()
    // ...
    
    let d_dayLabel = UILabel()
    
    let progressView = UIView()
    let progressBaseView = UIView()
    
    override func prepareForReuse() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, d_dayLabel, progressView, progressBaseView].forEach {
            self.addSubview($0)
        }
        
        self.backgroundColor = UIColor.randomColor()
    
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        titleLabel.leadingToSuperview(offset: 8)
        titleLabel.trailingToSuperview(offset: 8)
        titleLabel.top(to: self, offset: 32)
        titleLabel.centerXToSuperview()
        
        
        d_dayLabel.textAlignment = .center
        d_dayLabel.text = "D-25"
        d_dayLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        d_dayLabel.centerXToSuperview()
        d_dayLabel.centerYToSuperview()

        progressBaseView.bottomToSuperview(offset: -32)
        progressBaseView.leadingToSuperview(offset: 8)
        progressBaseView.trailingToSuperview(offset: 8)
        progressBaseView.height(8)
        progressBaseView.layer.cornerRadius = 4
        progressBaseView.backgroundColor = .white
        progressBaseView.layer.opacity = 0.2
        
        progressView.bottomToSuperview(offset: -32)
        progressView.leadingToSuperview(offset: 8)
        progressView.trailingToSuperview(offset: 100)
        progressView.height(8)
        progressView.layer.cornerRadius = 4
        progressView.backgroundColor = .white
        
        self.bringSubviewToFront(progressView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: PlanListCellReactor) {
        // 부분 cornerRadius 적용
        self.roundCorners(cornerRadius: 12, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner])
        self.titleLabel.text = reactor.currentState.title
    }
}
    
