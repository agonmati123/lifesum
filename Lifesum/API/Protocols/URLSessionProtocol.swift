//
//  URLSessionProtocol.swift
//  Lifesum
//
//  Created by Agon Mati on 2022-05-02.
//

import Foundation
import UIKit

protocol URLSessionProtocol {
    func customDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
    func invalidateAllRequests()
}
