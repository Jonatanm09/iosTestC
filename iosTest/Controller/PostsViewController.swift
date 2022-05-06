//
//  PostsViewController.swift
//  iosTest
//
//  Created by Jonatan Mendez on 6/5/22.
//

import UIKit
import ProgressHUD
import Alamofire

class PostsViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [Posts] = []
    var userID: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        getPostsForUser(userID: userID)
        super.viewDidLoad()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell") as! PostsTableViewCell
        cell.titleLbl.text = posts[indexPath.row].title
        cell.bodyTextView.text = posts[indexPath.row].description
        
        return cell
    }
    
    func getPostsForUser(userID: Int){
        
        ProgressHUD.show()
        
        AF.request("https://jsonplaceholder.typicode.com/posts?userId=\(userID)", method: .get, encoding: URLEncoding.queryString)
            .validate()
            .responseJSON { response in
                switch (response.result) {
                case .success( _):
                    
                    do {
                        self.posts = try JSONDecoder().decode([Posts].self, from: response.data!)
                        
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
