//
//  ShowAPI.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/17/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import Alamofire

struct ShowAPI {
    private let url:String
    private let params:Dictionary<String,String>
    private let delegate:ViewModelProtocol?
    init(url:String, params:Dictionary<String,String>, delegate:ViewModelProtocol){
        self.url = url
        self.params = params
        self.delegate = delegate
    }
    
    func request(){
    
        Alamofire.request(url, method: .get, parameters: self.params).responseJSON(completionHandler: {
            response in
            do {
                
                let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! Array<Dictionary<String, AnyObject>>
                //print(json[0])
                for element in json {
                    var name:String
                    var poster_url:String?
                    var description:String
                    if element["show"] != nil {
                        name = element["show"]?["name"] as! String
                        if element["show"]!["image"] is NSNull {
                            poster_url = ""
                        } else {
                            poster_url = (element["show"]?["image"] as! Dictionary<String,AnyObject>)["original"] as? String
                        }
                        
                        description = element["show"]?["summary"] as! String
                    } else {
                        name = element["name"] as! String
                            //poster_url = (element["image"] as! Dictionary<String,AnyObject>)["original"] as! String
                        if element["image"] is NSNull {
                            poster_url = ""
                        } else {
                            poster_url = element["image"]?["original"] as? String
                        }
                        
                        description = element["summary"] as! String
                    }
                    let newShow = TVShow(name: name, poster_url: poster_url!, description: description)
                    self.delegate?.addShow(show: newShow)
                }
            } catch {
                
            }
        })
    }
    
    
}
