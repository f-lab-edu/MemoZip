//
//  BookDateCell.swift
//
//
//  Created by 박세라 on 5/28/24.
//
//  독서계획 기간 설정 Cell

import UIKit
import TinyConstraints

final class BookDateCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "독서기간"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
    }()
    
    let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()
    
    let startDateView = UIView()
    let startDatePicker = UIPickerView()

    let endDateView = UIView()
    let endDatePicker = UIPickerView()
    
    let tilde: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "~"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        return titleLabel
    }()
    
    private let datePicker = UIDatePicker()
    private var activeDateView: UIView?
    
    public override func prepareForReuse() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGestureRecognizers()
        setupDatePicker()
    }
    
    private func setupViews() {
        [titleLabel, dateStackView, startDateView, endDateView, tilde].forEach {
            self.contentView.addSubview($0)
        }
        
        startDateView.backgroundColor = .systemGray5
        startDateView.layer.cornerRadius = 8
        endDateView.backgroundColor = .systemGray5
        endDateView.layer.cornerRadius = 8
        
        dateStackView.addArrangedSubview(startDateView)
        dateStackView.addArrangedSubview(endDateView)
        
        dateStackView.leadingToSuperview()
        dateStackView.trailingToSuperview()
        dateStackView.bottomToSuperview()
        dateStackView.height(44)
        
        titleLabel.leadingToSuperview()
        titleLabel.trailingToSuperview()
        titleLabel.topToSuperview()
        
        tilde.centerXToSuperview()
        tilde.centerY(to: dateStackView)
    }
    
    private func setupGestureRecognizers() {
        let startTapGesture = UITapGestureRecognizer(target: self, action: #selector(startDateViewTapped))
        startDateView.addGestureRecognizer(startTapGesture)
        
        let endTapGesture = UITapGestureRecognizer(target: self, action: #selector(endDateViewTapped))
        endDateView.addGestureRecognizer(endTapGesture)
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc private func startDateViewTapped() {
        activeDateView = startDateView
        showDatePicker()
    }
    
    @objc private func endDateViewTapped() {
        activeDateView = endDateView
        showDatePicker()
    }
    
    private func showDatePicker() {
        if datePicker.superview == nil {
            contentView.addSubview(datePicker)
            datePicker.leadingToSuperview()
            datePicker.trailingToSuperview()
            datePicker.bottomToSuperview()
        }
        datePicker.isHidden = false
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        guard let activeView = activeDateView else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let dateLabel = UILabel()
        dateLabel.text = dateFormatter.string(from: sender.date)
        dateLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        
        activeView.subviews.forEach { $0.removeFromSuperview() }
        activeView.addSubview(dateLabel)
        dateLabel.centerXToSuperview()
        dateLabel.centerYToSuperview()
        
        datePicker.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        
    }
}
