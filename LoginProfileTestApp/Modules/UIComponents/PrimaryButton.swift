//
//  MainButton.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 22.08.2025.
//

import UIKit

final class PrimaryButton: UIButton {
    
    // MARK: - Properties
    private var animationDuration: TimeInterval = 0.3
    
    var buttonColor: UIColor = .systemPink {
        didSet {
            updateAppearance()
        }
    }
    
    var disabledButtonColor: UIColor = .gray {
        didSet {
            updateAppearance()
        }
    }
    
    var textColor: UIColor = .white {
        didSet {
            updateAppearance()
        }
    }
    
    var disabledTextColor: UIColor = .darkGray {
        didSet {
            updateAppearance()
        }
    }
    
    var cornerRadius: CGFloat = 16 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Setup
    private func setupButton() {
        backgroundColor = isEnabled ? buttonColor : disabledButtonColor
        setTitleColor(textColor, for: .normal)
        setTitleColor(disabledButtonColor, for: .disabled)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        layer.cornerRadius = cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateAppearance() {
        backgroundColor = isEnabled ? buttonColor : disabledButtonColor
        setTitleColor(textColor, for: .normal)
        setTitleColor(disabledTextColor, for: .disabled)
    }
    
    // MARK: - Configuration
    func configure(title: String,
                   buttonColor: UIColor? = nil,
                   disabledButtonColor: UIColor? = nil,
                   textColor: UIColor? = nil,
                   disabledTextColor: UIColor? = nil,
                   cornerRadius: CGFloat? = nil) {
        setTitle(title, for: .normal)
        
        if let buttonColor = buttonColor {
            self.buttonColor = buttonColor
        }
        
        if let disabledButtonColor = disabledButtonColor {
            self.disabledButtonColor = disabledButtonColor
        }
        
        if let textColor = textColor {
            self.textColor = textColor
        }
        
        if let disabledTextColor = disabledTextColor {
            self.disabledTextColor = disabledTextColor
        }

        if let cornerRadius = cornerRadius {
            self.cornerRadius = cornerRadius
        }
        
        updateAppearance()
    }
}
