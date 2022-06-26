//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 4/13/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    
    
    var user: User? {
        didSet {
            
            usernameLabel.text = user?.username
            
//            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
            if Varibles.searchSegmentedControlState == "search" {
                if user?.username == "" {
                    // not on Campfire
                    viewButton.setTitle("INVITE", for: .normal)
                    usernameLabel.text = user?.phone_number
                } else {
                    // user on Campfire
                    viewButton.setTitle("ADD", for: .normal)
                }
                
            } else if Varibles.searchSegmentedControlState == "friends" {
                viewButton.setTitle("DELETE", for: .normal)
                
            } else if Varibles.searchSegmentedControlState == "received_friend_requests" {
                viewButton.setTitle("ADD", for: .normal)
                
            } else if Varibles.searchSegmentedControlState == "sent_friend_requests" {
                viewButton.setTitle("ADDED", for: .normal)
            }
            
            
            nameLabel.text = user?.name
            
            let profile_image = user?.profile_image
            let profile_image_url = user?.profile_image_url
            
                
            if profile_image == UIImage(systemName: "person.circle.fill") {
                print("no contact image profile picture")
                
                if profile_image_url != "" {
                    // stored profile image in db
                    print("stored profile image in db, image url: ", profile_image_url!)
                    self.profileImageLabel.text = ""
                    self.profileImageLabel.isHidden = true
                    self.profileColorView.isHidden = true
                    self.profileImageView.isHidden = false
                    profileImageView.loadImage(urlString: profile_image_url!)
                } else {
                    // no stored profile image in db
                    print("no stored profile image in db")
                    self.profileImageLabel.text = String(user!.name.prefix(1))
                    self.profileColorView.backgroundColor = .darkGray //random
                    self.profileImageView.isHidden = true
                    self.profileColorView.isHidden = false
                    self.profileImageLabel.isHidden = false
                }
            } else {
                print("contact image set")
                profileImageView.image = profile_image
                self.profileImageLabel.isHidden = true
                self.profileColorView.isHidden = true
                self.profileImageView.isHidden = false
            }
            
                
//            guard let profile_image_url = user?.profile_image_url else {
//                // make profile image into letter of first name
//
////                print("no profile image")
////                self.profileImageLabel.text = String(user!.name.prefix(1))
//
//                return
//            }
            
//            if profile_image_url == "" {
//                print("profile image url nil")
//                print("no profile image")
//                self.profileImageLabel.text = String(user!.name.prefix(1))
//                self.profileImageView.backgroundColor = .blue
//            } else {
//                print("profile image url: ", profile_image_url)
//                self.profileImageLabel.text = ""
//                self.profileImageView.backgroundColor = .clear
//                profileImageView.loadImage(urlString: profile_image_url)
//            }
            
//            print("user cell data set")
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.clipsToBounds = true
        return iv
    }()
    
    let profileColorView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        return iv
    }()
    
    let profileImageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let viewButton: UIButton = {
        let button = UIButton()
        button.setTitle("VIEW", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50)
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(loadUserProfile), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func loadUserProfile() {
        print("view pressed")
        
        
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(profileColorView)
        addSubview(profileImageLabel)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(viewButton)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        
        profileColorView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileColorView.layer.cornerRadius = 50 / 2
        profileColorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        profileImageLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageLabel.layer.cornerRadius = 50 / 2
        profileImageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        nameLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: centerYAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 2, paddingRight: 0, width: 0, height: 0)
        
        usernameLabel.anchor(top: centerYAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
        viewButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 18, paddingLeft: 8, paddingBottom: 18, paddingRight: 16, width: 70, height: 0)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
        
        
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
