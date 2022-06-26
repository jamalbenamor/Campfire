//
//  SetupNameViewController.swift
//  Campfire
//
//  Created by Jamal Benamor on 07/06/2022.
//


import UIKit
import Firebase


class SetupNameViewController: UIViewController {
    
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
        label.text = "What's your name?"
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
    
    
    
    let nameField: UITextField = {
        let field = UITextField()
        let grayPlaceholderText = NSAttributedString(string: "Your name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        field.attributedPlaceholder = grayPlaceholderText
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.textColor = .white
        field.keyboardType = .alphabet
        field.textContentType = .givenName
        field.font = UIFont.boldSystemFont(ofSize: 40)
//        field.returnKeyType = .done
        return field
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
        button.addTarget(self, action: #selector(enterName), for: .touchUpInside)
        return button
    }()
    
  
    
    
    @objc func enterName()  {
        print("enterName pressed")
        
        continueButton.setTitle("", for: .normal)
        spinner.isHidden = false
        self.continueButton.isUserInteractionEnabled = false
        
        if let text = nameField.text, !text.isEmpty {
            Varibles.usersName = text
            guard let uid = Auth.auth().currentUser?.uid else {return}
//            var ref: DatabaseReference!
            let ref = Database.database().reference()
            ref.child("users").child(uid).updateChildValues(["name": Varibles.usersName]) {
              (error:Error?, ref:DatabaseReference) in
              if let error = error {
                  self.requestTimedOut()
                  print("Data could not be saved: \(error).")
                  self.spinner.isHidden = true
                  self.continueButton.setTitle("Continue", for: .normal)
                  self.continueButton.isUserInteractionEnabled = true
              } else {
                print("Data saved successfully!")
                  
                let vc = SetupUsernameViewController()
                vc.modalPresentationStyle = .fullScreen
                  
                self.navigationController?.pushViewControllerWithCompletion(viewController: vc, animated: true) {
                    self.spinner.isHidden = true
                    self.continueButton.setTitle("Continue", for: .normal)
                    self.continueButton.isUserInteractionEnabled = true
                }
              }
            }
        }
    }
    
  
    
    var continueBottomAnchor: NSLayoutConstraint?
    var continueToKeyboardBottomAnchor: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        print("viewdidload setupNameViewController")
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
        
        
        
        
        view.addSubview(nameField)
        nameField.topAnchor.constraint(equalTo: userInstructionsLabel.bottomAnchor, constant: 16).isActive = true
        nameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
    
    
}



