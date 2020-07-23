//
//  ViewController.swift
//  FarmerMakert
//
//  Created by Hemant Gore on 23/07/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import UIKit
import  FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var mobileNoTextField: UITextField!

    let isMFAEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    @IBAction func loginTaped(_ sender: Any) {
        PhoneAuthProvider.provider().verifyPhoneNumber(mobileNoTextField.text!, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            self.showMessage(title: NSLocalizedString("Error", comment: "Title for Error"), message: error.localizedDescription, actionTitle: NSLocalizedString("Ok", comment: "Ok"))
            return
          }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            // Sign in using the verificationID and the code sent to the user
            self.promptVerificationCode()
        }
    }

    private func promptVerificationCode() {
        showInputDialog(title: NSLocalizedString("Add verification code", comment: "Add verification code"),
                        subtitle: NSLocalizedString("Please enter the one time code received in SMS", comment: "Please enter the one time code received in SMS"),
                        actionTitle: NSLocalizedString("Submit", comment: "Submit"),
                        cancelTitle: NSLocalizedString("Cancel", comment: "Cancel"),
                        inputPlaceholder: NSLocalizedString("code", comment: "placeholder for code"),
                        inputKeyboardType: .numberPad) { (input: String?) in
                            print("Code is \(input ?? "")")
                            if let verificationCode = input,
                                verificationCode.count == 6,
                                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") {

                                let credential = PhoneAuthProvider.provider().credential(
                                    withVerificationID: verificationID,
                                verificationCode: verificationCode)
                                self.signIn(credential: credential)
                            }
        }
        
    }

    private func signIn(credential: PhoneAuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            if (self.isMFAEnabled && authError.code == AuthErrorCode.secondFactorRequired.rawValue) {

            } else {
                self.showMessage(title: NSLocalizedString("Error", comment: "Title for Error"), message: error.localizedDescription, actionTitle: NSLocalizedString("Ok", comment: "Ok"))
              return
            }
            return
          }

            if let dashboardVC = DashboardViewController.controllerInStoryboard() {
                let navVC = UINavigationController(rootViewController: dashboardVC)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
}

