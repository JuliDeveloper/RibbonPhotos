//
//  ProfileViewController.swift
//  RibbonPhotos
//
//  Created by Julia Romanenko on 01.12.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Properties
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var usernameLabel: UILabel?
    private var statusLabel: UILabel?
    private var logoutButton: UIButton?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configProfileImageView()
        configNameLabel()
        configUsernameLabel()
        configStatusLabel()
        configLogoutButton()
    }
    
    //MARK: - Helpers
    private func configProfileImageView() {
        let profileImageView = UIImageView()
        self.profileImageView = profileImageView
        
        profileImageView.image = UIImage(named: "photo")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func configNameLabel() {
        let nameLabel = UILabel()
        self.nameLabel = nameLabel
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont(name: "YS Display", size: 23)
        nameLabel.textColor = .ypWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView?.bottomAnchor ?? NSLayoutAnchor(), constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView?.leadingAnchor ?? NSLayoutAnchor())
        ])
    }
    
    private func configUsernameLabel() {
        let usernameLabel = UILabel()
        self.usernameLabel = usernameLabel
        
        usernameLabel.text = "@ekaterina_nov"
        usernameLabel.font = UIFont(name: "YS Display", size: 13)
        usernameLabel.textColor = .ypGray
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: nameLabel?.bottomAnchor ?? NSLayoutAnchor(), constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView?.leadingAnchor ?? NSLayoutAnchor())
        ])
    }
    
    private func configStatusLabel() {
        let statusLabel = UILabel()
        self.statusLabel = statusLabel
        
        statusLabel.text = "Hello, world!"
        statusLabel.font = UIFont(name: "YS Display", size: 13)
        statusLabel.textColor = .ypWhite
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: usernameLabel?.bottomAnchor ?? NSLayoutAnchor(), constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: profileImageView?.leadingAnchor ?? NSLayoutAnchor())
        ])
    }

    private func configLogoutButton() {
        let button = UIButton.systemButton(
            with: UIImage(named: "ipad.and.arrow.forward") ?? UIImage(),
            target: self,
            action: #selector(didTapButton)
        )
        self.logoutButton = button
        
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: profileImageView?.centerYAnchor ?? NSLayoutAnchor()),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func didTapButton() {
        
    }
}
