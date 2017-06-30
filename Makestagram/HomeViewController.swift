//
//  HomeViewController.swift
//  Makestagram
//
//  Created by Fernando on 6/26/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    // MARK: - VC Lifecycle
    
    @IBOutlet weak var timelineTableView: UITableView!
    
    // MARK: - Properties
    var posts = [Post]()
    let refreshControl = UIRefreshControl()
    
    let paginationHelper = MGPaginationHelper<Post>(serviceMethod: UserService.timeline)
    
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        reloadTimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView(){
        timelineTableView.tableFooterView = UIView()
        timelineTableView.separatorStyle = .none
        
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        timelineTableView.addSubview(refreshControl)
    }
    
    func reloadTimeline(){
        self.paginationHelper.reloadData { [unowned self] (posts) in
            self.posts = posts
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            self.timelineTableView.reloadData()
        }
    }

}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        switch indexPath.row {
        case 0:
            let cell: PostHeaderCell = timelineTableView.dequeueReusableCell()
            cell.usernameLabel.text = post.poster.username
            
            return cell
            
        case 1:
            let cell: PostImageCell = timelineTableView.dequeueReusableCell()
            let imageURL = URL(string: post.imageUrl!)
            cell.postImageview.kf.setImage(with: imageURL)
            
            return cell
        
        case 2:
            let cell: PostActionCell = timelineTableView.dequeueReusableCell()
            cell.delegate = self
            configureCell(cell, with: post)
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section >= posts.count - 1 {
            paginationHelper.paginate(completion: { [unowned self] (posts) in
                self.posts.append(contentsOf: posts)
                
                DispatchQueue.main.async {
                    self.timelineTableView.reloadData()
                }
            })
        }
    }
    
    func configureCell(_ cell: PostActionCell, with post: Post){
        cell.timestampLabel.text = timestampFormatter.string(from: post.creationDate)
        print(post.isLiked)
        cell.likeButton.isSelected = post.isLiked
        cell.likesLabel.text = "\(post.likeCount) likes"
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height
            
        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight
            
        case 2:
            return PostActionCell.height
            
        default:
            fatalError("Error: unexpected height.")
        }

        
        
    }
}

extension HomeViewController: PostActionCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {
        
        // 1: First we make sure that an index path exists for the the given cell. We'll need the index path of the cell later on to reference the correct post.
        guard let indexPath = timelineTableView.indexPath(for: cell)
            else {return}
        
        // 2: Set the isUserInteractionEnabled property of the UIButton to false so the user doesn't accidentally send multiple requests by tapping too quickly.
        likeButton.isUserInteractionEnabled = false
        
        // 3: Reference the correct post corresponding with the PostActionCell that the user tapped.
        let post = posts[indexPath.section]
        
        var counter = 0
        
        // 4: Use our LikeService to like or unlike the post based on the isLiked property.
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
            
            // 5: Use defer to set isUserInteractionEnabled to true whenever the closure returns.
            defer {
                likeButton.isUserInteractionEnabled = true
            }
            
            // 6: Basic error handling if something goes wrong with our network request.
            guard success else {return}
            
            // 7: Change the likeCount and isLiked properties of our post if our network request was successful.
            if counter == 0 {
                post.likeCount += !post.isLiked ? 1 : -1
                post.isLiked = !post.isLiked
            }
            
            
            // 8: Get a reference to the current cell.
            guard let cell = self.timelineTableView.cellForRow(at: indexPath) as? PostActionCell
                else {return}
            
            // 9: Update the UI of the cell on the main thread. Remember that all UI updates must happen on the main thread.
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
            
            counter += 1
        }
    }
}
