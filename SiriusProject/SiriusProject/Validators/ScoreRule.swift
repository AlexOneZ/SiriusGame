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
    let maxScore: Int = 100

    init(errorMessage: String = "Score must be from 0 to 100") {
        self.errorMessage = errorMessage
    }

    func validate(_ input: String) -> String? {
        if let score = Int(input) {
            return minScore <= score && score <= maxScore ? nil : errorMessage
        }
        return errorMessage
    }
}
