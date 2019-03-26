//
//  MessageViewController.swift
//  WatsonAssistant
//
//  Created by Digital First on 12/03/19.
//  Copyright © 2019 Ibm. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    private var messageList: [String] = [""]
    
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.layer.borderWidth=2.0
        self.message.delegate=self
        self.tableView.delegate=self
        self.tableView.dataSource=self
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.height.constant = 400
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.height.constant = 60
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        message.resignFirstResponder()
    }
    
    
    @IBAction func sendMessage(_ sender: Any) {
        let watson = WatsonAssistantV2Facade.shared
        
        self.message.resignFirstResponder()
        
        self.messageList.insert("UTENTE: " + self.message.text!, at: self.messageList.count)
        self.tableView.insertRows(at: [IndexPath(row: self.messageList.count - 1, section: 0)], with: .automatic)
        
        watson.message(message.text ?? "") { answer in
            
            self.messageList.insert("PinoBot:" + answer, at: self.messageList.count)
            self.tableView.insertRows(at: [IndexPath(row: self.messageList.count - 1, section: 0)], with: .automatic)
            
        }
        
        self.message.text = ""
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = self.messageList[indexPath.row]
        
        if self.messageList[indexPath.row].contains("UTENTE: ") {
            cell.textLabel?.textAlignment = NSTextAlignment.right
        }
        
        return cell
    }
    
}
