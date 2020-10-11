//
//  RequestManager.swift
//  AppClip
//
//  Created by Просто Денис on 06.10.2020.
//

import Foundation
import Alamofire

class RequestManager : NSObject {
    static let baseUrl: String = "https://black-dog.redfoxproject.com/api/v1/"
    
    static func makeRequest(url: String, closureBloack: @escaping ([String: AnyObject]) -> ()) {
        
        AF.request(self.baseUrl + url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                closureBloack(value as! [String: AnyObject])
            case .failure(let error):
                print(error)
            }
            
        }
    }
}
