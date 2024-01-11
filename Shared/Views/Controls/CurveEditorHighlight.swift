//
//  CurveEditorHighlight.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/13/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CurveEditorHighlight: View {

	let graphSize: CGSize

	@Binding var linear: Bool
	@Binding var points: [CurvePoint]

	// MARK: -

	var body: some View {
		// sort the points from left to right
		var sortedPoints = points.sorted(by: { $0.x < $1.x })

		// create the path for the highlight shape
		Path() { path in
			// move to the start
			path.move(to: viewPointForGraphPoint(CurvePoint(x: 0.0, y: 0.0)))

			if linear || (sortedPoints.count == 0) {
				// connect the points with lines
				for point in sortedPoints {
					path.addLine(to: viewPointForGraphPoint(point))
				}
				// add the final point (if necessary)
				if ((sortedPoints.last == nil) || (sortedPoints.last!.x < 1.0)) {
					path.addLine(to: viewPointForGraphPoint(CurvePoint(x: 1.0, y: 1.0)))
				}
			} else {
				// add the final point (if necessary)
				if ((sortedPoints.last == nil) || (sortedPoints.last!.x < 1.0)) {
					sortedPoints.append(CurvePoint(x: 1.0, y: 1.0))
				}

				// connect the points as a curve
				let tension = 0.333
				var currentPoint = sortedPoints[0]
				var previousPoint = CurvePoint(x: 0.0, y: 0.0)
				var previousControlPoints = Curve.bezierControlPoints(previous: nil, point: previousPoint, next: currentPoint, tension: tension)
				var nextPoint: CurvePoint?

				for index in 0 ..< sortedPoints.count {
					// get the next point
					if ((index + 1) < sortedPoints.count) {
						nextPoint = sortedPoints[index + 1]
					} else {
						nextPoint = nil
					}

					// calculate the bezier curve control points
					let controlPoints = Curve.bezierControlPoints(previous: previousPoint, point: currentPoint, next: nextPoint, tension: tension)

					// add the curve
					path.addCurve(to: viewPointForGraphPoint(currentPoint), control1: viewPointForGraphPoint(previousControlPoints.1), control2: viewPointForGraphPoint(controlPoints.0))

					// advance to the next point
					previousPoint = currentPoint
					previousControlPoints = controlPoints
					if let nextPoint = nextPoint {
						currentPoint = nextPoint
					}
				}
			}

			// complete the shape
			path.addLine(to: viewPointForGraphPoint(CurvePoint(x: 1.0, y: 0.0)))
			path.closeSubpath()
		}
		.fill(Color("CurveHighlight"))
		.clipped()
	}

	// MARK: - Private

	private func viewPointForGraphPoint(_ point: CurvePoint) -> CGPoint {
		return CGPoint(x: (graphSize.width * point.x), y: (graphSize.height * (1.0 - point.y)))
	}

}
