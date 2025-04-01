//
//  GCD.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 31.03.2025.
//

import SwiftUI

typealias MainThreadRunner = (@escaping () -> Void) -> Void
typealias MainThreadAsyncRunner = (@escaping () -> Void) -> Void
typealias BackgroundRunner = (@escaping () -> Void) -> Void
typealias SyncQueueRunner = (@escaping () -> Void) -> Void
typealias DelayedExecution = (TimeInterval, @escaping () -> Void) -> Void
typealias DelayedRunner = (_ delay: TimeInterval, _ block: @escaping () -> Void) -> Cancellable

protocol Cancellable {
    func cancel()
}

func onMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}

func onMainThreadAsync(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}
