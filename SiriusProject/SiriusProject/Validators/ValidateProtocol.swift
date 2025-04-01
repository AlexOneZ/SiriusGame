//
//  ValidateProtocol.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import Foundation

protocol ValidateProtocol {
    associatedtype Input

    func validate(_ input: Input) -> String?
}
