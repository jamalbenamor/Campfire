//
//  Rev.swift
//  Campfire
//
//  Created by Jamal Benamor on 19/06/2022.
//

import Foundation
import UIKit
import Firebase
import SwiftUI

class ResponsesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let campfireTitle: UILabel = {
        let label = UILabel()
        label.text = "Responses"
        label.backgroundColor = .black
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFit
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .heavy, scale: .large)
        let image = UIImage(systemName: "arrow.left", withConfiguration: largeConfig)
        button.setImage(image, for: .normal)
        
        button.backgroundColor = .black
        button.tintColor = .white
        
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let noResponsesLabel: UITextView = {
        let label = UITextView()
        label.text = "None of your friends have sent you private voice messages today!"
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFit
        label.isScrollEnabled = false
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.isHidden = true
        return label
    }()
    
    
    @objc func handleDismiss() {
        let vc = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.modalPresentationStyle = .fullScreen
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(campfireTitle)
        campfireTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        campfireTitle.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        campfireTitle.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        campfireTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        setupStories()
    }
    
    
    
    var responses = [Response]()
    let cellId = "cellId"
    
    func setupStories() {
        
        print("setup stories")
        
        collectionView?.backgroundColor = Varibles.backgroundBlack//.black
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: campfireTitle.bottomAnchor, constant: 8).isActive = true
//        collectionView?.heightAnchor.constraint(equalToConstant: 800).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        
        
        collectionView.addSubview(noResponsesLabel)
        noResponsesLabel.topAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -25).isActive = true
        noResponsesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        noResponsesLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
//        noResponsesLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        collectionView?.register(ResponseCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.alwaysBounceVertical = true
//        collectionView?.alwaysBounceHorizontal = true
        collectionView?.keyboardDismissMode = .onDrag
//        collectionView?.setMinimumLineSpacing = 2
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: 70)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        updateResponses()
        
        
    }
    
    func updateResponses() {
        
        print("update responses")
        self.responses = [Response]()
        self.collectionView?.reloadData()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let date = Date().dateMonthToday()
        let ref = Database.database().reference().child("users").child(uid).child("responses").child(date)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let responseids = snapshot.value as? [String: Any] {
                
                for responseid in responseids {
                    
                    print("responseid.key: ", responseid.key, " responseid.value: ", responseid.value)
                    
                    self.fetchResponses(responseid: responseid.key)
                }
            } else {
                // no responses
            }
        }, withCancel: nil)
        
    }
    
    
    
    
    func fetchResponses(responseid: String) {
        print("🔆 start fetching fetchResponses from: ", responseid)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let date = Date().dateMonthToday()
        let userRef = Database.database().reference().child("users").child(uid).child("responses").child(date).child(responseid)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            let response = Response(audio_id: responseid, dictionary: dictionaries)
            
//            if let todays_recording = dictionaries["todays_recording"] as? String {
//                self.users.append(user)
//            }
            
//            print("Date.dateMonthToday: ", Date().dateMonthToday())
//            if let name = dictionaries["name"] as? String {
                
            self.responses.append(response)
                
//            }
            
//            self.responses.sort(by: { (u1, u2) -> Bool in
//                return u1.timestamp.compare(u2.timestamp) == .orderedDescending
//            })
            
            self.responses.sort { $0.timestamp > $1.timestamp  }

//            self.responses = self.responses.sorted(by: {$0.timestamp.compare($1.timestamp) == .orderedDescending})
//            print(self.responses)
            
            self.collectionView?.reloadData()

            
        }) { (err) in
            print("Failed to fetch users for search:", err)
        }
    }
    
     
    
    
    
    // select row in collection view
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let response = responses[indexPath.item]
        print("selected user: ", response.uid)
//        playRecording(uid: user.uid)
    }
    
    
    func selectUser(user: User) {
        
         
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         
        if responses.count == 0 {
            self.noResponsesLabel.isHidden = false
        } else {
            self.noResponsesLabel.isHidden = true
        }
            
        return responses.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ResponseCell
        
        cell.response = responses[indexPath.item]
        
        
        return cell
    }
    
    @objc func recordCellButtonPressed(_ sender: UIButton) {
        let section = sender.accessibilityHint
        print("hear my received messages: ", section)
//        showMiniPlayerForUser(user_id: section!)
//        print("recordCellButtonPressed: ", section!)
    }
    
    @objc func hearResponsesButtonPressed(_ sender: UIButton) {
//        let section = sender.accessibilityHint
        print("hear my received messages")
//        print("recordCellButtonPressed: ", section!)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width
        
//        if indexPath.item == 0 {
//            return CGSize(width: width, height: 162)
//        } else {
//            return CGSize(width: width, height: 188)
//        }
        return CGSize(width: width, height: 70)
    }
    
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
