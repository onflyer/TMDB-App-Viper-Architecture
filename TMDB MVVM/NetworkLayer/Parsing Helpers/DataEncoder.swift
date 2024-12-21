//
//  DataEncoder.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/13/24.
//

import Foundation

public protocol DataEncoder {
    func encode<T: Encodable>(value: T) throws -> Data
}

public class DefaultDataEncoder: DataEncoder {
    private var jsonEncoder: JSONEncoder
    init(jsonEncoder: JSONEncoder = JSONEncoder()) {
        self.jsonEncoder = jsonEncoder
//        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    public func encode<T: Encodable>(value: T) throws -> Data {
        return try jsonEncoder.encode(value)
    }
}
