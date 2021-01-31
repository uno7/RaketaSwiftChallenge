//
//  ViewController.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 27.01.2021.
//

import UIKit

class TopPostsViewController: BaseViewController {
    
    var post:PostChildrenEntity?
    
    //MARK:- Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var viewModel:TopPostsViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
        setTableView()
        showActivityIndicator()
        setRefreshControl()
        setViewModel()
    }
    
    //MARK:- private properties
    private let tableViewRefreshControl = UIRefreshControl()
    
    //MARK:- private methods
    private func setUi(){
        self.navigationItem.title = "Top Posts"
    }
    
    private func setViewModel(){
        viewModel = TopPostsViewModel(delegate: self)
        viewModel.fetchPosts(isRefresh: false)
    }
    
    private func setTableView (){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.registerCell(reuseID: PostTableViewCell.identifier, isXib: true)
        
    }
    
    private func showActivityIndicator(){
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
    }
    
    private func stopActivityIndicator () {
        self.activityIndicatorView.stopExecutionOnAMainThread()
        activityIndicatorView.isHidden = true
    }
    
    private func setRefreshControl() {
        tableView.refreshControl = tableViewRefreshControl
        tableView.refreshControl?.addTarget(
            self,
            action: #selector(startPullToRefresh),
            for: .valueChanged
        )
    }

    // MARK: - Actions
    @objc private func startPullToRefresh() {
        viewModel.fetchPosts(isRefresh: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "PostVCToImageDetailsVCSegue" else { return }
        guard let destination = segue.destination as? ImageDetailsViewController else { return }
        destination.imageUrl = post?.imageUrl
    }

}

//MARK:- TableView

extension TopPostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.delegate = self
        if let data = viewModel.item(at: indexPath){
            cell.applyData(data: data)
        }else{
            cell.reset()
        }
        return cell
    }
}

extension TopPostsViewController: TopPostsViewModelDelegate {
    func topPostsViewModelSuccessNeedToReload(){
        stopActivityIndicator()
        tableViewRefreshControl.endRefreshing()
        tableView.reloadData()
        
    }
    func topPostsViewModelOnFetchFailed(with reason: String){
        stopActivityIndicator()
        tableViewRefreshControl.endRefreshing()
        let title = "Error".localizedString
        let okAction = UIAlertAction(title: "OK".localizedString, style: .default)
        showAlert(title: title, message: reason, actions: [okAction])
    }
}

extension TopPostsViewController : PostTableViewCellDelegate {
    func postCellThumbnailTapped(cell: PostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        post = viewModel.item(at: indexPath)
        guard let _ = post?.imageUrl else {
            let title = "Error".localizedString
            let okAction = UIAlertAction(title: "OK".localizedString, style: .default)
            showAlert(title: title, message: "You can't to download this image", actions: [okAction])
            return
        }
        performSegue(withIdentifier: "PostVCToImageDetailsVCSegue", sender: self)
    }
    

}

