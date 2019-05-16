//
//  ThumbnailModel.swift
//  Video_Tube
//
//  Created by Keval Patel on 5/14/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import ObjectMapper
public class ThumbnailModel: Mappable{
    var height : String?
    var url : String?
    var width : String?

    required public init?(map: Map) {
    }
    
    // Mappable
    public func mapping(map: Map) {
        height <- map["height"]
        url <- map["url"]
        width <- map["width"]
    }
}
