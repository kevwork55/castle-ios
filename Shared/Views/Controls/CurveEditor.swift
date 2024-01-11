//
//  CurveEditor.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/13/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CurveEditor: View {

	enum EditMode {
		case addPoints
		case adjustPoints
		case deletePoints
	}

	let gridSize = 10
	let minimumPointDistance: CGFloat = 0.05

	@ObservedObject var curve: Curve
	@State var editMode = EditMode.adjustPoints
	@State private var editPoint: CurvePoint? = nil

	// MARK: -

	var body: some View {
		GeometryReader { geometry in
			let viewSize = geometry.size
			let graphSize = CGSize(width: (viewSize.width * 0.75), height: (viewSize.width * 0.75))

			// create the point edit gesture
			let editGesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
				.onChanged { value in
					dragChanged(start: value.startLocation, translation: value.translation, graphSize: graphSize)
				}
				.onEnded { value in
					dragEnded(start: value.startLocation, translation: value.translation, graphSize: graphSize)
				}

			// create the graph editor view
			VStack(spacing: 0) {
				Spacer().frame(height: 16)

				// curve editor graph
				ZStack {
					// draw vertical labels
					ForEach(0 ..< 11) { index in
						Text("\(index * 10)")
							.font(.system(size: 9, weight: .light))
							.foregroundColor(Color("TextPrimary"))
							.multilineTextAlignment(.center)
							.frame(width: 20, height: 10)
							.offset(x: -((graphSize.width / 2) + 16), y: (graphSize.height / 2) - ((graphSize.height / 10) * CGFloat(index)))
					}

					// draw horizontal labels
					ForEach(0 ..< 11) { index in
						Text("\(index * 10)")
							.font(.system(size: 9, weight: .light))
							.foregroundColor(Color("TextPrimary"))
							.multilineTextAlignment(.trailing)
							.frame(width: 20, height: 10)
							.offset(x: (-(graphSize.width / 2) + ((graphSize.width / 10) * CGFloat(index))), y: ((graphSize.height / 2) + 16))
					}

					// draw the background gradient
					LinearGradient(gradient: Gradient(colors: [ Color("CurveBackgroundGradient0"), Color("CurveBackgroundGradient1") ]), startPoint: .top, endPoint: .bottom)

					// draw the grid
					Path() { path in
						// draw vertical lines
						let segmentWidth = (graphSize.width / CGFloat(gridSize))
						for x in 1 ..< gridSize {
							path.move(to: CGPoint(x: (segmentWidth * CGFloat(x)), y: 0))
							path.addLine(to: CGPoint(x: (segmentWidth * CGFloat(x)), y: graphSize.height))
						}
						// draw horizontal lines
						let segmentHeight = (graphSize.height / CGFloat(gridSize))
						for y in 1 ..< gridSize {
							path.move(to: CGPoint(x: 0, y: (segmentHeight * CGFloat(y))))
							path.addLine(to: CGPoint(x: graphSize.width, y: (segmentHeight * CGFloat(y))))
						}
					}
					.stroke(Color("CurveGrid"), lineWidth: 1)

					// draw the curve highlight
					CurveEditorHighlight(graphSize: graphSize, linear: $curve.linear, points: $curve.points)

					// draw the inner shadow
					Path() { path in
						path.move(to: CGPoint(x: 0, y: 0))
						path.addLine(to: CGPoint(x: graphSize.width, y: 0))
					}
					.stroke(.black, lineWidth: 0.5)

					// draw the curve handles
					ForEach(curve.points) { point in
						let highlighted = (point === editPoint)
						CurveEditorHandle(point: point, graphSize: graphSize, highlighted: highlighted)
					}
				}
				.frame(width: graphSize.width, height: graphSize.height)
				.gesture(editGesture)

				Spacer()
					.frame(height: 32)

				// curve editor controls
				CurveEditorControls(curve: curve, editMode: $editMode, linear: $curve.linear)
					.frame(width: graphSize.width, height: CurveEditorControls.height)
			}
			.offset(x: ((viewSize.width - graphSize.width) / 2), y: 0)
		}
	}

	// MARK: -

	private func dragChanged(start: CGPoint, translation: CGSize, graphSize: CGSize) {
		// calculate the point on the graph
		let tapPoint = CGPoint(x: (start.x + translation.width), y: (start.y + translation.height))
		let curvePoint = CurvePoint(cgPoint: tapPoint, graphSize: graphSize)

		if (editMode == .addPoints) {
			if let addedPoint = editPoint {
				// move the point
				restrictIntersectingPoints(curvePoint, old: addedPoint)
				curve.movePoint(addedPoint, to: curvePoint)
			} else {
				// create a new point at the tap location
				if (pointIntersectsOtherPoints(curvePoint) == false) {
					curve.points.append(curvePoint)
					editPoint = curvePoint
				}
			}
		} else if (editMode == .adjustPoints) {
			if let adjustPoint = editPoint {
				// move the point
				restrictIntersectingPoints(curvePoint, old: adjustPoint)
				curve.movePoint(adjustPoint, to: curvePoint)
			} else {
				// find the tapped point
				editPoint = closestCurvePoint(tapPoint, graphSize: graphSize)
			}
		} else if (editMode == .deletePoints) {
			// find the tapped point
			editPoint = closestCurvePoint(tapPoint, graphSize: graphSize)
			return
		}
	}

	private func dragEnded(start: CGPoint, translation: CGSize, graphSize: CGSize) {
		let tapPoint = CGPoint(x: (start.x + translation.width), y: (start.y + translation.height))

		if ((editMode == .addPoints) || (editMode == .adjustPoints)) {
			// move the point to the final position
			if let adjustPoint = editPoint {
				// calculate the point on the graph
				let newCurvePoint = CurvePoint(cgPoint: tapPoint, graphSize: graphSize)
				restrictIntersectingPoints(newCurvePoint, old: adjustPoint)
				// move the point
				curve.movePoint(adjustPoint, to: newCurvePoint)
			}
		} else if (editMode == .deletePoints) {
			// delete the edit point
			if let deletePoint = editPoint {
				// check that the tap is still inside the edit point handle
				let tapDistance = distance(from: tapPoint, to: deletePoint, graphSize: graphSize)
				if (tapDistance <= CurveEditorHandle.diameter) {
					// delete the point
					curve.points.removeAll(where: { $0 === deletePoint })
				}
			}
		}

		// clear the edit point
		editPoint = nil
	}

	// MARK: - Private

	private func closestCurvePoint(_ tapPoint: CGPoint, graphSize: CGSize) -> CurvePoint? {
		let handleRadius = (CurveEditorHandle.diameter / 2)
		var closestDistance: CGFloat = .infinity
		var closestPoint: CurvePoint?

		for point in curve.points {
			let viewPoint = point.viewPoint(with: graphSize)
			let viewDistance = distance(from: tapPoint, to: viewPoint)

			if ((viewDistance <= handleRadius) && (viewDistance < closestDistance)) {
				closestDistance = viewDistance
				closestPoint = point
			}
		}

		return closestPoint
	}

	private func pointIntersectsOtherPoints(_ point: CurvePoint, ignoring ignorePoint: CurvePoint? = nil) -> Bool {
		// check for intersecting points
		for intersectPoint in curve.points {
			if (intersectPoint !== ignorePoint), (abs(point.x - intersectPoint.x) < minimumPointDistance) {
				return true
			}
		}
		return false
	}

	private func restrictIntersectingPoints(_ newPoint: CurvePoint, old oldPoint: CurvePoint) {
		// check if the new point intersects any other points
		if pointIntersectsOtherPoints(newPoint, ignoring: oldPoint) {
			newPoint.x = oldPoint.x
		}
	}

	private func distance(from tapPoint: CGPoint, to curvePoint: CurvePoint, graphSize: CGSize) -> CGFloat {
		let curveViewPoint = curvePoint.viewPoint(with: graphSize)
		return self.distance(from: tapPoint, to: curveViewPoint)
	}

	private func distance(from point0: CGPoint, to point1: CGPoint) -> CGFloat {
		let xDelta = (point1.x - point0.x)
		let yDelta = (point1.y - point0.y)
		return sqrt((xDelta * xDelta) + (yDelta * yDelta))
	}

	// MARK: - Static

	static func calculateHeight(for width: CGFloat) -> CGFloat {
		let graphSize: CGFloat = (width * 0.75)
		let paddingSize: CGFloat = 16
		return (paddingSize + graphSize + (paddingSize * 2) + CurveEditorControls.height)
	}

}

struct CurveEditor_Previews: PreviewProvider {
	@StateObject static var curve = Curve()
	static var previews: some View {
		CurveEditor(curve: curve)
			.previewLayout(.fixed(width: 300, height: 400))
	}
}
