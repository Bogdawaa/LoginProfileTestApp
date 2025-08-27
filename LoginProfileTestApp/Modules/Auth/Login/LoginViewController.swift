//
//  ViewController.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 21.08.2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel
    private let coordinator: Coordinator
    
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
    
    
    // MARK: - Init
    init(viewModel: LoginViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupGestureRecognizer()
        setupBindings()
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
        setupButton()
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
    
    private func setupButton() {
        loginButton.isEnabled = false
        loginButton.addTarget(self, action: #selector(didLoginTap), for: .touchUpInside)
    }
    
    private func updateButtonState() {
        loginButton.isEnabled = viewModel.isValidInput
    }
    
    private func setupBindings() {
        viewModel.didUpdateInput = { [weak self] in
            self?.updateButtonState()
        }
        
        viewModel.onLoginSuccess = { [weak self] in
            self?.navigateToProfileScreen()
        }
        
        viewModel.onShowAlert = { [weak self] config in
            self?.showAlert(config)
        }
    }

    private func setupTextFields() {
        loginTextField.configure(placeholder: "Логин")
        loginTextField.keyboardType = .emailAddress
        loginTextField.autocapitalizationType = .none
        loginTextField.returnKeyType = .next
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.addTarget(self, action: #selector(loginTextChanged), for: .editingChanged)
        loginTextField.delegate = self
        
        passwordTextField.configure(placeholder: "Пароль")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.returnKeyType = .done
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        passwordTextField.delegate = self
    }
    
    private func showAlert(_ config: AlertConfig) {
        let alert = UIAlertController(
            title: config.title,
            message: config.message,
            preferredStyle: config.style
        )
        
        for config in config.actions {
            let action = UIAlertAction(
                title: config.title,
                style: config.style,
                handler: { _ in
                    config.handler?()
                }
            )
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
    
    private func navigateToProfileScreen() {
        coordinator.showProfile()
    }
    
    // MARK: - actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didLoginTap() {
        Task {
            await viewModel.loginUser()
        }
    }
    
    @objc private func loginTextChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.updateLogin(text)
    }

    @objc private func passwordTextChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.updatePassword(text)
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
