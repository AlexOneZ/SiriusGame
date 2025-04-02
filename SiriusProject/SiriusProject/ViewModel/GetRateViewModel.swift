//
//  GetRateViewModel.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import Combine
import Foundation

class GetRateViewModel: ObservableObject {
    @Published var score: ValidatedField
    @Published var judgePasscode: ValidatedField
    @Published var canSubmit: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        let scoreValidationrules: [AnyValidationRule] = [AnyValidationRule(ScoreRule())]

        let judgePasscodeValidationRules: [AnyValidationRule] = [AnyValidationRule(LenghtRule(lenght: 4)),
                                                                 AnyValidationRule(EmptyValidationRule())]

        score = ValidatedField(validationRules: scoreValidationrules)

        judgePasscode = ValidatedField(validationRules: judgePasscodeValidationRules)

        setupSubmitValidation()
    }

    private func setupSubmitValidation() {
        Publishers.CombineLatest(score.$error, judgePasscode.$error)
            .map { scoreError, judgePasscodeError in
                scoreError == nil && judgePasscodeError == nil && !self.score.value.isEmpty && !self.judgePasscode.value.isEmpty
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }
}
