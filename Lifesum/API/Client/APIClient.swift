//
//  APIClient.swift
//  Lifesum
//
//  Created by Agon Mati on 2022-05-02.
//

import Foundation
import UIKit

// MARK: - HTTP Methods

enum HttpMethod: String {
    case GET
    case DELETE
    case POST
    case PUT
    case PATCH
}

// MARK: - Custom Error

enum HttpError: Error, Equatable {
    case url
    case unknown
    case noData
    case parsing(String)
    case request
    case message(String)
    static func == (lhs: HttpError, rhs: HttpError) -> Bool {
        switch (lhs, rhs) {
        case (.url, .url):
            return true
        case (.unknown, .unknown):
            return true
        case (.noData, .noData):
            return true
        case (.parsing(_), .parsing(_)):
            return true
        case (.request, .request):
            return true
        case let (.message(left), .message(right)):
            return left == right
        default:
            return false
        }
    }
}

// MARK: - Custom Request result

enum Result<T> {
    case failed(HttpError)
    case successful(T?)
}

protocol HttpClientProtocol {
    func request<T: Decodable>(baseUrl: String,
                               endpoint: String,
                               httpMethod: HttpMethod,
                               returnType: T.Type,
                               onCompletion: @escaping (Result<T>) -> Void)

    func invalidate()
}

class APIClient: NSObject, HttpClientProtocol {
    private var task: URLSessionDataTaskProtocol?
    private var urlSession: URLSessionProtocol?
    override convenience init() {
        self.init(session: URLSession.shared)
    }

    init(session: URLSessionProtocol) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 360.0
        config.timeoutIntervalForResource = 360.0
        super.init()
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
    }

    func invalidate() {
        task?.cancel()
    }

    // MARK: - Request Interface Implementation

    func request<T>(baseUrl: String, endpoint: String, httpMethod: HttpMethod, returnType: T.Type, onCompletion: @escaping (Result<T>) -> Void) where T: Decodable {
        createRequest(baseUrl: baseUrl, endpoint: endpoint, httpMethod: httpMethod) { result in
            switch result {
            case let .successful(request):
                self.request(request: request, returnType: returnType, onCompletion: onCompletion)
            case .failed:
                onCompletion(.failed(.request))
            }
        }
    }

    // MARK: - Request calling

    private func request<G: Decodable>(request: URLRequest?, returnType: G.Type, onCompletion: @escaping (Result<G>) -> Void) {
        guard let request = request else {
            onCompletion(.failed(.request))
            return
        }
        task = urlSession?.customDataTask(with: request) { (data, _, error) -> Void in
            guard error == nil else {
                onCompletion(.failed(.message(error?.localizedDescription ?? "")))
                return
            }
            guard let responseData = data else {
                onCompletion(.failed(.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let returnValue = try decoder.decode(returnType, from: responseData)
                onCompletion(.successful(returnValue))
            } catch let error {
                onCompletion(.failed(.parsing(error.localizedDescription)))
            }
        }
        task?.resume()
    }

    // MARK: - Request creation

    fileprivate func createRequest(baseUrl: String,
                                   endpoint: String,
                                   queryParams: [URLQueryItem]? = nil,
                                   httpMethod: HttpMethod,
                                   onCompletion: @escaping (Result<URLRequest>) -> Void) {
        guard let escapedAddress = endpoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: baseUrl + escapedAddress) else {
            onCompletion(.failed(.url))
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Constants.Api.authenticationKey, forHTTPHeaderField: "Authorization")

        onCompletion(.successful(request))
    }
}

extension APIClient: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
