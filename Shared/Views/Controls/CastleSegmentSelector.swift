//
//  CastleSegmentSelector.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CastleSegmentSelector<SelectionValue>: View where SelectionValue : Hashable {

	struct Option {
		var title: String
		var value: SelectionValue
	}

	let options: [Option]
	let segmentWidth: CGFloat?

	@Binding var selection: SelectionValue

	// MARK: -

	var body: some View {
		let buttonWidth = segmentWidth ?? CastleSegmentSelector.calculateSegmentWidth(for: options)
		let totalWidth = (buttonWidth * CGFloat(options.count))
		let totalHeight: CGFloat = 36

		ZStack {
			// background
			ZStack {
				Color(.black)
				Color("ButtonInactive")
					.clipShape(RoundedRectangle(cornerRadius: 4).offset(x: 0, y: 0.5))
				// draw segment divider lines
				Path() { path in
					for x in 1 ..< options.count {
						path.move(to: CGPoint(x: (buttonWidth * CGFloat(x)), y: 0))
						path.addLine(to: CGPoint(x: (buttonWidth * CGFloat(x)), y: totalHeight))
					}
				}
				.stroke(Color.black, lineWidth: 0.5)
			}

			// segment buttons
			HStack(spacing: 0) {
				ForEach(0 ..< options.count, id: \.self) { index in
					let selected = (selection == options[index].value)
					Button(options[index].title) {
						selection = options[index].value
					}
					.buttonStyle(CastleSegmentButtonStyle(isHighlighted: selected, width: buttonWidth))
				}
			}
		}
		.clipShape(RoundedRectangle(cornerRadius: 4))
		.frame(width: totalWidth, height: totalHeight)
	}

	init(options: [Option], selection: Binding<SelectionValue>, segmentWidth: CGFloat? = nil) {
		self.options = options
		self._selection = selection
		self.segmentWidth = segmentWidth
	}

	// MARK: - Static

	static func calculateSegmentWidth(for options: [Option]) -> CGFloat {
		// find the largest segment width of the option titles
		var largestButtonWidth: CGFloat = 0

		for option in options {
			let buttonWidth = CastleSegmentButtonStyle.buttonWidth(for: option.title)
			if (buttonWidth > largestButtonWidth) {
				largestButtonWidth = buttonWidth
			}
		}

		return largestButtonWidth
	}

	static func calculateWidth(for options: [Option]) -> CGFloat {
		let buttonWidth = CastleSegmentSelector.calculateSegmentWidth(for: options)
		return (buttonWidth * CGFloat(options.count))
	}

}

struct CastleSegmentControl_Previews: PreviewProvider {
	@State static var selected = 0
	static var previews: some View {
		CastleSegmentSelector<Int>(options: [
				CastleSegmentSelector.Option(title: "Option 1", value: 0),
				CastleSegmentSelector.Option(title: "Option 2", value: 1),
				CastleSegmentSelector.Option(title: "Option 3", value: 2)
			], selection: $selected)
			.previewLayout(.sizeThatFits)
	}
}
