//
//  URLComponentsMock.swift
//  TMDB AppTests
//
//  Created by Aleksandar Milidrag on 4/20/24.
//

import Foundation
@testable import TMDB_VIPER

class URLComponentsMock: URLComponentsProtocol {
    
    var path: String = "https://mock.test.com"
    var httpMethod: HTTPMethod
    var headers: [String : String] = [:]
    var params: [String : Any] = [:]
    var urlParams: [String : String?] = [:]
    
    init(httpMethod: HTTPMethod) {
        self.httpMethod = httpMethod
    }
    
  
}
