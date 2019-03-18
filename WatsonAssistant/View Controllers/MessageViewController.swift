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
    private var string: String=""
    private var i: Int=0
    
    
    
    
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
        message.resignFirstResponder()
        string=message.text ?? ""
        
        messageList.insert("UTENTE: " + string, at: i)
        tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
        
        tableView.cellForRow(at: IndexPath(row: i, section: 0))?.textLabel?.textAlignment = NSTextAlignment.right
        
        
        message.text=""
        i+=1
        messageList.insert("PinoBot: risposta", at: i)
        tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
        
        tableView.cellForRow(at: IndexPath(row: i, section: 0))?.textLabel?.textAlignment = NSTextAlignment.left
        
        
        i+=1
        
        
        
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageList.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        //riempio la cella

        cell.textLabel?.text = self.messageList[indexPath.row]
        
        return cell
    }
    
   
    
    
}

    



