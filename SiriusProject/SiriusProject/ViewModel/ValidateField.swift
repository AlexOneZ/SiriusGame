//
//  ValidateField.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import Combine
import Foundation

class ValidatedField: ObservableObject {
    @Published var value: String = ""
    @Published var error: String? = nil
    @Published var judgePasscodError: String? = nil
    @Published var isEdited: Bool = false

    private let validationRules: [AnyValidationRule<String>]
    private var cancellables = Set<AnyCancellable>()

    init(validationRules: [AnyValidationRule<String>]) {
        self.validationRules = validationRules
        setupValidation()
    }

    private func setupValidation() {
        $value
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] in
                self?.isEdited = true
                return self?.validate($0)
            }
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
    }

    private func validate(_ value: String) -> String? {
        for rule in validationRules {
            if let error = rule.validate(value) {
                return error
            }
        }
        return nil
    }
}
