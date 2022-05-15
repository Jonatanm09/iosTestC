//
//  Posts.swift
//  iosTest
//
//  Created by Jonatan Mendez on 5/5/22.
//

import UIKit

struct Post: Decodable {
    var userId: Int
    var title: String
    var description : String
    
    enum CodingKeys: String, CodingKey {
    case userId = "userId"
    case title = "title"
    case  description = "body"
    }

}
