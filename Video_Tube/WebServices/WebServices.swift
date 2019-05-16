//
//  WebServices.swift
//  Video_Tube
//
//  Created by Keval Patel on 5/14/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import ObjectMapper
class WebService: NSObject {
    static let shared = WebService()
    func fetchVideos(_ urlString: String,_ runQueue: DispatchQueue,_ completionQueue: DispatchQueue,completion: @escaping ([VideoModel]?, Error?,String?) -> ()) {
        runQueue.async {
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, resp, error) in
                //Check for error
                if let error = error {
                    completionQueue.async {
                        completion(nil, error,nil)
                    }
                    return
                }
                //Check for data
                guard let data = data else {
                    completionQueue.async {
                        completion(nil, error,nil)
                    }
                    return
                }
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: []) as! [String:AnyObject]
                    var token = ""
                    //Check for data under key items
                    guard jsonResponse["items"] != nil  else{
                        completionQueue.async {
                            completion(nil, error,token)
                        }
                        return
                    }
                    
                    token = jsonResponse["nextPageToken"] == nil ? "Not Found" :  jsonResponse["nextPageToken"] as! String
                    // Map Jason response to VideoModel Array
                    let videos = Mapper<VideoModel>().mapArray(JSONObject: jsonResponse["items"])
                    completionQueue.async {
                        completion(videos,nil,token)
                    }
                } catch let jsonErr {
                    completion(nil, jsonErr,nil)
                }
            }.resume()
        }
    }
}
