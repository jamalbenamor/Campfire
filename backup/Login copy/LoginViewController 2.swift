//
//  LoginController.swift
//  Campfire
//
//  Created by Jamal Benamor on 07/06/2022.
//


import UIKit
import Firebase
//import GoogleSignIn

class LoginViewController: UIViewController {
    
    var homeController: HomeViewController?
//    var settingsController: SettingsController?
    
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
        label.text = "Create your account using your phone number"
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
    
    
    let countryCodeButton: UIButton = {
        let button = UIButton(type: .system)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.borderless()
            config.buttonSize = .small
            config.cornerStyle = .medium
            button.configuration = config
            button.showsMenuAsPrimaryAction = true
            button.tintColor = .white
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("🇬🇧+44", for: .normal)
            button.setTitleColor(.white, for: UIControl.State())
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            button.backgroundColor = .black
            button.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.3)
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 25
            
        } else {
            // Fallback on earlier versions
            print("not ios 15")
        }
        return button
      
    }()
    
    private func createMenu(actionTitle: String? = nil) -> UIMenu {
        
        
        
        var items = [UIMenuElement]()
        
        for index in 0..<CountryCodes.Countries.count {
            let name = CountryCodes.Countries[index].name
            let dial_code = CountryCodes.Countries[index].dial_code
            let flag = CountryCodes.Countries[index].flag
            
            let uiMenuElement = UIAction(title: "\(flag) \(name) \(dial_code)") { [unowned self] action in
                Varibles.countryCode = dial_code
                countryCodeButton.setTitle("\(flag)\(dial_code)", for: .normal)
                self.countryCodeButton.menu = createMenu(actionTitle: action.title)
            }
            if CountryCodes.Countries[index].preferred ?? false {
                items.insert(uiMenuElement, at: 0)
                
            } else {
                items.append(uiMenuElement)
            }
            
            
        }
        
        let menu = UIMenu(children: items)
        
        if let actionTitle = actionTitle {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {
                    return
                }
                if action.title == actionTitle {
                    action.state = .on
                }
            }
        } else {
            let action = menu.children.first as? UIAction
            action?.state = .on
        }
        
        return menu
    }
    
    
    private func updateActionState(actionTitle: String? = nil, menu: UIMenu) -> UIMenu {
        if let actionTitle = actionTitle {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {
                    return
                }
                if action.title == actionTitle {
                    action.state = .on
                }
            }
        } else {
            let action = menu.children.first as? UIAction
            action?.state = .on
        }
        return menu
    }
    
    
    
    let phoneNumberField: UITextField = {
        let field = UITextField()
        let grayPlaceholderText = NSAttributedString(string: "1234567890", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        field.attributedPlaceholder = grayPlaceholderText
        field.textAlignment = .left
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.textColor = .white
        field.keyboardType = .numberPad
        field.textContentType = .telephoneNumber
        field.font = UIFont.boldSystemFont(ofSize: 40)
//        field.returnKeyType = .done
        return field
    }()
    
    
    let agreementDetailsButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(displayAgreementDetails), for: .touchUpInside)
        return button
    }()
    
    let agreementDetailsLabel: UITextView = {
        let tv = UITextView()
        tv.text = "By tapping \"Continue\", you are agreeing to our Privacy Policy and Terms of Service."
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
        button.addTarget(self, action: #selector(enterPhoneNumber), for: .touchUpInside)
        return button
    }()
    
    @objc func changeCountryCode()  {
        print("changeCountryCode pressed")
        
    }
    
    
    @objc func enterPhoneNumber()  {
        print("continue pressed", Varibles.countryCode)
        continueButton.setTitle("", for: .normal)
        spinner.isHidden = false
        self.continueButton.isUserInteractionEnabled = false

        if let text = phoneNumberField.text, !text.isEmpty {
            let number = "\(Varibles.countryCode)\(text)"
            Varibles.userPhoneNumber = number
            AuthManager.shared.startAuth(phoneNumber: number) { [weak self] success in
                guard success else {
                    print("error 2")
                    self?.requestTimedOut()
                    self?.spinner.isHidden = true
                    self?.continueButton.setTitle("Continue", for: .normal)
                    self?.continueButton.isUserInteractionEnabled = true
                    return
                }
                DispatchQueue.main.async {
                    let vc = SMSCodeViewController()
                    self?.navigationController?.pushViewControllerWithCompletion(viewController: vc, animated: true) {
                        self?.spinner.isHidden = true
                        self?.continueButton.setTitle("Continue", for: .normal)
                        self?.continueButton.isUserInteractionEnabled = true
                    }
                        
                    
                        
                    
                }
            }
        } else {
            print("error 1")
            requestTimedOut()
            spinner.isHidden = true
            continueButton.setTitle("Continue", for: .normal)
            continueButton.isUserInteractionEnabled = true
        }
        
    }
    
    @objc func displayAgreementDetails()  {
        print("display agreements pressed")
        
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
        
        
        view.addSubview(countryCodeButton)
        countryCodeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        countryCodeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        countryCodeButton.topAnchor.constraint(equalTo: userInstructionsLabel.bottomAnchor, constant: 16).isActive = true
        countryCodeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        countryCodeButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        countryCodeButton.menu = createMenu()
        
        view.addSubview(phoneNumberField)
        phoneNumberField.leftAnchor.constraint(equalTo: countryCodeButton.rightAnchor, constant: 16).isActive = true
        phoneNumberField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        phoneNumberField.centerYAnchor.constraint(equalTo: countryCodeButton.centerYAnchor, constant: 0).isActive = true
        phoneNumberField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        
        
        view.addSubview(agreementDetailsLabel)
        agreementDetailsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        agreementDetailsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        agreementDetailsLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16).isActive = true
        
        
        view.addSubview(agreementDetailsButton)
        agreementDetailsButton.leftAnchor.constraint(equalTo: agreementDetailsLabel.leftAnchor, constant: 0).isActive = true
        agreementDetailsButton.rightAnchor.constraint(equalTo: agreementDetailsLabel.rightAnchor, constant: 0).isActive = true
        agreementDetailsButton.bottomAnchor.constraint(equalTo: agreementDetailsLabel.bottomAnchor, constant: 0).isActive = true
        agreementDetailsButton.topAnchor.constraint(equalTo: agreementDetailsLabel.topAnchor).isActive = true
        
        
        
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
        let alert = UIAlertController(title: "Your request has timed out", message: "Please check your internet connection and that your phone number is correct.", preferredStyle: .alert)
        
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
