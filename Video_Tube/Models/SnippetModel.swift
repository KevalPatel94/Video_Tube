//
//  SnippetModel.swift
//  Video_Tube
//
//  Created by Keval Patel on 5/14/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import ObjectMapper
public class SnippetModel: Mappable{
    var channelId : String?
    var channelTitle : String?
    var description : String?
    var playlistId : String?
    var position : String?
    var publishedAt : String?
    var resourceId : ResourceIdModel?
    var thumbnails : Dictionary<String,ThumbnailModel>?
    var title : String?

    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        channelId <- map["channelId"]
        channelTitle <- map["channelTitle"]
        description <- map["description"]
        playlistId <- map["playlistId"]
        position <- map["position"]
        publishedAt <- map["publishedAt"]
        resourceId <- map["resourceId"]
        thumbnails <- map["thumbnails"]
        title <- map["title"]
    }
}
