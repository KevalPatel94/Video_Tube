//
//  ResourceIdModel.swift
//  Video_Tube
//
//  Created by Keval Patel on 5/14/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import ObjectMapper
public class ResourceIdModel: Mappable{
    var kind : String?
    var videoId : String?
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        kind <- map["kind"]
        videoId <- map["videoId"]
    }
}
