//
//  UsersTableViewCell.swift
//  iosTest
//
//  Created by Jonatan Mendez on 5/5/22.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    
    var showPosts: (() -> Void)?
    
    
    
    @IBAction func viewPostsPressed(_ sender: Any) {
        self.showPosts?()
    }
}

