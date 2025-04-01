//
//  Logging.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 01.04.2025.
//

typealias Logging = (String) -> Void

// Реализация пустого логирования (ничего не делает)
let emptyLogging: Logging = { _ in }

// Реализация логирования через print
let printLogging: Logging = { message in
    #if DEBUG
        print(message)
    #endif
}
