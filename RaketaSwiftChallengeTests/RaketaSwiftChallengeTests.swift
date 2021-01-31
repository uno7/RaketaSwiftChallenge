//
//  RaketaSwiftChallengeTests.swift
//  RaketaSwiftChallengeTests
//
//  Created by vhlohov on 27.01.2021.
//

import XCTest
@testable import RaketaSwiftChallenge

class NetworkServiceTests: XCTestCase {
   
    func test_validResourceExists_success() {
        let service = NetworkService()
        let expectation = self.expectation(description: "resource")
        var resourceData: GetPostsResponse?
        var resourceError: Error?
        let request = MockRequest(url: URL(string: "https://www.reddit.com/top.json")!)
        service.getTopPosts(request: request) { (result) in
            switch result {
            case .success(let response):
                resourceData = response
            case .failure(let error):
                resourceError = error
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNil(resourceError)
        XCTAssertNotNil(resourceData)
    }
    
    func test_validResourceExists_fail() {
        let service = NetworkService()
        let expectation = self.expectation(description: "resource")
        var resourceData: GetPostsResponse?
        var resourceError: Error?
        let request = MockRequest(url: URL(string: "https://www.reddit.com/wrongUrl.json")!)
        service.getTopPosts(request: request) { (result) in
            switch result {
            case .success(let data):
                resourceData = data
            case .failure(let error):
                resourceError = error
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertNil(resourceData)
        XCTAssertNotNil(resourceError)
    }
}

private struct MockRequest: Request {
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    var url: URL
}



