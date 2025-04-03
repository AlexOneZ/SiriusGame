//
//  ScoreRule.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import Foundation

struct ScoreRule: ValidateProtocol {
    typealias Input = String

    let errorMessage: String
    let minScore: Int = 0
    let maxScore: Int = 10

    init(errorMessage: String = "Диапазон очков должен быть от 0 до 10") {
        self.errorMessage = errorMessage
    }

    func validate(_ input: String) -> String? {
        if let score = Int(input) {
            return minScore <= score && score <= maxScore ? nil : errorMessage
        }
        return errorMessage
    }
}
