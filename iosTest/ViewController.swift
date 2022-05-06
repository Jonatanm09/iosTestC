//
//  ViewController.swift
//  iosTest
//
//  Created by Jonatan Mendez on 5/5/22.
//

import UIKit
import ProgressHUD
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searcbBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Vars
    var users: [Users] = []
    var filteredUsers: [Users]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searcbBar.delegate = self
        getUsers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users_info_cell") as! UsersTableViewCell
        cell.titleLbl.text = users[indexPath.row].name
        cell.phoneLbl.text = users[indexPath.row].phoneNumber
        cell.emailLbl.text = users[indexPath.row].email
        
        cell.showPosts = {
            self.performSegue(withIdentifier: "goToPosts", sender: self)
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredUsers = searchText.isEmpty ? self.users :
        self.users.filter({(contactSearch: Users) -> Bool in
            return contactSearch.name.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func getUsers(){
                
        AF.request("https://jsonplaceholder.typicode.com/users", method: .get, encoding: URLEncoding.queryString)
            .validate()
            .responseJSON { response in
                
                switch (response.result) {
                    
                case .success( _):
                    
                    do {
                        self.users = try JSONDecoder().decode([Users].self, from: response.data!)
                        
                        self.tableView.reloadData()
                        
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                }
                
            }
        
    }
    
}


