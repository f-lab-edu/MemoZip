//
// AddMemoViewController.swift
//
//
// Created by 박세라 on 4/24/24.
//

import Foundation
import UIKit
import TinyConstraints


public class AddMemoViewController: UIViewController {
    
    // MARK: - Properties
    public var messageHandler: ((String)-> ())?
    
    // MARK: UI Components
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .black
        stackView.layer.cornerRadius = 20
        stackView.spacing = 8
        return stackView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "메모 입력"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.backgroundColor = .black
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        return textView
    }()
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.opacity = 0.8
        return view
    }()
    
    var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 8
        stackView.spacing = 8
        return stackView
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 설정
        
        initView()
        
        setAction()
    }
    
    private func initView() {
        
        self.view.addSubview(backgroundView)
        self.view.addSubview(stackView)
        
        backgroundView.edgesToSuperview()
        
        stackView.centerInSuperview()
        stackView.leadingToSuperview(offset: 8)
        stackView.trailingToSuperview(offset: 8)
        
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(divider)
        buttonStack.addArrangedSubview(okButton)
        
        
        okButton.width(to: buttonStack, multiplier: 0.5)
        cancelButton.width(to: okButton)
        divider.width(1)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(buttonStack)
        
        
        titleLabel.height(24)
        
        textView.height(200)
        
    }
    
    private func setAction() {
        textView.delegate = self
        
        // 터치 제스처를 뷰에 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // 버튼에 액션 추가
        okButton.addTarget(self, action: #selector(submitValue), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    // 터치 이벤트 핸들러
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func submitValue() {
        guard let memo = textView.text else { return }
        messageHandler?(memo)
        self.dismiss(animated: true)
    }
    
    // 화면 종료 함수
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}

extension AddMemoViewController: UITextViewDelegate {
    public func textViewDidEndEditing(_ textView: UITextView) {
        view.endEditing(true)
    }
}
