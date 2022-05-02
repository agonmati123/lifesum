//
//  LifesumTests.swift
//  LifesumTests
//
//  Created by Agon Mati on 2022-05-02.
//

@testable import Lifesum
import XCTest
class HttpClientMock: HttpClientProtocol {
    func request<T: Decodable>(baseUrl: String, endpoint: String, httpMethod: HttpMethod, returnType: T.Type, onCompletion: @escaping (Result<T>) -> Void) {
        guard let data = mockData else {
            onCompletion(.failed(.noData))
            return
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let returnValue = try decoder.decode(returnType, from: data)
            onCompletion(.successful(returnValue))
        } catch let error {
            onCompletion(.failed(.parsing(error.localizedDescription)))
        }
    }

    func invalidate() {
    }

    var mockData: Data?
}

class LifesumTests: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testParsingFailed() {
        let httpClientMock = HttpClientMock()

        httpClientMock.mockData = Data()
        httpClientMock.request(baseUrl: "", endpoint: "", httpMethod: .GET, returnType: FoodItem.self) {
            result in
            XCTAssertEqual(result, .failed(.parsing("")))
        }

        let foodItem = FoodItem(title: "", calories: 1, carbs: 1.2, protein: 1.2, fat: 1.2, saturatedfat: 1.2, unsaturatedfat: 1.2, fiber: 1.1, cholesterol: 1.2, sugar: 1.1, sodium: 1.1, potassium: 1.1, gramsperserving: 1.1, pcstext: "")
        let request = ResponseControl<FoodItem>(response: foodItem)

        do {
            let data = try JSONEncoder().encode(request)
            httpClientMock.mockData = data
            httpClientMock.request(baseUrl: "", endpoint: "", httpMethod: .GET, returnType: FoodItem.self) {
                result in
                XCTAssertEqual(result, .failed(.parsing("")))
            }
        } catch {
            XCTFail("Error encoding")
        }
    }

    func testNoData() {
        let httpClientMock = HttpClientMock()
        httpClientMock.mockData = nil
        httpClientMock.request(baseUrl: "", endpoint: "", httpMethod: .GET, returnType: FoodItem.self) {
            result in
            XCTAssertEqual(result, .failed(.noData))
        }
    }

    func testSuccessfullData() {
        let httpClientMock = HttpClientMock()

        let foodItem = FoodItem(title: "", calories: 1, carbs: 1.2, protein: 1.2, fat: 1.2, saturatedfat: 1.2, unsaturatedfat: 1.2, fiber: 1.1, cholesterol: 1.2, sugar: 1.1, sodium: 1.1, potassium: 1.1, gramsperserving: 1.1, pcstext: "")
        let request = ResponseControl<FoodItem>(response: foodItem)

        do {
            let data = try JSONEncoder().encode(request)
            httpClientMock.mockData = data
            httpClientMock.request(baseUrl: "", endpoint: "", httpMethod: .GET, returnType: ResponseControl<FoodItem>.self) {
                result in
                XCTAssertEqual(result, .successful(request))
            }
        } catch {
            XCTFail("Error encoding")
        }
    }
}

extension Result: Equatable {
    public static func == (lhs: Result<T>, rhs: Result<T>) -> Bool {
        switch (lhs, rhs) {
        case (.successful(_), .successful(_)):
            return true
        case let (.failed(left), .failed(right)):
            return left == right
        default:
            return false
        }
    }
}
