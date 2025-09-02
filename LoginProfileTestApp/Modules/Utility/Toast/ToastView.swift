//
//  ToastView.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 28.08.2025.
//

import UIKit

final class ToastView: UIView {
    
    // MARK: - Properties
    private var hideTimer: Timer?
    private let toastHeight: CGFloat = 100
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 16
    private let toastBackgroundColor: UIColor = .systemPink
    
    // MARK: - UI
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    func setupView() {
        backgroundColor = toastBackgroundColor.withAlphaComponent(0.8)
        layer.cornerRadius = 12
        layer.masksToBounds = true
        addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding)
        ])
    }
    
    // MARK: - Public Methods
    func showToast(message: String, withDuration duration: TimeInterval = 2, in view: UIView) {
        messageLabel.text = message
        
        let safeAreaInsets = view.safeAreaInsets
        let width = view.bounds.width - (horizontalPadding * 2)
        
        frame = CGRect(
            x: horizontalPadding,
            y: view.bounds.height,
            width: width,
            height: toastHeight
        )
        
        view.addSubview(self)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut
        ) {
            self.alpha = 1
            self.frame.origin.y = view.bounds.height - self.toastHeight - safeAreaInsets.bottom - 20
        }
        
        hideTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            self?.hide()
        }
    }
    
    func hide() {
        hideTimer?.invalidate()
        hideTimer = nil
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    
    // MARK: - Gestures
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hide()
    }
    
    // MARK: - Deinit
    deinit {
        hideTimer?.invalidate()
    }
}
