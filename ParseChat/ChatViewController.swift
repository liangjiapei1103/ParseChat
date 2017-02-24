//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Jiapei Liang on 2/23/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageInputTextField: UITextField!
    
    var scrolledToBottom = false
    
    var messages: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
            print(keyboardSize.height)
        }
        
    }
    
    func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
            print(keyboardSize.height)
        }
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    @IBAction func onLogOutButton(_ sender: Any) {
        
        print("Log out")
        // PFUser.logOut()
        
        PFUser.logOutInBackground { (error) in
            if let error = error {
                // Show the errorString somewhere and let the user try again.
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action) in
                    // handle reponse here.
                }
                
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        
        present(loginViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func onSendButton(_ sender: Any) {
        
        if let message = messageInputTextField.text {
            
            var messageObject = PFObject(className: "Message")
            messageObject["text"] = message
            messageObject["user"] = PFUser.current()
            self.messageInputTextField.text = ""
            
            messageObject.saveInBackground(block: { (success, error) in
                
                if success {
                    print("Saved successfully")
                    
                    self.tableView.reloadData()
                    self.tableViewScrollToBottom(animated: true)
                } else {
                    if let error = error {
                        // Show the errorString somewhere and let the user try again.
                        let alertController = UIAlertController(title: "Failed to send message", message: error.localizedDescription, preferredStyle: .alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: .default) {
                            (action) in
                            // handle reponse here.
                        }
                        
                        // add the OK action to the alert controller
                        alertController.addAction(OKAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            })
            
        }
        
    }
    
    func onTimer() {
    
        let query = PFQuery(className: "Message")
        query.includeKey("text")
        query.includeKey("user")
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (objects, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let objects = objects {
                
                self.messages = objects.reversed()
                
                
            }
            
        }
        
        self.tableView.reloadData()
        

        self.tableViewScrollToBottom(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages != nil {
            return messages.count
        } else {
            return 0
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        
        cell.message = message
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    
    @IBAction func onTapScreen(_ sender: Any) {
        
        view.endEditing(true)
        // self.view.frame.origin.y += 226
    
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
