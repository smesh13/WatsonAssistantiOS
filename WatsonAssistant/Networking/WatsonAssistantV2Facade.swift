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
var baseUrl = "https://gateway-lon.watsonplatform.net/assistant/api"
let user = "apikey"

let assistant_id: String = "1880bf85-0bcd-4b77-917d-ddb4f3ed8df0"
let password = "syRUmO5OizoHJM-Ur99kW923Zoz8iK6bE6I7qFyNHt2v"
let version: String = "version=2018-11-08"
//first composition URL
let servicePath:String = "v2/assistants/"+assistant_id+"/sessions"
let url = String(format:"%@/%@?%@", baseUrl,servicePath,version)



// class declarations
class WatsonAssistantV2Facade{
    //creation of the method for calling API
    var session_id:String = ""
    var rx:String?
    var rx1:String? = ""
    var queueB = DispatchQueue.init(label: "it.xcoding.queueB", qos: .background)
    
    
    func getOrders(completionHandler: @escaping (String) -> ()) {
        message("ciao", completionHandler: completionHandler)
    }
    
    func message(_ mess:String, completionHandler: @escaping (String) -> ()) -> Void {
        
        //first call API
        
        Alamofire.request(url, method: .post).authenticate(user: user, password: password).responseJSON {response in
            
            if let data = response.data {
                
                self.session_id = (String(data: data, encoding: .utf8) ?? "")
                var array=self.session_id.split(separator: ":")
                var finale=array[1].split(separator: "\"")
                self.session_id=String(finale[0])
                
            }
            
            print(self.session_id)
            let servicePath2="/v2/assistants/"+assistant_id+"/sessions/"+self.session_id+"/message"
            let url2 = String(format:"%@/%@?%@", baseUrl,servicePath2,version)
            var msg:String = ""
            var msg2:String = ""
            
            //second call
            
            Alamofire.request(url2, method: .post, parameters: ["input": ["text": mess]],encoding: JSONEncoding.default, headers: [:]).authenticate(user: user, password: password).responseJSON { response2 in
                
                let json = response2.result.value as! [String:AnyObject]
                
                let data = json["output"] as! [String:AnyObject]
                
                let text = data["generic"] as! [AnyObject]
                
                self.rx1 = text[0]["text"] as? String
                DispatchQueue.main.async {
                    //                    print(response2)
                    print (self.rx1 ?? "valore")
                    completionHandler(self.rx1 ?? "")
                }
            }
        }
        
        
    }
    
    
    
}
