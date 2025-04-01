//
//  EmptyValidationRule.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import Foundation

struct EmptyValidationRule: ValidateProtocol {
    typealias Input = String

    let errorMessage: String

    init(errorMessage: String = "This field cannot be empty.") {
        self.errorMessage = errorMessage
    }

    func validate(_ input: String) -> String? {
        return input.isEmpty ? errorMessage : nil
    }
}
