//
//  ViewController.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 27.01.2021.
//

import UIKit

class TopPostsViewController: BaseViewController {
    
    //MARK:- Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    weak var coordinator:MainCoordinator?
 
    //MARK:-restoration app properties
    
    var restorationInfo: [AnyHashable: Any]?
    var didFirstWillLayout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
        setTableView()
        showActivityIndicator()
        setRefreshControl()
        setViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.userActivity = self.view.window?.windowScene?.userActivity
        self.restorationInfo = nil
    }
    //MARK:- restoration method (responsible for creating the view hierarchy in both normal and restore cases)
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if didFirstWillLayout { return }
        didFirstWillLayout = true
        let key = ImageDetailsViewController.restorationKey
        let info = self.restorationInfo
        if let editing = info?[key] as? Bool, editing {
            guard let imageUrl = (info?["imageUrl"]) as? String else {
                return
            }
            self.userActivity?.addUserInfoEntries(from: [key: false])
            coordinator?.transitonToImageDetailsViewController(imageUrl:imageUrl)
        }
    }
    
    //MARK:- private properties
    
    private var viewModel:TopPostsViewModel!
    private let tableViewRefreshControl = UIRefreshControl()
    
    //MARK:- private methods
    private func setUi(){
        self.navigationItem.title = "Reddit Posts"
    }
    
    private func setViewModel(){
        viewModel = TopPostsViewModel(delegate: self)
        viewModel.getPostsWithRestorationState(restorationInfo:self.restorationInfo)
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
        if !viewModel.isLoading{
            viewModel.fetchPosts(isRefresh: true)
            return
        }
        let okAction = UIAlertAction(title: "OK".localizedString, style: .default)
        showAlert(title: "Error".localizedString,
                  message: "You can't to do pull to refresh during downloading next pages ",
                  actions: [okAction])
        
    }
    
    //MARK:- user activity
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        super.updateUserActivityState(activity)
        if viewModel.returnPosts().isEmpty {
            return
        }
        var indexPathRow = 0
        if let visible = tableView.indexPathsForVisibleRows,
           !visible.isEmpty {
            let indexPath =  visible[0]
            indexPathRow = indexPath.row
        }

        let post = viewModel.returnPost(at: indexPathRow)
        activity.addUserInfoEntries(from: ["postId": post?.name as Any])
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
        let okAction = UIAlertAction(title: "OK".localizedString, style: .default)
        showAlert(title: "Error".localizedString,
                  message: reason,
                  actions: [okAction])
    }
}

extension TopPostsViewController : PostTableViewCellDelegate {
    func postCellThumbnailTapped(cell: PostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = viewModel.item(at: indexPath)
        guard let imageUrl = post?.imageUrl else {
            let okAction = UIAlertAction(title: "OK".localizedString, style: .default)
            showAlert(title: "Error".localizedString,
                      message: "You can't to download this image",
                      actions: [okAction])
            return
        }
        self.userActivity?.addUserInfoEntries(from: ["postId": post?.name as Any])
        coordinator?.transitonToImageDetailsViewController(imageUrl:imageUrl)
    }
    

}

