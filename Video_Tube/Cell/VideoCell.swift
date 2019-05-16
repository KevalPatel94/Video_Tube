//
//  VideoCell.swift
//  Video_Tube
//
//  Created by Keval Patel on 5/14/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit
import YouTubePlayer
import SDWebImage
class VideoCell: UITableViewCell {
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewYTPlayer: YouTubePlayerView!
    @IBOutlet weak var imgViewThumbnail: UIImageView!
    var videoViewModel : VideoViewModel!{
        didSet{
            lblTitle.text = "\(videoViewModel.videoTitle)"
            profileImageViewConfiguration()
            thumbnailImageViewConfiguration()
            loadVideo()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        imgViewProfile.layer.cornerRadius = self.imgViewProfile.frame.height/2
        imgViewProfile.layer.masksToBounds = true
        viewYTPlayer.layer.cornerRadius = 8.0
        viewYTPlayer.layer.masksToBounds = true
        imgViewThumbnail.layer.cornerRadius = 8.0
        imgViewThumbnail.layer.masksToBounds = true
    }

    //MARK: - imageViewProperties
    func profileImageViewConfiguration(){
        DispatchQueue.global(qos: .utility).async {
            self.imgViewProfile.sd_setImage(with: URL(string: self.videoViewModel?.profileImageUrlString ?? ""), placeholderImage:UIImage(named: "VideoPlaceHolder"), options: .refreshCached, completed: {[weak self] (image, err, cache, url) in
                    DispatchQueue.main.async {
                        if image != nil{
                            self?.imgViewProfile.image = image
                        }
                    }
            })
        }
    }
    //MARK: - imageViewProperties
    func thumbnailImageViewConfiguration(){
        DispatchQueue.global(qos: .utility).async {
            self.imgViewThumbnail.sd_setImage(with: URL(string: self.videoViewModel?.thumbImageUrlString ?? ""), placeholderImage:UIImage(named: "VideoPlaceHolder"), options: .refreshCached, completed: {[weak self] (image, err, cache, url) in
                DispatchQueue.main.async {
                    if image != nil{
                        self?.imgViewThumbnail.image = image
                    }
                }
            })
        }
    }
    //MARK: - loadVideo
    /**
     This method load the video in]side the floatinWindow and will play after loading it
     
     - Parameter : *videoViewModel*
     */
    func loadVideo() {
        viewYTPlayer.playerVars = ["playsinline" : 1] as YouTubePlayerView.YouTubePlayerParameters
        viewYTPlayer.loadVideoID("\(videoViewModel.videoId)")
        viewYTPlayer.isHidden = true
        imgViewThumbnail.isHidden = false
    }
    //MARK: - configureFloatinWindow
    func playVideo(){
        videoViewModel.isPlaying = true
        viewYTPlayer.isHidden = false
        imgViewThumbnail.isHidden = true
        viewYTPlayer.play()
    }
    
}
