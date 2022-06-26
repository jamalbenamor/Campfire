//
//  FriendCell.swift
//  FriendsGrid
//
//  Created by Jamal Benamor on 2022/6/24.
//

import Foundation
//
//  FriendCell.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 4/13/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class FriendCell: UICollectionViewCell {
     
    var friend: Friend? {
        didSet {
            deleteButton.isHidden = true
            viewButton.isHidden = true
            acceptButton.isHidden = true
            
            if friend?.category == "friends" {
                deleteButton.isHidden = false
            } else if friend?.category == "received_friend_requests" {
                viewButton.setTitle("+ Accept", for: .normal)
                acceptButton.isHidden = false
                viewButton.isHidden = false
            } else if friend?.category == "sent_friend_requests" {
                deleteButton.isHidden = false
                
            } else if friend?.category == "suggestions" {
                viewButton.setTitle("+ Add", for: .normal)
                viewButton.isHidden = false
            } else if friend?.category == "search" {
                viewButton.setTitle("+ Add", for: .normal)
                viewButton.isHidden = false
            } else {
//                print("no category")
//                viewButton.setTitle("?", for: .normal)
            }
            
            
            nameLabel.text = friend?.name
            usernameLabel.text = friend?.username
            
//            let profile_image = user?.profile_image
//            let profile_image_url = user?.profile_image_url
            
                
//            if profile_image == UIImage(systemName: "person.circle.fill") {
//                print("no contact image profile picture")
//
//                if profile_image_url != "" {
//                    // stored profile image in db
//                    print("stored profile image in db, image url: ", profile_image_url!)
//                    self.profileImageLabel.text = ""
//                    self.profileImageLabel.isHidden = true
//                    self.profileColorView.isHidden = true
//                    self.profileImageView.isHidden = false
////                    profileImageView.loadImage(urlString: profile_image_url!)
//                } else {
//                    // no stored profile image in db
//                    print("no stored profile image in db")
//                    self.profileImageLabel.text = String(user!.name.prefix(1))
//                    self.profileColorView.backgroundColor = .darkGray //random
//                    self.profileImageView.isHidden = true
//                    self.profileColorView.isHidden = false
//                    self.profileImageLabel.isHidden = false
//                }
//            } else {
//                print("contact image set")
//                profileImageView.image = profile_image
//                self.profileImageLabel.isHidden = true
//                self.profileColorView.isHidden = true
//                self.profileImageView.isHidden = false
//            }
            
//             temp
            
            self.profileImageLabel.text = String(friend!.name.prefix(1))
            self.profileColorView.isHidden = false
            self.profileImageLabel.isHidden = false
             
        }
    }
    
    let profileImageView: CustomImageView = { 
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.clipsToBounds = true
        iv.isHidden = true
        return iv
    }()
    
    let profileColorView: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50)
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
        label.textColor = UIColor.rgb(red: 192, green: 192, blue: 192)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let viewButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Add", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50)
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.rgb(red: 192, green: 192, blue: 192), for: UIControl.State())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Accept", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50)
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.rgb(red: 252, green: 252, blue: 252), for: UIControl.State())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        //        button.isEnabled = false
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold, scale: .large)
        let image = UIImage(systemName: "xmark", withConfiguration: largeConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.rgb(red: 192, green: 192, blue: 192)
        button.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        
        //        button.isEnabled = false
        return button
    }()
    
    
    let sectionIcon: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = UIColor.rgb(red: 186, green: 186, blue: 186)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Section"
        label.textColor = UIColor.rgb(red: 186, green: 186, blue: 186)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    // setup if
    func defaultContentConfiguration(category: String) {
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .heavy, scale: .large)
        
        if category == "friends" {
            self.sectionIcon.setImage(UIImage(systemName: "person.2.fill", withConfiguration: largeConfig), for: .normal)
            self.sectionLabel.text = "Your Friends"
            
        } else if category == "received_friend_requests" {
            self.sectionIcon.setImage(UIImage(systemName: "person.2.crop.square.stack.fill", withConfiguration: largeConfig), for: .normal)
            self.sectionLabel.text = "Friend Requests"
            
        } else if category == "sent_friend_requests" {
            self.sectionIcon.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: largeConfig), for: .normal)
            self.sectionLabel.text = "Sent Requests"
            
        } else if category == "suggestions" {
            self.sectionIcon.setImage(UIImage(systemName: "sparkles", withConfiguration: largeConfig), for: .normal)
            self.sectionLabel.text = "Suggestions"
            
        } else if category == "search" {
            self.sectionIcon.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: largeConfig), for: .normal)
            self.sectionLabel.text = "Search"
//            sectionIcon.isHidden = true
//            sectionLabel.isHidden = true
            
//            sectionLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        } else {
//            print("no category: ", category)
            self.sectionIcon.setImage(UIImage(systemName: "questionmark.app.fill", withConfiguration: largeConfig), for: .normal)
            self.sectionLabel.text = "No Category"
        }
        
        
        sectionIcon.isHidden = false
        sectionLabel.isHidden = false
        usernameLabel.isHidden = true
        nameLabel.isHidden = true
        profileImageView.isHidden = true
        profileColorView.isHidden = true
        profileImageLabel.isHidden = true
        viewButton.isHidden = true
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(profileImageView)
        addSubview(profileColorView)
        addSubview(profileImageLabel)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(viewButton)
        addSubview(sectionIcon)
        addSubview(sectionLabel)
        addSubview(acceptButton)
        addSubview(deleteButton)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        
        profileColorView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileColorView.layer.cornerRadius = 50 / 2
        profileColorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        profileImageLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageLabel.layer.cornerRadius = 50 / 2
        profileImageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        nameLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: centerYAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 2, paddingRight: 0, width: 0, height: 0)
        
        usernameLabel.anchor(top: centerYAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        sectionIcon.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 30, height: 40)
        
        sectionLabel.anchor(top: nil, left: sectionIcon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 8, paddingRight: 8, width: 0, height: 40)
        
        
        
        viewButton.layer.cornerRadius = 20
        viewButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        viewButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 80, height: 40)
        
        acceptButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 40)
        acceptButton.layer.cornerRadius = 20
        acceptButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        deleteButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        deleteButton.layer.cornerRadius = 20
        deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
//        let separatorView = UIView()
//        separatorView.backgroundColor = UIColor(white: 255, alpha: 0.05)
//        addSubview(separatorView)
//        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
        
        
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
