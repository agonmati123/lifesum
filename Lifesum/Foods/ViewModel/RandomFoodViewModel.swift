//
//  FoodViewModel.swift
//  Lifesum
//
//  Created by Agon Mati on 2022-05-02.
//

import Foundation

class RandomFoodViewModel {
    var apiClient: HttpClientProtocol

    init(apiClient: HttpClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func getRandomFood(completion: @escaping (FoodItem?) -> Void) {
        let id: Int = Int.random(in: 1 ... 200)
        let endpoint = "/\(Constants.Url.foodipedia)/\(Constants.Url.codeTest)?foodid=\(id)"
        apiClient.invalidate()
        apiClient.request(baseUrl: Constants.Url.base,
                          endpoint: endpoint,
                          httpMethod: .GET,
                          returnType: ResponseControl<FoodItem>.self) { result in
            switch result {
            case let .successful(responseControl):
                completion(responseControl?.response)
                break
            case let .failed(error):
                print(error)
            }
        }
    }
}
