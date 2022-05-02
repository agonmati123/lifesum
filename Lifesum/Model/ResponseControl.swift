//
//  Food.swift
//  Lifesum
//
//  Created by Agon Mati on 2022-05-02.
//

import Foundation

struct ResponseControl<T: Codable>: Codable {
    let meta: ErrorReponse?
    let response: T?

    init(response: T?) {
        self.response = response
        meta = nil
    }
}

struct ErrorReponse: Codable {
    let code: Int?
    let errorType, errorDetail: String?
}

struct FoodItem: Codable {
    let title: String
    let calories: Int
    let carbs, protein, fat, saturatedfat: Double
    let unsaturatedfat: Double
    let fiber: Double
    let cholesterol, sugar, sodium, potassium: Double
    let gramsperserving: Double
    let pcstext: String
}
