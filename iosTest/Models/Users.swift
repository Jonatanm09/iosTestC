//
//  Users.swift
//  iosTest
//
//  Created by Jonatan Mendez on 5/5/22.
//

import UIKit

struct Users: Decodable {
    var id: Int?
    var name: String?
    var phoneNumber: String?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
      case name = "name"
      case phoneNumber = "phone"
      case email = "email"
    }
}
