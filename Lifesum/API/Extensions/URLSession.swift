//
//  URLSession.swift
//  Lifesum
//
//  Created by Agon Mati on 2022-05-02.
//

import Foundation

extension URLSession: URLSessionProtocol {
    func customDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        // The double casting is necessary because both methods have the same name and the compiler gets lost
        return ((dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol)
    }

    func invalidateAllRequests() {
        invalidateAndCancel()
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
