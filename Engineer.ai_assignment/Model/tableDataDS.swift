//
//  tableDataDS.swift
//  Engineer.ai_assignment
//
//  Created by Ranjeet on 15/01/20.
//  Copyright © 2020 Ranjeet. All rights reserved.
//

import UIKit


class tableDataDS: Codable {
    
    var created_at:String = ""
    var title:String = ""
    var url:String = ""
    var points:Int = 0
    var story_text:String = ""
    var comment_text:String = ""
    var num_comments:Int = 0
    var story_id:Int = 0
    var story_title:String = ""
    var story_url:String = ""
    var parent_id:Int = 0
    var created_at_i:Int = 0
    var _tags:NSArray = NSArray()
    var objectID:Int = 0
    var _highlightResult:NSDictionary = NSDictionary()
    var status:Bool = false

    private enum CodingKeys:String,CodingKey
    {
        case created_at,title
    }
}


