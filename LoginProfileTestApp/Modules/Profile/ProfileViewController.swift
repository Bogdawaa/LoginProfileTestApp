//
//  ProfileViewController.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 22.08.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Types
    private enum InfoType: String, CaseIterable {
        case firstName = "Имя"
        case lastName = "Фамилия"
        case position = "Должность"
        case email = "Почта"
        case serviceName = "Точка обслуживания"
        case login = "Логин"
    }
    
    // MARK: - Properties
    private var profile: Profile?
    private let viewModel: ProfileViewModel
    private let coordinator: Coordinator
    
    // MARK: - UI
    private lazy var profileCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .appGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var stackCardView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logoutButton: UIButton = {
        var attributedString = AttributedString("Выйти из профиля")
        attributedString.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        attributedString.foregroundColor = .appMainText
        
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = attributedString
        configuration.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        configuration.baseForegroundColor = .appMainText
        configuration.imagePadding = 12
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.backgroundColor = .appGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.contentHorizontalAlignment = .left
        
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var backgroundProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.alpha = 0
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var dataRows: [InfoType: ProfileRowView] = [:]
    
    // MARK: - Init
    init(viewModel: ProfileViewModel = ProfileViewModel(), coordinator: Coordinator) {
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
        createInfoRows()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func createInfoRows() {
        InfoType.allCases.forEach { type in
            let rowView = ProfileRowView(title: type.rawValue)
            rowView.translatesAutoresizingMaskIntoConstraints = false
            stackCardView.addArrangedSubview(rowView)
            dataRows[type] = rowView
        }
    }
    
    private func setupUI() {
        title = "Профиль"
        view.backgroundColor = .white
        
        profileCardView.addSubview(stackCardView)
        profileCardView.addSubview(activityIndicator)
        view.addSubview(profileCardView)
        view.addSubview(logoutButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            stackCardView.topAnchor.constraint(equalTo: profileCardView.topAnchor, constant: 20),
            stackCardView.leadingAnchor.constraint(equalTo: profileCardView.leadingAnchor),
            stackCardView.trailingAnchor.constraint(equalTo: profileCardView.trailingAnchor),
            stackCardView.bottomAnchor.constraint(equalTo: profileCardView.bottomAnchor, constant: -20),
            
            logoutButton.topAnchor.constraint(equalTo: profileCardView.bottomAnchor, constant: 16),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: profileCardView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: profileCardView.centerYAnchor),
        ])
    }
    
    private func setupBindings() {
        viewModel.onLogoutSuccess = { [weak self] in
            self?.coordinator.showLogin()
        }
        
        viewModel.onShowAlert = { [weak self] config in
            self?.showAlert(config)
        }
        
        viewModel.onProfileLoaded = { [weak self] profile in
            self?.profile = profile
            self?.update(with: profile)
        }
        
        viewModel.onReauthFailed = { [weak self] in
            self?.coordinator.showLogin()
        }
        
        viewModel.onLoadingStarted = { [weak self] isLoading in
            isLoading == true ? self?.showLoading() : self?.hideLoading()
        }
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
    
    private func showLoading() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    private func hideLoading() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    // MARK: - Public Methods
    func update(with profile: Profile) {
        dataRows[.firstName]?.updateValue(profile.firstName)
        dataRows[.lastName]?.updateValue(profile.lastName)
        dataRows[.position]?.updateValue(profile.groupName)
        dataRows[.email]?.updateValue(profile.email)
        dataRows[.serviceName]?.updateValue(profile.serviceName)
        dataRows[.login]?.updateValue(profile.login)
    }
    
    // MARK: - Actions
    @objc private func didTapLogoutButton() {
        Task {
            await viewModel.logout()
        }
    }
}
