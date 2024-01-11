//
//  CurvePoint.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/23/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

class CurvePoint: ObservableObject, Identifiable {

	@Published var x: CGFloat
	@Published var y: CGFloat

	// MARK: -

	init(x: CGFloat, y: CGFloat) {
		self.x = x
		self.y = y
	}

	init(cgPoint: CGPoint, graphSize: CGSize) {
		// convert the point
		x = (cgPoint.x / graphSize.width)
		y = (1 - (cgPoint.y / graphSize.height))
		// clamp the point
		x = min(1.0, max(0.0, x))
		y = min(1.0, max(0.0, y))
	}

	var cgPoint: CGPoint {
		return CGPoint(x: x, y: y)
	}

	func distance(to point: CurvePoint) -> CGFloat {
		let xDelta = (point.x - self.x)
		let yDelta = (point.y - self.y)
		return sqrt((xDelta * xDelta) + (yDelta * yDelta))
	}

	func viewPoint(with graphSize: CGSize) -> CGPoint {
		return CGPoint(x: (graphSize.width * x), y: (graphSize.height * (1.0 - y)))
	}

}
