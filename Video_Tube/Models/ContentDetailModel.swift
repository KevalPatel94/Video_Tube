//
//  ContentDetailModel.swift
//  Video_Tube
//
//  Created by Keval Patel on 5/14/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import ObjectMapper
public class ContentDetailModel: Mappable{
    var videoId : String?
    var videoPublishedAt : String?
    
    required public init?(map: Map) {
    }
    
    // Mappable
    public func mapping(map: Map) {
        videoId <- map["videoId"]
        videoPublishedAt <- map["videoPublishedAt"]
    }
}
