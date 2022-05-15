//
//  ViewController.swift
//  iosTest
//
//  Created by Jonatan Mendez on 5/5/22.
//

import UIKit
import ProgressHUD
import Alamofire
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var postsSegue = "goToPosts"
    var url = "https://jsonplaceholder.typicode.com/users"
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    
    @IBOutlet weak var searcbBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Vars
    var allUsers : [Users]?
    var fetchUsers =  [User] ()
    var filteredUsers = [Users]()
    var selectedUser  = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searcbBar.delegate = self
        fetchData()
    }
    
    func fetchData(){
        ProgressHUD.show()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count == 0 || results == nil {
                getUsers()
            } else{
                for data in results as! [Users]{
                    self.filteredUsers.append(data)
                    allUsers = filteredUsers
                    
                }
                ProgressHUD.dismiss()
            }
            
        } catch {
            print("ERROR")
        }
    }
    
    func saveData()
    {
        for user in self.fetchUsers {
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
            newUser.setValue(user.id, forKey: "id")
            newUser.setValue(user.name, forKey: "name")
            newUser.setValue(user.phoneNumber, forKey: "phoneNumber")
            newUser.setValue(user.email, forKey: "email")
            self.filteredUsers.append(newUser as! Users)
            allUsers = filteredUsers
        }
        do {
            try context.save()
            print("Data Saved")
        } catch {
            print("Storing data Failed")
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredUsers.count > 0 ? self.filteredUsers.count : 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == postsSegue {
            if let destVC = segue.destination as? PostsViewController {
                destVC.userID = selectedUser.id
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "users_info_cell") as! UsersTableViewCell
        let user = filteredUsers[indexPath.row]
        
        cell.titleLbl.text = user.name
        cell.phoneLbl.text =  user.phoneNumber
        cell.emailLbl.text =   user.email
        
        cell.showPosts = {
            self.selectedUser = user
            self.performSegue(withIdentifier: self.postsSegue, sender: self)
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredUsers = searchText.isEmpty ? self.allUsers! :
        self.allUsers!.filter({(userSearch: Users) -> Bool in
            return userSearch.name!.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func getUsers(){
        AF.request(url, method: .get, encoding: URLEncoding.queryString)
            .validate()
            .responseJSON { response in
                switch (response.result) {
                case .success( _):
                    do {
                        self.fetchUsers = try JSONDecoder().decode([User].self, from: response.data!)
                        self.saveData()
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


