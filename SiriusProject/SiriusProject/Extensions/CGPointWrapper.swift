//
//  CGPoint + Extension.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 02.04.2025.
//

import CoreGraphics

struct CGPointWrapper: Codable, Hashable {
    var x: CGFloat
    var y: CGFloat

    init(_ point: CGPoint) {
        x = point.x
        y = point.y
    }

    var cgPoint: CGPoint {
        return CGPoint(x: x, y: y)
    }
}
