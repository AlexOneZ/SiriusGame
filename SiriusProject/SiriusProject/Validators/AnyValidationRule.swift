//
//  AnyValidationRule.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import Foundation

struct AnyValidationRule<Input>: ValidateProtocol {
    private let _validate: (Input) -> String?

    init<R: ValidateProtocol>(_ rule: R) where R.Input == Input {
        _validate = rule.validate
    }

    func validate(_ input: Input) -> String? {
        return _validate(input)
    }
}
