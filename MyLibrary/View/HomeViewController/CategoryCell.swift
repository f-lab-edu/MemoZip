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
    // MARK: - Properties
    private var items = [String]()      // 카테고리 배열
    var selectedIndex: Int?             // 선택된 카테고리
    var selectedHandler: ((Int) -> ())? // 선택된 카테고리 Handler
    
    // MARK: - view
    var segmentedControlButtons = [UIButton]()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        segmentedControlButtons.forEach { $0.removeFromSuperview() }
                segmentedControlButtons.removeAll()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCellWithItems(items: [String]) {
        
        self.items = items
        self.segmentedControlButtons = self.items.enumerated().map { index, item in
            let button = UIButton().createSegmentedControlButton(setTitle: item)
            button.tag = index
            return button
        }
        
        configureCustomsegmentedControl()
        
        let originalHandler = selectedHandler
        selectedHandler = nil
        
        // default checked: 선택 카테고리 항목 선택으로 초기화 (default: 0)
        handleSegmentedControlButtons(sender: segmentedControlButtons[selectedIndex ?? 0])
        
        selectedHandler = originalHandler
    }
    
    // segmentedControl 버튼이 눌렸을 때
    @objc func handleSegmentedControlButtons(sender: UIButton) {
        
        let newIndex = sender.tag
        
        guard selectedIndex != newIndex else {
            return // 같은 인덱스를 다시 선택하지 않음
        }
        
        selectedIndex = newIndex
        
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
        
        
        // 선택된 카테고리 전송
        selectedHandler?(newIndex) // 새로운 인덱스만 전달
    }
    
    // cell 안의 segmentedControl setting
    private func configureCustomsegmentedControl() {
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
        button.backgroundColor = .systemGray5
        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.backgroundColor = UIColor.init(white: 0.1, alpha: 0.1)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }
}
    
