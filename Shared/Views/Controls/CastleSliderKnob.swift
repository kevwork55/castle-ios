//
//  CastleSliderKnob.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CastleSliderKnob: View {

	static let knobDiameter: CGFloat = 21
	static let knobImageSize: CGFloat = 33

	let viewSize: CGSize

	@Binding var value: Double
	let range: ClosedRange<Double>

	// MARK: -

	var body: some View {
		Image("SliderKnob")
			.offset(CGSize(width: offsetForValue(value), height: 0))
			.gesture(dragGesture)
	}

	var dragGesture: some Gesture {
		DragGesture()
			.onChanged { drag in
				// calculate the new offset
				let newOffset = CGSize(width: (drag.startLocation.x + drag.translation.width - (CastleSliderKnob.knobDiameter / 2)), height: 0)
				// recalculate the value
				var newValue = valueForOffset(newOffset.width)
				newValue = min(range.upperBound, max(range.lowerBound, newValue))
				value = newValue
			}
	}

	// MARK: - Private

	private func valueForOffset(_ offset: CGFloat) -> Double {
		// calculate the value in the range 0.0 - 1.0
		let knobDiameter = CastleSliderKnob.knobDiameter
		var value = (offset + ((CastleSliderKnob.knobImageSize - knobDiameter) / 2))
		value /= (viewSize.width - knobDiameter)
		// convert value to the selected range
		value *= (range.upperBound - range.lowerBound)
		value += range.lowerBound
		return value
	}

	private func offsetForValue(_ value: Double) -> CGFloat {
		// convert the value to the range 0.0 - 1.0
		var offset = ((value - range.lowerBound) / (range.upperBound - range.lowerBound))
		// convert the value to the offset
		let knobDiameter = CastleSliderKnob.knobDiameter
		offset *= (viewSize.width - knobDiameter)
		offset -= ((CastleSliderKnob.knobImageSize - knobDiameter) / 2)
		return offset
	}

}
