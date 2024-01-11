//
//  CastleSegmentedGrid.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/16/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CastleSegmentedGrid: View {

	let options: [CastleSegmentSelector<Int>.Option]

	@Binding var selection: Int

	private var segmentWidth: CGFloat = 0.0

	// MARK: -

	var body: some View {
		GeometryReader { geometry in
			let segmentsPerRow = CastleSegmentedGrid.segmentsPerRow(for: options, in: geometry.size.width)
			let centerInset = ((geometry.size.width - (CGFloat(segmentsPerRow) * segmentWidth)) / 2)
			VStack(alignment: .leading, spacing: 8) {
				ForEach(0 ..< options.count, id: \.self) { index in
					if ((index % segmentsPerRow) == 0) {
						CastleSegmentSelector(options: optionsForRow(index, segmentsPerRow: segmentsPerRow), selection: $selection, segmentWidth: segmentWidth)
						.offset(x: centerInset)
					}
				}
			}
		}
	}

	init(options: [CastleSegmentSelector<Int>.Option], selection: Binding<Int>) {
		self.options = options
		self._selection = selection

		// find the largest segment width of the options
		for option in options {
			let buttonWidth = CastleSegmentButtonStyle.buttonWidth(for: option.title)
			if (buttonWidth > segmentWidth) {
				segmentWidth = buttonWidth
			}
		}
	}

	// MARK: -

	static func height(for options: [CastleSegmentSelector<Int>.Option], in width: CGFloat) -> CGFloat {
		// calculate the number of rows
		let segmentsPerRow = segmentsPerRow(for: options, in: width)
		var rows = (options.count / segmentsPerRow)
		if ((options.count % segmentsPerRow) != 0) {
			rows += 1
		}
		// calculate the height of the rows
		var height = (CGFloat(rows) * 36)
		// add row padding
		height += (CGFloat(rows + 1) * 8)

		return height
	}

	static func segmentsPerRow(for options: [CastleSegmentSelector<Int>.Option], in width: CGFloat) -> Int {
		// find the largest button width for the options
		var largestButtonWidth: CGFloat = 0.0
		for option in options {
			let buttonWidth = CastleSegmentButtonStyle.buttonWidth(for: option.title)
			if (buttonWidth > largestButtonWidth) {
				largestButtonWidth = buttonWidth
			}
		}

		// divide the width by the largest button width
		var segments = Int(floor(width / largestButtonWidth))
		segments = max(segments, 1)
		segments = min(segments, options.count)

		return segments
	}

	// MARK: - Private

	private func optionsForRow(_ rowBaseIndex: Int, segmentsPerRow: Int) -> [CastleSegmentSelector<Int>.Option] {
		var rowOptions = [CastleSegmentSelector<Int>.Option]()
		for rowIndex in 0 ..< segmentsPerRow {
			let index = (rowBaseIndex + rowIndex)
			if index < options.count {
				rowOptions.append(options[index])
			}
		}
		return rowOptions
	}

}

struct CastleSegmentedGrid_Previews: PreviewProvider {
	@State static var selected = 0
	static var previews: some View {
		let options = [
			CastleSegmentSelector.Option(title: "Option 1", value: 1),
			CastleSegmentSelector.Option(title: "Option 2", value: 2),
			CastleSegmentSelector.Option(title: "Option 3", value: 3),
			CastleSegmentSelector.Option(title: "Option 4", value: 4),
			CastleSegmentSelector.Option(title: "Option 5", value: 5),
			CastleSegmentSelector.Option(title: "Option 6", value: 6)
		]
		CastleSegmentedGrid(options: options, selection: $selected)
			.frame(height: 36)
			.previewLayout(.sizeThatFits)
	}
}
