//  WatsonAssistantV2Facade.swift
//  WatsonAssistant
//
//  Created by Edoardo Smimmo on 15/03/2019.
//  Copyright © 2019 Ibm. All rights reserved.
//

// install liberies
import Foundation
import Alamofire

// variable and constant declarations
let BASE_URL = "https://gateway-lon.watsonplatform.net/assistant/api"
let USER = "apikey"
let PASSWORD = "syRUmO5OizoHJM-Ur99kW923Zoz8iK6bE6I7qFyNHt2v"
let ASSISTANT_ID = "1880bf85-0bcd-4b77-917d-ddb4f3ed8df0"

let VERSION = "2018-11-08"

//first composition URL
let SESSION_API = "v2/assistants/" + ASSISTANT_ID + "/sessions"


// class declarations
class WatsonAssistantV2Facade {
    //creation of the method for calling API
    
    static let shared = WatsonAssistantV2Facade()
    
    private var session_id:String
    
    private init() {
        self.session_id = ""
    }
    
    private func watsonMessage(_ mess:String, completionHandler: @escaping (String) -> ()) {
        
        let messageUrl = String(format:"%@/%@?version=%@", BASE_URL, SESSION_API + "/" + self.session_id + "/message", VERSION)
        
        Alamofire.request(messageUrl, method: .post, parameters: ["input": ["text": mess]],encoding: JSONEncoding.default, headers: [:])
            .authenticate(user: USER, password: PASSWORD)
            .responseJSON { response in
            
            let json = response.result.value as! [String:AnyObject]
            
            let data = json["output"] as! [String:AnyObject]
            
            let text = data["generic"] as! [AnyObject]
            
            DispatchQueue.main.async {
                
                completionHandler(text[0]["text"] as! String)
            }
        }
    }
    
    func message(_ mess:String, completionHandler: @escaping (String) -> ()) {
        
        //first call API
        
        let sessionUrl = String(format:"%@/%@?version=%@", BASE_URL, SESSION_API, VERSION)
        
        if self.session_id.count > 0 {
            return self.watsonMessage(mess, completionHandler: completionHandler)
        }
        
        Alamofire.request(sessionUrl, method: .post)
            .authenticate(user: USER, password: PASSWORD)
            .responseJSON { response in
                
            let json = response.result.value as! [String:AnyObject]
            self.session_id = json["session_id"] as! String
            
            print(self.session_id)
            self.watsonMessage(mess, completionHandler: completionHandler)
            
        }
    }
}
