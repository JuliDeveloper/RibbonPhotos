//
//  ProfileViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 01.12.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.config(
            for: label,
            text: "Екатерина Новикова",
            fontSize: 23,
            textColor: .ypWhite)
        return label
    }()
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.config(
            for: label,
            text: "@ekaterina_nov",
            fontSize: 13,
            textColor: .ypGray)
        return label
    }()
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.config(
            for: label,
            text: "Hello, world!",
            fontSize: 13,
            textColor: .ypWhite)
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
    private var profileImageServiceObserver: NSObjectProtocol?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileInfo(profileService.profile ?? Profile(
            username: "11",
            name: "22",
            loginName: "33",
            bio: "44"
        ))
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
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
    
    private func setupProfileInfo(_ profile: Profile) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.nameLabel.text = profile.name
            self.usernameLabel.text = profile.loginName
            self.statusLabel.text = profile.bio
        }
    }
    
    private func updateAvatar() {                                   // 8
           guard
               let profileImageURL = ProfileImageService.shared.avatarURL,
               let url = URL(string: profileImageURL)
           else { return }
           // TODO [Sprint 11] Обновить аватар, используя Kingfisher
       }

    @objc private func didTapButton() {
        
    }
}
