//
//  LenghtRule.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import Foundation

struct LenghtRule: ValidateProtocol {
    typealias Input = String

    let errorMessage: String
    var lenght: Int

    init(errorMessage: String = "Incorrect lenght", lenght: Int) {
        self.errorMessage = errorMessage
        self.lenght = lenght
    }

    func validate(_ input: String) -> String? {
        return input.count == lenght ? nil : errorMessage
    }
}
