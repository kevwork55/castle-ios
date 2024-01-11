//
//  Curve.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/13/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

class Curve: ObservableObject {

	@Published var linear = true
	@Published var points = [CurvePoint]()

	// MARK: -

	func movePoint(_ point: CurvePoint, to newPoint: CurvePoint) {
		self.objectWillChange.send()
		point.x = newPoint.x
		point.y = newPoint.y
	}

	// MARK: - Static

	static func bezierControlPoints(previous: CurvePoint?, point: CurvePoint, next: CurvePoint?, tension: CGFloat) -> (CurvePoint, CurvePoint) {
		let previous = previous ?? point
		let next = next ?? point

		let distance01 = point.distance(to: previous)
		let distance12 = next.distance(to: point)

		var scale01 = (distance01 / (distance01 + distance12))
		var scale12 = (distance12 / (distance01 + distance12))
		scale01 = scale01.isNaN ? 0 : scale01
		scale12 = scale12.isNaN ? 0 : scale12

		let fa = (tension * scale01)
		let fb = (tension * scale12)

		return (
			CurvePoint(x: point.x - fa * (next.x - previous.x), y: point.y - fa * (next.y - previous.y)),
			CurvePoint(x: point.x + fb * (next.x - previous.x), y: point.y + fb * (next.y - previous.y))
		)
	}

}
