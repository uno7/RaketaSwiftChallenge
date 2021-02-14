//
//  TopPostsViewModel.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 30.01.2021.
//

import Foundation

protocol TopPostsViewModelDelegate: class {
  func topPostsViewModelSuccessNeedToReload()
  func topPostsViewModelOnFetchFailed(with reason: String)
}

final class TopPostsViewModel{
    private weak var delegate: TopPostsViewModelDelegate?
    private let networkService = NetworkService ()
    private var posts = [PostChildren]()
    private var nextID = ""
    private var totalCount = 0
    var isLoading = false
    
    init(delegate:TopPostsViewModelDelegate) {
        self.delegate = delegate;
        totalCount = 0
        posts = []
    }
    
    // MARK: - Accessors
    
    var postsCount:Int{
        return totalCount
    }
    
    func item(at indexPath: IndexPath) -> PostChildrenEntity? {
        if indexPath.row < posts.count{
            return posts[indexPath.row].data
        }
        prefetchItemAtIndex(indexPaths: [indexPath])
        return nil
    }
    
    func prefetchItemAtIndex(indexPaths: [IndexPath]) {
        if indexPaths.isEmpty {
            return
        }
        let max = indexPaths.max()!.row
        if max < posts.count {
            return
        }
        if totalCount > max && nextID != "" {
            fetchPosts(isRefresh: false)
        }
    }
    
    func fetchPosts(isRefresh:Bool)  {
        if isRefresh{
            nextID = ""
            self.posts.removeAll()
            totalCount = 0
        }
        isLoading = true;
        networkService.getTopPosts(request:TopPostsRequest(nextID: nextID)){
           [weak self]  (result) in
            guard let strongSelf = self else {return}
            strongSelf.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    strongSelf.posts.append(contentsOf: response.data.children)
                    strongSelf.totalCount = strongSelf.posts.count + 1
                    strongSelf.nextID = response.data.after ?? ""
                    strongSelf.delegate?.topPostsViewModelSuccessNeedToReload()
                }
            case .failure (let error):
                DispatchQueue.main.async {
                    self?.delegate?.topPostsViewModelOnFetchFailed(with: error.reason)
                }

            }
            
        }
    }
    
    //MARK:- restoration Accessors
    func returnPosts() -> [PostChildren] {
        let items = posts
        return items
    }
    
    func returnPost(at index:Int) -> PostChildrenEntity? {
        return posts[index].data
    }
    
    func getPostsWithRestorationState(restorationInfo: [AnyHashable: Any]?) {
        var postId = ""
        if let info = restorationInfo,
           let localPostId = info["postId"] as? String  {
            postId = localPostId
        }
        self.nextID = postId
        self.fetchPosts(isRefresh: false)
    }
}
