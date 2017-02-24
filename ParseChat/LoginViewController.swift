//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Jiapei Liang on 2/23/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUpButton(_ sender: Any) {
        
        var user = PFUser()
        user.username = emailTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        
        user.signUpInBackground { (success, error) in
            
            if let error = error {
                // Show the errorString somewhere and let the user try again.
                let alertController = UIAlertController(title: "Sign Up Failed", message: error.localizedDescription, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action) in
                    // handle reponse here.
                }
                
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                // Horay! Let them use the app now.
                print("Sign up successfully")
                
                self.performSegue(withIdentifier: "loginSignUpSegue", sender: nil)
                
            }
            
        }
        
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        
        PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if let error = error {
                // Show the errorString somewhere and let the user try again.
                let alertController = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action) in
                    // handle reponse here.
                }
                
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                // Horay! Let them use the app now.
                print("Login successfully")
                
                self.performSegue(withIdentifier: "loginSignUpSegue", sender: nil)
                
            }

            
        }

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
