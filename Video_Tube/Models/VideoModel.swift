//
//  Video.swift
//  Video_Tube
//
//  Created by Keval Patel on 5/14/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import ObjectMapper
public class VideoModel: Mappable{
    var contentDetails : [ContentDetailModel]?
    var etag : String?
    var id : String?
    var kind :String?
    var snippet :SnippetModel?
    
    required public init?(map: Map) {
    }
    
    // Mappable
    public func mapping(map: Map) {
        contentDetails <- map["contentDetails"]
        etag <- map["etag"]
        id <- map["id"]
        kind <- map["kind"]
        snippet <- map["snippet"]
    }
}
