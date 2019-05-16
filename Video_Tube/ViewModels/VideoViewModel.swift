//
//  VideoViewModel.swift
//  Video_Tube
//
//  Created by Keval Patel on 5/14/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation

public class VideoViewModel{
    private let video : VideoModel
    var contentDetails : [ContentDetailModel]?
    var etag : String?
    var id : String?
    var kind :String?
    var snippet :SnippetModel?
    //Custom property to store the playing state of any video
    var isPlaying : Bool?
    
    public init(_ video: VideoModel) {
        self.video = video // Dependency Passed in here
        self.contentDetails  = video.contentDetails
        self.etag = video.etag
        self.id = video.id
        self.kind = video.kind
        self.snippet = video.snippet
        self.isPlaying = false
    }
    public var videoId: String{
        return video.snippet?.resourceId?.videoId ?? "NotFound"
    }
    public var profileImageUrlString: String{
        return video.snippet?.thumbnails?["default"]?.url ?? "NotFound"
    }
    public var thumbImageUrlString: String{
        return video.snippet?.thumbnails?["maxres"]?.url ?? "NotFound"
    }
    public var videoTitle: String{
        return video.snippet?.title ?? "NotFound"
    }
    // Provide the timestamp for each videos
    public var timeStamp: Double{
        return video.snippet?.publishedAt?.convertDateStringToTimeStamp() ?? 0.0
    }
}



