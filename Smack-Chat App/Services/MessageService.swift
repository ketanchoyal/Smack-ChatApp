//
//  MessageService.swift
//  Smack-Chat App
//
//  Created by Ketan Choyal on 10/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]()
    var selectedChannel : Channel?
    
    func findAllChannels(completion : @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_CHANLLES, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                
                guard let data = response.data else { return }
                
                if let json = JSON(data: data).array {
                    for items in json {
                        let id = items["_id"].stringValue
                        let channelTitle = items["name"].stringValue
                        let channelDescription = items["description"].stringValue
                        
                        let channel = Channel.init(channelTitle: channelTitle, channelDescription: channelDescription, id: id)
                        
                        self.channels.append(channel)
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                }
            }
            else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
//    func addChannel(channelName : String, channelDescription : String, completion : @escaping CompletionHandler) {
//        let name = channelName.trimmingCharacters(in: .whitespacesAndNewlines)
//        let description = channelDescription.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        let body : [String : Any] = [
//            "name" : name,
//            "description" : description
//        ]
//        
//        Alamofire.request(URL_ADD_CHANNEL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
//            if response.result.error == nil {
//                completion(true)
//            }
//            else {
//                completion(false)
//                debugPrint(response.result.error as Any)
//            }
//        }
//    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
}