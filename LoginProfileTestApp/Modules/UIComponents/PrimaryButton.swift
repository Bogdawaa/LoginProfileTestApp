//
//  MainButton.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 22.08.2025.
//

import UIKit

final class PrimaryButton: UIButton {
    
    // MARK: - Properties
    var buttonColor: UIColor = .systemPink {
        didSet {
            updateAppearance()
        }
    }
    
    var textColor: UIColor = .white {
        didSet {
            updateAppearance()
        }
    }
    
    var cornerRadius: CGFloat = 16 {
        didSet {
            layer.cornerRadius = cornerRadius
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
        backgroundColor = buttonColor
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        layer.cornerRadius = cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateAppearance() {
        backgroundColor = buttonColor
        setTitleColor(textColor, for: .normal)
    }
    
    // MARK: - Configuration
    func configure(title: String,
                 buttonColor: UIColor? = nil,
                 textColor: UIColor? = nil,
                 cornerRadius: CGFloat? = nil) {
        setTitle(title, for: .normal)
        
        if let buttonColor = buttonColor {
            self.buttonColor = buttonColor
        }
        
        if let textColor = textColor {
            self.textColor = textColor
        }
        
        if let cornerRadius = cornerRadius {
            self.cornerRadius = cornerRadius
        }
        
        updateAppearance()
    }
}
