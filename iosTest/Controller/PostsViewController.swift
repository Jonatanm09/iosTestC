//
//  PostsViewController.swift
//  iosTest
//
//  Created by Jonatan Mendez on 6/5/22.
//

import UIKit
import ProgressHUD
import Alamofire
import CoreData

class PostsViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    var posts: [Post] = []
    var allPosts = [Posts]()
    var userID: Int64 = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        fetchData()
        super.viewDidLoad()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell") as! PostsTableViewCell
        cell.titleLbl.text = allPosts[indexPath.row].title
        cell.bodyTextView.text = allPosts[indexPath.row].body
        
        return cell
    }
    
    func getPostsForUser(userID: Int64){
        
        ProgressHUD.show()
        
        AF.request("https://jsonplaceholder.typicode.com/posts", method: .get, encoding: URLEncoding.queryString)
            .validate()
            .responseJSON { response in
                switch (response.result) {
                case .success( _):
                    
                    do {
                        self.posts = try JSONDecoder().decode([Post].self, from: response.data!)
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
    
    func saveData()
    {
        for post in self.posts {
            let newPost = NSEntityDescription.insertNewObject(forEntityName: "Posts", into: context)
            newPost.setValue(post.userId, forKey: "userId")
            newPost.setValue(post.title, forKey: "title")
            newPost.setValue(post.body, forKey: "body")
            allPosts.append(newPost as! Posts)
        }
        do {
            try context.save()
            print("Data Saved")
        } catch {
            print("Storing data Failed")
        }
    }
    
    
    func fetchData(){
        ProgressHUD.show()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Posts")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count == 0 || results == nil {
                getPostsForUser(userID: userID)
            } else{
                for data in results as! [Posts]{
                    if data.userId == userID {
                        allPosts.append(data)
                        self.tableView.reloadData()
                    }
                    
                }
                ProgressHUD.dismiss()
            }
            
        } catch {
            print("ERROR")
        }
    }
    
}
