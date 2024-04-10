//
//  PlanListCell.swift
//
//
//  Created by 박세라 on 4/3/24.
//
import UIKit
import ReactorKit
import TinyConstraints

class CategoryCell: UICollectionViewCell {
    // MARK: - view
    private var items = [String]()
    var segmentedControlButtons = [UIButton]()
    
    override func prepareForReuse() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSegmentedControlButtons(sender: UIButton) {
        
        for button in segmentedControlButtons {
            if button == sender {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromLeft) { [weak self] in
                    button.backgroundColor = .black
                }
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .transitionFlipFromLeft) { [weak self] in
                    button.backgroundColor = .systemGray5
                }
            }
        }
    }
    
    func initCellWithItems(items: [String]) {
        
        self.items = items
        self.segmentedControlButtons = self.items.map { UIButton().createSegmentedControlButton(setTitle: $0) }
        
        configureCustomsegmentedControl()
        
        // default checked : 카테고리 첫째 항목 선택으로 초기화
        handleSegmentedControlButtons(sender: segmentedControlButtons[0])
    }
    
    private func configureCustomsegmentedControl() {
        
        print("configureCustomsegmentedControl")
        segmentedControlButtons.forEach { $0.addTarget(self, action: #selector(handleSegmentedControlButtons(sender:)), for: .touchUpInside)}
        
        let stackView = UIStackView(arrangedSubviews: segmentedControlButtons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: .zero, height: 32)
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.addSubview(stackView)
        
        self.addSubview(scrollView)
        
        scrollView.topToSuperview()
        scrollView.leadingToSuperview()
        scrollView.trailingToSuperview()
        scrollView.height(32)
        
        stackView.topToSuperview()
        stackView.leadingToSuperview()
        stackView.trailingToSuperview()
        stackView.height(32)
    }
    
}

extension UIButton {
    func createSegmentedControlButton(setTitle to: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(to, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.backgroundColor = UIColor.init(white: 0.1, alpha: 0.1)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }
}
    
