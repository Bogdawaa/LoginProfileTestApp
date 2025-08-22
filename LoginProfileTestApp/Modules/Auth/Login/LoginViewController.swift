//
//  ViewController.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 21.08.2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Войдите в профиль"
        return label
    }()
    
    private lazy var loginTextField = FloatingPlaceholderTextField()
    private lazy var passwordTextField = FloatingPlaceholderTextField()
    private lazy var loginButton: PrimaryButton = PrimaryButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupGestureRecognizer()
    }
    
    // MARK: Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        loginButton.configure(title: "Далее")
        [
            titleLabel,
            loginTextField,
            passwordTextField,
            loginButton
        ].forEach {
            view.addSubview($0)
        }
        setupTextFields()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),

            
            passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            
            loginButton.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Public Methods
    func setupTextFields() {
        loginTextField.configure(placeholder: "Логин")
        loginTextField.keyboardType = .emailAddress
        loginTextField.autocapitalizationType = .none
        loginTextField.returnKeyType = .next
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.delegate = self
        
        passwordTextField.configure(placeholder: "Пароль")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.returnKeyType = .done
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.delegate = self

    }
    
    // MARK: - actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            dismissKeyboard()
        }
        return true
    }
}
