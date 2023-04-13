//
//  UserData.swift
//  SwiftUITestDemo
//
//  Created by 郭杰智 on 2023/4/6.
//

import Foundation
import Combine

class UserData: ObservableObject {
    @Published var recommendPostList: PostList = PostList(list: [])
    @Published var isRefreshing: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var loadingError: Error?
    @Published var reloadData: Bool = false
    
    private var recommendPostDic: [Int: Int] = [:] // id: index
    private var hotPostDic: [Int: Int] = [:] // id: index
}

enum PostListCategory {
    case recommend
}

extension UserData {
    static let testData: UserData = {
        let data = UserData()
        data.handleRefreshPostList(loadPostListData("PostListData_recommend_1.json"), for: .recommend)
        return data
    }()
    
    var showLoadingError: Bool { loadingError != nil }
    var loadingErrorText: String { loadingError?.localizedDescription ?? "" }
    
    func postList(for category: PostListCategory) -> PostList {
        switch category {
        case .recommend: return recommendPostList
        }
    }
    
    func loadPostListIfNeeded(for category: PostListCategory) {
        if postList(for: category).list.isEmpty {
            refreshPostList(for: category)
        }
    }
    
    func refreshPostList(for category: PostListCategory) {
        let completion: (Result<PostList, Error>) -> Void = { result in
            switch result {
            case let .success(list): self.handleRefreshPostList(list, for: category)
            case let .failure(error): self.handleLoadingError(error)
            }
            self.isRefreshing = false
        }
        switch category {
        case .recommend: NetworkAPI.recommendPostList(completion: completion)
        }
    }
    
    func loadMorePostList(for category: PostListCategory) {
        // Do not load more if list count > 10
        if isLoadingMore || postList(for: category).list.count > 10 { return }
        isLoadingMore = true
        
        // Load different category post list data for convenience
        let completion: (Result<PostList, Error>) -> Void = { result in
            switch result {
            case let .success(list): self.handleLoadMorePostList(list, for: category)
            case let .failure(error): self.handleLoadingError(error)
            }
            self.isLoadingMore = false
        }
        switch category {
        case .recommend: NetworkAPI.hotPostList(completion: completion)
        }
    }
    
    private func handleRefreshPostList(_ list: PostList, for category: PostListCategory) {
        var tempList: [Post] = []
        var tempDic: [Int: Int] = [:]
        for (index, post) in list.list.enumerated() {
            if tempDic[post.id] != nil { continue }
            tempList.append(post)
            tempDic[post.id] = index
            update(post)
        }
        switch category {
        case .recommend:
            recommendPostList.list = tempList
            recommendPostDic = tempDic
        }
        reloadData = true
    }
    
    private func handleLoadMorePostList(_ list: PostList, for category: PostListCategory) {
        switch category {
        case .recommend:
            for post in list.list {
                update(post)
                if recommendPostDic[post.id] != nil { continue }
                recommendPostList.list.append(post)
                recommendPostDic[post.id] = recommendPostList.list.count - 1
            }
        }
    }
    
    private func handleLoadingError(_ error: Error) {
        loadingError = error
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.loadingError = nil
        }
    }
    
    func post(forId id: Int) -> Post? {
        if let index = recommendPostDic[id] {
            return recommendPostList.list[index]
        }
        return nil
    }
    
    func update(_ post: Post) {
        if let index = recommendPostDic[post.id] {
            recommendPostList.list[index] = post
        }
    }
}
