//
//  ErrorView.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 03.02.2022.
//

import UIKit

final class ErrorView: UIView {
    
    public var descriptionOfError: String = "" {
        didSet {
            errorLabel.text = descriptionOfError
        }
    }
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let errorButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Обновить", for: .normal)
        button.setTitleColor(UIColor(named: Colors.buttonColor.rawValue), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: Colors.buttonColor.rawValue)?.cgColor
        return button
    }()
    private let errorStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 30
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(errorStackView)
        errorStackView.addArrangedSubview(errorLabel)
        errorStackView.addArrangedSubview(errorButton)
        
        errorStackView.centerY()
        errorStackView.centerX()
        errorStackView.trailing()
        errorStackView.leading()
        errorLabel.trailing()
        errorLabel.leading()
        errorButton.trailing()
        errorButton.leading()
        
    }
    func configureLayout() {
        centerX()
        centerY()
        trailing(-30)
        leading(30)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTargetToErrorButton(_ target: Any?, action: Selector, for event: UIControl.Event) {
        errorButton.addTarget(target, action: action, for: event)
    }
    
}
