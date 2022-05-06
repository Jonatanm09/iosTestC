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
    
    var postsSegue = "goToPosts"
    var url = "https://jsonplaceholder.typicode.com/users"
    
    @IBOutlet weak var searcbBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Vars
    var users: [Users] = []
    var filteredUsers: [Users] = []
    var selectedUser : Users!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searcbBar.delegate = self
        getUsers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == postsSegue {
            if let destVC = segue.destination as? PostsViewController {
                destVC.userID = selectedUser.id!
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users_info_cell") as! UsersTableViewCell
        cell.titleLbl.text = filteredUsers[indexPath.row].name
        cell.phoneLbl.text = filteredUsers[indexPath.row].phoneNumber
        cell.emailLbl.text = filteredUsers[indexPath.row].email
        
        cell.showPosts = {
            self.selectedUser = self.filteredUsers[indexPath.row]
            self.performSegue(withIdentifier: self.postsSegue, sender: self)
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredUsers = searchText.isEmpty ? self.users :
        self.users.filter({(userSearch: Users) -> Bool in
            return userSearch.name!.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func getUsers(){
        ProgressHUD.show()
        AF.request(url, method: .get, encoding: URLEncoding.queryString)
            .validate()
            .responseJSON { response in
                switch (response.result) {
                case .success( _):
                    do {
                        self.users = try JSONDecoder().decode([Users].self, from: response.data!)
                        self.filteredUsers = self.users
                        
                        self.tableView.reloadData()
                        
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                }
                ProgressHUD.dismiss()
            }
    }
    
}


