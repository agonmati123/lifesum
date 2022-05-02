//
//  NSObject+Identifier.swift
//  Lifesum
//
//  Created by Agon Mati on 2022-05-02.
//

import Foundation
extension NSObject {
    static var IDENTIFIER: String {
        return String(describing: self.self)
    }
}
