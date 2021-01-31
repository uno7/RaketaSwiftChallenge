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
    private var isLoading = false
    
    init(delegate:TopPostsViewModelDelegate) {
        self.delegate = delegate;
        totalCount = 0
        posts = []
    }
    
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
        if isRefresh {
            nextID = ""
            self.posts.removeAll()
            totalCount = 0
        }
        networkService.getTopPosts(nextID: nextID) {
           [weak self]  (result) in
            guard let strongSelf = self else {return}
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
    
}
