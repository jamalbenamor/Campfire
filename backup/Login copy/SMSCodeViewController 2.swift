//
//  SMSCodeViewController.swift
//  Campfire
//
//  Created by Jamal Benamor on 07/06/2022.
//

import Foundation


import UIKit
import Firebase
import FirebaseMessaging


class SMSCodeViewController: UIViewController {
    
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
        label.text = "Enter the code we sent to "+Varibles.userPhoneNumber
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
    
    
    
    let codeField: UITextField = {
        let field = UITextField()
        let grayPlaceholderText = NSAttributedString(string: "••••••", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        field.attributedPlaceholder = grayPlaceholderText
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.textColor = .white
        field.keyboardType = .numberPad
        field.textContentType = .oneTimeCode
        field.font = UIFont.boldSystemFont(ofSize: 40)
//        field.returnKeyType = .done
        return field
    }()
    
    
    let changePhoneNumberButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(changePhoneNumber), for: .touchUpInside)
        return button
    }()
    
    let changePhoneNumberLabel: UITextView = {
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
        button.addTarget(self, action: #selector(enterCode), for: .touchUpInside)
        return button
    }()
    
    
    
    
    @objc func enterCode()  {
        print("continue pressed")
        
        continueButton.setTitle("", for: .normal)
        spinner.isHidden = false
        self.continueButton.isUserInteractionEnabled = false

        if let text = codeField.text, !text.isEmpty {
            let code = text
            AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
                guard success else {
                    self?.requestTimedOut()
                    self?.spinner.isHidden = true
                    self?.continueButton.setTitle("Continue", for: .normal)
                    self?.continueButton.isUserInteractionEnabled = true
                    return
                    
                }
                DispatchQueue.main.async {
                    

                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    let userRef = Database.database().reference().child("users").child(uid)
                    guard let fcmToken = Messaging.messaging().fcmToken else { return }
                    
                    userRef.updateChildValues(["phone_number": Varibles.userPhoneNumber, "fcm_token": fcmToken]) {
                      (error:Error?, ref:DatabaseReference) in
                      if let error = error {
                          self?.requestTimedOut()
                          print("Data could not be saved: \(error).")
                          self?.spinner.isHidden = true
                          self?.continueButton.setTitle("Continue", for: .normal)
                          self?.continueButton.isUserInteractionEnabled = true
                      } else {
                        print("Data saved successfully!")
                        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                              if let dictionary = snapshot.value as? [String: AnyObject] {
                                  
                                  if let name = dictionary["name"] as? String {
                                      Varibles.usersName = name
                                      
                                      let vc = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
                                      vc.modalPresentationStyle = .fullScreen
                                      
                                      self?.navigationController?.pushViewControllerWithCompletion(viewController: vc, animated: true) {
                                          self?.spinner.isHidden = true
                                          self?.continueButton.setTitle("Continue", for: .normal)
                                          self?.continueButton.isUserInteractionEnabled = true
                                      }
                                      
                                  } else {
                                      
                                      let usernamesRef = Database.database().reference()
                                      usernamesRef.child("phone_numbers").updateChildValues([Varibles.userPhoneNumber: uid]) {
                                          (error:Error?, ref:DatabaseReference) in
                                          if let error = error {
                                              self?.requestTimedOut()
                                              print("Data could not be saved: \(error).")
                                              self?.spinner.isHidden = true
                                              self?.continueButton.setTitle("Continue", for: .normal)
                                              self?.continueButton.isUserInteractionEnabled = true
                                              
                                          } else {
                                              print("Data saved successfully!")
                                              
                                              let vc = SetupNameViewController()
                                              vc.modalPresentationStyle = .fullScreen
        //                                      self?.navigationController?.pushViewController(vc, animated: true)
                                              
                                              self?.navigationController?.pushViewControllerWithCompletion(viewController: vc, animated: true) {
                                                  self?.spinner.isHidden = true
                                                  self?.continueButton.setTitle("Continue", for: .normal)
                                                  self?.continueButton.isUserInteractionEnabled = true
                                              }
                                              
                                          }
                                          
                                      }
                                      
                                      
                                  }
                              }
                          })
                      }
                    }
                }
            }
        }
    }
    
    @objc func changePhoneNumber()  {
        print("display agreements pressed")
        self.navigationController?.popViewController(animated: true)
        
        // 6505551234
        // 650-555-0001
        
    }
    
    var continueBottomAnchor: NSLayoutConstraint?
    var continueToKeyboardBottomAnchor: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload login")
        setupUI()
//        GIDSignIn.sharedInstance()?.delegate = self
//        GIDSignIn.sharedInstance()?.presentingViewController = self
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    
    
    
    func setupUI() {
        // set backround colour to white
        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = true
        
        // setup loginButton constraints
//        view.addSubview(loginButton)
//        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
//        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
//        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        
        
        
        
        view.addSubview(codeField)
        codeField.topAnchor.constraint(equalTo: userInstructionsLabel.bottomAnchor, constant: 16).isActive = true
        codeField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        codeField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        codeField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        
        view.addSubview(changePhoneNumberLabel)
        changePhoneNumberLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        changePhoneNumberLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        changePhoneNumberLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16).isActive = true
        
        
        view.addSubview(changePhoneNumberButton)
        changePhoneNumberButton.leftAnchor.constraint(equalTo: changePhoneNumberLabel.leftAnchor, constant: 0).isActive = true
        changePhoneNumberButton.rightAnchor.constraint(equalTo: changePhoneNumberLabel.rightAnchor, constant: 0).isActive = true
        changePhoneNumberButton.bottomAnchor.constraint(equalTo: changePhoneNumberLabel.bottomAnchor, constant: 0).isActive = true
        changePhoneNumberButton.topAnchor.constraint(equalTo: changePhoneNumberLabel.topAnchor).isActive = true
        
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
        let alert = UIAlertController(title: "Your request has timed out", message: "Please check your internet connection and that your verification code is correct.", preferredStyle: .alert)
        
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



