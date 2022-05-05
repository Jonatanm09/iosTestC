//
//  ViewController.swift
//  iosTest
//
//  Created by Jonatan Mendez on 5/5/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users_info_cell") as! UsersTableViewCell
        cell.showPosts = {
            self.performSegue(withIdentifier: "goToPosts", sender: self)
        }
        return cell
    }
    

}

