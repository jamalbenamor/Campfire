//
//  PostFunctions.swift
//  Campfire
//
//  Created by Jamal Benamor on 2022/6/27.
//

import Foundation
import UIKit
import Firebase
import SwiftUI

extension HomeViewController {
    
    func deletePost() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
//        var ref: DatabaseReference!
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("last_posted").removeValue() {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data deleted from last_posted successfully!")
            
//            var newRef: DatabaseReference!
            let newRef = Database.database().reference()
            newRef.child("users").child(uid).child("last_recording").removeValue() {
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data deleted from last_recording successfully!")
                    
                    let date = Date().dateMonthToday()
                    let newRef2 = Database.database().reference()
                    newRef2.child("users").child(uid).child("memories").child(date).removeValue() {
                        (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                            print("Data deleted from memories successfully!")
                            Profile.profile.posted_today = false
                            self.checkIfUserIsLoggedIn()
                            
                        }
                    }
                    
                }
            }
          }
        }
        
    }
    
    
    func report(post: Post) {
         // \(user.name) (@\(user.username))
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //create a contact admin button
        let campfire = UIAlertAction(title: "Report this Campfire", style: .destructive) { (action) -> Void in
            // calls the same function so the suspended user can't access the app
            print("Report post: \(post.username)")
            self.reportPost(post: post)
        }
        
        let user = UIAlertAction(title: "Report \(post.name)", style: .destructive) { (action) -> Void in
            // calls the same function so the suspended user can't access the app
//            self.handleLogout()
            print("Report user: \(post.username)")
            self.reportUser(post: post)
//            self.sendFriendRequest(user: user)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            // calls the same function so the suspended user can't access the app
//            self.handleLogout()
            print("cancel")
//            self.sendFriendRequest(user: user)
        }
        
        alert.addAction(campfire)
        alert.addAction(user)
        alert.addAction(cancel)
        
        // present the alert
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let currentPopoverpresentioncontroller = alert.popoverPresentationController{
                currentPopoverpresentioncontroller.permittedArrowDirections = []
                currentPopoverpresentioncontroller.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                currentPopoverpresentioncontroller.sourceView = self.view
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func reportPost(post: Post) {
         // \(user.name) (@\(user.username))
        let alert = UIAlertController(title: "Report this Campfire.", message: "Help us understand the problem.\nWhat's going on with this Campfire?", preferredStyle: .actionSheet)
        
        //create a contact admin button
        let undesirable = UIAlertAction(title: "It's undesirable", style: .destructive) { (action) -> Void in
            // calls the same function so the suspended user can't access the app
            print("It's undesirable: \(post.username)")
        }
        
        let inappropriate = UIAlertAction(title: "It's inappropriate", style: .destructive) { (action) -> Void in
            // calls the same function so the suspended user can't access the app
//            self.handleLogout()
            print("It's inappropriate: \(post.username)")
//            self.sendFriendRequest(user: user)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            // calls the same function so the suspended user can't access the app
//            self.handleLogout()
            print("cancel")
//            self.sendFriendRequest(user: user)
        }
        
        alert.addAction(undesirable)
        alert.addAction(inappropriate)
        alert.addAction(cancel)
        
        // present the alert
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let currentPopoverpresentioncontroller = alert.popoverPresentationController{
                currentPopoverpresentioncontroller.permittedArrowDirections = []
                currentPopoverpresentioncontroller.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                currentPopoverpresentioncontroller.sourceView = self.view
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func reportUser(post: Post) {
         // \(user.name) (@\(user.username))
        let alert = UIAlertController(title: "Report \(post.name) (@\(post.username))", message: "Help us understand the problem.\nWhat's going on with this profile?", preferredStyle: .actionSheet)
        
        //create a contact admin button
        let undesirable = UIAlertAction(title: "It's undesirable", style: .destructive) { (action) -> Void in
            // calls the same function so the suspended user can't access the app
            print("It's undesirable: \(post.username)")
        }
        
        let inappropriate = UIAlertAction(title: "It's inappropriate", style: .destructive) { (action) -> Void in
            // calls the same function so the suspended user can't access the app
//            self.handleLogout()
            print("It's inappropriate: \(post.username)")
//            self.sendFriendRequest(user: user)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            // calls the same function so the suspended user can't access the app
//            self.handleLogout()
            print("cancel")
//            self.sendFriendRequest(user: user)
        }
        
        alert.addAction(undesirable)
        alert.addAction(inappropriate)
        alert.addAction(cancel)
        
        // present the alert
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let currentPopoverpresentioncontroller = alert.popoverPresentationController{
                currentPopoverpresentioncontroller.permittedArrowDirections = []
                currentPopoverpresentioncontroller.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                currentPopoverpresentioncontroller.sourceView = self.view
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    @objc func recordCellButtonPressed(_ sender: UIButton) {
        
        let section = sender.accessibilityHint
        showMiniPlayerForUser(user_id: section!)
//        print("recordCellButtonPressed: ", section!)
    }
    
    @objc func hearResponsesButtonPressed(_ sender: UIButton) {
//        let section = sender.accessibilityHint
        print("hear my received messages")
//        print("recordCellButtonPressed: ", section!)
        
        
//        let vc = ResponsesViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        vc.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(vc, animated: true)
//
        
        
        
        
//        let vc = ResponsesViewController(collectionViewLayout: UICollectionViewFlowLayout())
////        vc.homeController = self
//        vc.modalPresentationStyle = .fullScreen
//        let transition:CATransition = CATransition()
//        transition.duration = 0.3
//        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        transition.type = .push
//        transition.subtype = .fromRight
//        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
//
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        let vc = ResponsesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .popover
        present(navController, animated: true, completion: nil)
    }
    
    

    

}
