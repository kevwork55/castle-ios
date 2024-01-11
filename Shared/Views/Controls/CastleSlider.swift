//
//  CastleSlider.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CastleSlider: View {

	@Binding var value: Double
	let range: ClosedRange<Double>

	// MARK: -

	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				let viewSize = geometry.size

				// draw the track background
				Capsule()
					.fill(Color.black)
					.frame(width: viewSize.width, height: 14)
					.overlay(
						Capsule()
							.fill(Color("ButtonInactive"))
							.offset(x: 0, y: 0.5)
							.clipShape(Capsule())
					)

				// draw the filled track
				let scaledValue = ((value - range.lowerBound) / (range.upperBound - range.lowerBound))
				let knobRadius = (CastleSliderKnob.knobDiameter / 2)
				let fillWidth = (((viewSize.width - knobRadius) * scaledValue) + knobRadius)

				Capsule()
					.fill(LinearGradient(colors: [ Color("HighlightGradient1"), Color("HighlightGradient0") ], startPoint: .leading, endPoint: .trailing))
					.frame(width: fillWidth, height: 14)

				// draw the curve handles
				CastleSliderKnob(viewSize: viewSize, value: $value, range: range)
			}
			.frame(height: 33)
		}
	}

}

struct CurveSlider_Previews: PreviewProvider {
	@State static var value: Double = 0
	static var previews: some View {
		CastleSlider(value: $value, range: 0 ... 100)
			.previewLayout(.sizeThatFits)
	}
}
