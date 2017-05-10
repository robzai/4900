//
//  Story.swift
//  4900
//
//  Created by Laura Yang on 2017-05-07.
//  Copyright © 2017 leo  luo. All rights reserved.
//

import UIKit

class Story{

    var storyTitle: String?
    var storyDate: String?
    var storyContents: String?
    var storyImageName: String?

    init(storyTitle: String, storyDate: String, storyContents: String, storyImageName: String){
        self.storyTitle = storyTitle
        self.storyDate = storyDate
        self.storyContents = storyContents
        self.storyImageName = storyImageName
    }
    
    convenience init(copies story: Story){
        self.init(storyTitle: story.storyTitle!, storyDate: story.storyDate!,
                  storyContents: story.storyContents!, storyImageName: story.storyImageName!)
    }
    
}
