import Model
import TinyConstraints
import UIKit

final class PlanTypesCell: UICollectionViewCell {
    
    private let planTypes: [PlanType] = PlanType.allCases
    private let selectedPlanType: PlanType = .memo
    var selectionHandler: ((PlanType) -> ())?
    
    private var planTypeButtons: [PlanTypeButton]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(scrollView)
        scrollView.topToSuperview()
        scrollView.horizontalToSuperview()
        scrollView.height(32)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        scrollView.addSubview(stackView)
        stackView.topToSuperview()
        stackView.horizontalToSuperview()
        stackView.height(32)
        
        let planTypeButtons = self.planTypes.map {
            let button = PlanTypeButton(planType: $0)
            button.addTarget(self, action: #selector(onPlanTypeTapped(_:)), for: .touchUpInside)
            return button
        }
        planTypeButtons.forEach {
            stackView.addArrangedSubview($0)
        }
        self.planTypeButtons = planTypeButtons
    }
    
    @objc private func onPlanTypeTapped(_ sender: PlanTypeButton) {
        let planType = sender.planType
        self.selectionHandler?(planType)
    }
    
    func configure(selectedPlanType: PlanType) {
        self.planTypeButtons.forEach {
            $0.updateSelection(selectedPlanType: selectedPlanType)
        }
    }
    
}

private final class PlanTypeButton: UIButton {
    
    let planType: PlanType
    private var planTypeName: String {
        switch self.planType {
        case .memo: "메모"
        case .book: "독서"
        }
    }
    
    init(planType: PlanType) {
        self.planType = planType
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(self.planTypeName, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.widthAnchor.constraint(equalToConstant: 90).isActive = true
        self.heightAnchor.constraint(equalToConstant: 32).isActive = true
        self.backgroundColor = UIColor.init(white: 0.1, alpha: 0.1)
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSelection(selectedPlanType: PlanType) {
        self.backgroundColor = self.planType == selectedPlanType ? .black : .systemGray5
    }
}
