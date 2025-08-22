//
//  FloatingPlaceholderTextField.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 22.08.2025.
//

import UIKit

final class FloatingPlaceholderTextField: UITextField {
    
    // MARK: - Priperties
    var placeholderColor: UIColor = .systemGray
    var placeholderFont: UIFont = .systemFont(ofSize: 16)
    var floatingPlaceholderFont: UIFont = .systemFont(ofSize: 12)
    var cornerRadius: CGFloat = 16.0
    
    // Constraints
    private var placeholderCenterYConstraint: NSLayoutConstraint?
    private var placeholderLeadingConstraint: NSLayoutConstraint?
    
    private lazy var floatingPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.font = placeholderFont
        label.textColor = placeholderColor
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var isFloating: Bool = false {
        didSet { animatePlaceholder() }
    }
    
    override var placeholder: String? {
        didSet {
            floatingPlaceholderLabel.text = placeholder
        }
    }
    
    override var text: String? {
        didSet {
            updatePlaceHolderState()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePlaceHolderState()
    }
    
    
    // MARK: - Private Methods
    private func animatePlaceholder() {
        let shouldFloat = isFloating || isFirstResponder
        
        UIView.animate(withDuration: 0.2) {
            if shouldFloat {
                self.floatingPlaceholderLabel.font = self.floatingPlaceholderFont
                self.placeholderCenterYConstraint?.constant = -12
            } else {
                self.floatingPlaceholderLabel.font = self.placeholderFont
                self.placeholderCenterYConstraint?.constant = 0
            }
            self.layoutIfNeeded()
        }
    }
    
    private func setupTextField() {
        borderStyle = .none
        font = placeholderFont
        tintColor = .systemGray
        backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        super.placeholder = nil
        
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        addSubview(floatingPlaceholderLabel)
        
        placeholderCenterYConstraint = floatingPlaceholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        placeholderLeadingConstraint = floatingPlaceholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        
        NSLayoutConstraint.activate([
            placeholderCenterYConstraint!,
            placeholderLeadingConstraint!,
            floatingPlaceholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12)
        ])
    }
    
    private func updatePlaceHolderState() {
        let hasText = !(text?.isEmpty ?? true)
        isFloating = hasText || isFirstResponder
    }
    
    // MARK: - Public Methods
    func configure(
        placeholder: String,
        placeholderColor: UIColor = .systemGray) {
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
        floatingPlaceholderLabel.text = placeholder
    }
    
    // MARK: - Override
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.y += 8
        rect.origin.x += 12
        rect.size.width -= 12
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        rect.origin.y += 8
        rect.origin.x += 12
        rect.size.width -= 12
        return rect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange() {
        updatePlaceHolderState()
    }
    
    @objc private func textFieldDidBeginEditing() {
        updatePlaceHolderState()
    }
    
    @objc private func textFieldDidEndEditing() {
        updatePlaceHolderState()
    }
}
