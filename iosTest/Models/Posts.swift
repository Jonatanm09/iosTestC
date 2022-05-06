//
//  Posts.swift
//  iosTest
//
//  Created by Jonatan Mendez on 5/5/22.
//

import UIKit

struct Posts: Decodable {
    var title: String
    var description : String
    
    enum CodingKeys: String, CodingKey {
    case title = "title"
    case  description = "body"
    }

}
