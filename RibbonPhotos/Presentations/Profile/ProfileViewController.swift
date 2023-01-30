//
//  ProfileViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 01.12.2022.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.config(
            for: label,
            text: "",
            fontSize: 23,
            textColor: .ypWhite)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.config(
            for: label,
            text: "",
            fontSize: 13,
            textColor: .ypGray)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.config(
            for: label,
            text: "Hello, world!",
            fontSize: 13,
            textColor: .ypWhite)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ipad.and.arrow.forward"), for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()

    private var profileImageServiceObserver: NSObjectProtocol?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showGradientAnimation()
        setupProfileInfo(profileService.profile ?? Profile(
            username: "",
            name: "",
            loginName: "",
            bio: ""
        ))
        view.backgroundColor = .ypBlack
        addSubviews()
        setupConstraints()
        profileImageServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: ProfileImageService.didChangeNotification,
                        object: nil,
                        queue: .main
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateAvatar()
                    }
        updateAvatar()
    }
    
    //MARK: - Helpers
    private func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(statusLabel)
        view.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func showGradientAnimation() {
        let imageGradient = CAGradientLayer().createLoadingGradient(70, 70, 35)
        let nameLabelGradient = CAGradientLayer().createLoadingGradient(223, 18, 9)
        let usernameLabelGradient = CAGradientLayer().createLoadingGradient(69, 18, 9)
        let statusLabelGradient = CAGradientLayer().createLoadingGradient(67, 18, 9)

        profileImageView.layer.addSublayer(imageGradient)
        nameLabel.layer.addSublayer(nameLabelGradient)
        usernameLabel.layer.addSublayer(usernameLabelGradient)
        statusLabel.layer.addSublayer(statusLabelGradient)
    }
    
    private func removeGradientAnimation(_ views: [UIView]) {
        for view in views {
            view.layer.sublayers?.removeAll()
        }
    }
    
    private func setupProfileInfo(_ profile: Profile) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.removeGradientAnimation([self.nameLabel, self.usernameLabel, self.statusLabel])
            self.nameLabel.text = profile.name
            self.usernameLabel.text = profile.loginName
            self.statusLabel.text = profile.bio
        }
    }
    
    private func updateAvatar() {
        if let profileImageURL = profileImageService.avatarURL,
           let url = URL(string: profileImageURL) {

            let cache = ImageCache.default
            cache.clearMemoryCache()
            cache.clearDiskCache()
            
            let processor = RoundCornerImageProcessor(cornerRadius: (35))
            self.profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "person.crop.circle.fill"),
                options: [.processor(processor)]
            ) { [weak self] result in
                guard let self = self else { return }
                self.removeGradientAnimation([self.profileImageView])
            }
        } else {
            profileImageView.image = UIImage(named: "person.crop.circle.fill")
            self.removeGradientAnimation([self.profileImageView])
        }
    }
    
    private func logoutFromProfile() {
        oAuth2TokenStorage.bearerToken = nil
        WebViewViewController.clean()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(
            withIdentifier: "AuthViewController"
        ) as? AuthViewController else { return }
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }

    @objc private func didTapButton() {
        showDoubleAlert(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            firstAction: "Да",
            secondAction: "Нет"
        ) { [weak self] _ in
            guard let self = self else { return }
            self.logoutFromProfile()
        } _: { _ in }
    }
}
