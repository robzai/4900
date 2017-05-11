//
//  Story.swift
//  4900
//
//  Created by Laura Yang on 2017-05-07.
//  Copyright © 2017 leo  luo. All rights reserved.
//

class Story{
    
    var reason: String?
    var action: String?
    var group: String?
    var story: String?
    var imgs: String?
    var video: String?
    var postTime: Int?

    init(reason: String, action: String, group: String, story: String, imgs: String, video: String, postTime: Int){
        self.reason = reason
        self.action = action
        self.group = group
        self.story = story
        self.imgs = imgs
        self.video = video
        self.postTime = postTime
    }
    
}
