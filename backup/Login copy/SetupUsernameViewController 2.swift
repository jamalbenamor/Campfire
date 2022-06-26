//
//  SetupUsernameViewController.swift
//  Campfire
//
//  Created by Jamal Benamor on 07/06/2022.
//

import UIKit
import Firebase


class SetupUsernameViewController: UIViewController {
    
    var homeController: HomeViewController?
    var loginViewController: LoginViewController?
    
    let campfireTitle: UILabel = {
        let label = UILabel()
        label.text = "Campfire"
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFit
        return label
    }()
    
    let userInstructionsLabel: UITextView = {
        let label = UITextView()
        label.text = "Choose a usename"
        label.textColor = .white
        label.backgroundColor = .clear
        label.isScrollEnabled = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFit
        label.isEditable = false
        label.isSelectable = false
        return label
    }()
    
    
    
    let usernameField: UITextField = {
        let field = UITextField()
        let grayPlaceholderText = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        field.attributedPlaceholder = grayPlaceholderText
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.textColor = .white
        field.keyboardType = .alphabet
        field.textContentType = .username
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.font = UIFont.boldSystemFont(ofSize: 40)
//        field.returnKeyType = .done
        return field
    }()
    
    let errorLabel: UITextView = {
        let tv = UITextView()
        tv.text = "Change the phone number"
        tv.backgroundColor = .clear
        tv.layer.masksToBounds = true
        tv.textColor = .darkGray
        tv.textAlignment = .center
        tv.font = UIFont.boldSystemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 5
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isSelectable = false
//        tv.addTarget(self, action: #selector(displayAgreementDetails), for: .touchUpInside)
        return tv
    }()
    
    let spinner: SpinnerView = {
        let spinner = SpinnerView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.animate()
        spinner.isHidden = true
        return spinner
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(enterUsername), for: .touchUpInside)
        return button
    }()
    
  
    
    
    @objc func enterUsername()  {
        print("enterUsername pressed")
        print(usernameField.text)
        print(usernameField.text?.isAlphanumeric)
        
        if usernameField.text?.isAlphanumeric != true {
            usernameInvalid()
            return
        } else {
        
            continueButton.setTitle("", for: .normal)
            spinner.isHidden = false
            self.continueButton.isUserInteractionEnabled = false
            
            if let text = usernameField.text, !text.isEmpty {
                Varibles.usersUsername = (text).lowercased()
            
                print("username: ", Varibles.usersUsername)
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                let nameRef = Database.database().reference().child("usernames").child(Varibles.usersUsername)
                nameRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let username = snapshot.value as? String {
                        print("username = snapshot.value : ", username)
                        
                        if username == uid {
                            self.saveUsername()
                        } else {
                            
                            self.spinner.isHidden = true
                            self.continueButton.setTitle("Continue", for: .normal)
                            self.continueButton.isUserInteractionEnabled = true
                            self.usernameTaken()
                        }
                        
                    } else {
                        self.saveUsername()
                        
                    }
                
                    
                })
            }
        }
    }
    
    func saveUsername() {
        let currentTime = Int(Date().timeIntervalSince1970)
        guard let uid = Auth.auth().currentUser?.uid else {return}
//        var ref: DatabaseReference!
        let ref = Database.database().reference()
        ref.child("users").child(uid).updateChildValues(["username": Varibles.usersUsername, "date_joined": currentTime]) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
              self.requestTimedOut()
              print("Data could not be saved: \(error).")
              self.spinner.isHidden = true
              self.continueButton.setTitle("Continue", for: .normal)
              self.continueButton.isUserInteractionEnabled = true
          } else {
            print("Data saved successfully!")
              
              
            let usernamesRef = Database.database().reference()
            usernamesRef.child("usernames").updateChildValues([Varibles.usersUsername: uid]) {
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    self.requestTimedOut()
                    print("Data could not be saved: \(error).")
                    self.spinner.isHidden = true
                    self.continueButton.setTitle("Continue", for: .normal)
                    self.continueButton.isUserInteractionEnabled = true
                } else {
                    print("Data saved successfully!")

                
                    let vc = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    self.navigationController?.pushViewControllerWithCompletion(viewController: vc, animated: true) {
                        self.spinner.isHidden = true
                        self.continueButton.setTitle("Continue", for: .normal)
                        self.continueButton.isUserInteractionEnabled = true
                        
                    }
                    
                }
            }
          }
        }
    }
    
    func usernameTaken() {
        print("usernametakeN")
        let alert = UIAlertController(title: "Username taken", message: "Please choose another one.", preferredStyle: .alert)
        
        //create a contact admin button
        let contactAdmin = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
            // calls the same function so the suspended user can't access the app
//            self.usernameTaken()
        }
        
        alert.addAction(contactAdmin)
        
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
    
    
    func usernameInvalid() {
        print("Username invalid")
        let alert = UIAlertController(title: "Username invalid", message: "Usernames must be alphanumeric (only letters and numbers)", preferredStyle: .alert)
        
        //create a contact admin button
        let contactAdmin = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
            // calls the same function so the suspended user can't access the app
//            self.usernameTaken()
        }
        
        alert.addAction(contactAdmin)
        
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
    
    func requestTimedOut() {
        print("requestTimedOut")
        let alert = UIAlertController(title: "Your request has timed out", message: "Please connect to the internet.", preferredStyle: .alert)
        
        //create a contact admin button
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
          
        }
        
        alert.addAction(ok)
        
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
    
  
    
    var continueBottomAnchor: NSLayoutConstraint?
    var continueToKeyboardBottomAnchor: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        print("viewdidload setupUsernameViewController")
        setupUI()
        self.navigationItem.setHidesBackButton(true, animated:true)
        
    }
    
    
    
    func setupUI() {
        // set backround colour to white
        view.backgroundColor = .black
            
        
        // setup iconImage constraints
        view.addSubview(campfireTitle)
        campfireTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        campfireTitle.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        campfireTitle.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        campfireTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(userInstructionsLabel)
        userInstructionsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        userInstructionsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        userInstructionsLabel.topAnchor.constraint(equalTo: campfireTitle.bottomAnchor, constant: 24).isActive = true
//        userInstructionsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        
        view.addSubview(usernameField)
        usernameField.topAnchor.constraint(equalTo: userInstructionsLabel.bottomAnchor, constant: 16).isActive = true
        usernameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        usernameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // setup loginButton constraints
        view.addSubview(continueButton)
        continueButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        continueButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueBottomAnchor = continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        continueBottomAnchor?.isActive = true
        
        
        view.addSubview(spinner)
        spinner.heightAnchor.constraint(equalToConstant: 40).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 40).isActive = true
        spinner.centerXAnchor.constraint(equalTo: continueButton.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor).isActive = true
        
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        continueToKeyboardBottomAnchor = continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8-keyboardSize.height)
        continueBottomAnchor?.isActive = false
        continueToKeyboardBottomAnchor?.isActive = true
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        continueBottomAnchor?.isActive = true
        continueToKeyboardBottomAnchor?.isActive = false
    }
    
    
}



