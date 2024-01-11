//
//  CurveEditorControls.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/18/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CurveEditorControls: View {

	static var height: CGFloat = ((36 * 2) + 16)

	@ObservedObject var curve: Curve
	@Binding var editMode: CurveEditor.EditMode
	@Binding var linear: Bool

	// MARK: -

	var body: some View {
		VStack {
			CastleSegmentSelector(options: [
					CastleSegmentSelector.Option(title: "Add Points", value: .addPoints),
					CastleSegmentSelector.Option(title: "Adjust Points", value: .adjustPoints),
					CastleSegmentSelector.Option(title: "Delete Points", value: .deletePoints),
				], selection: $editMode)
			Spacer()
				.frame(height: 16)
			HStack {
				CastleSegmentSelector(options: [
						CastleSegmentSelector.Option(title: "Linear", value: true),
						CastleSegmentSelector.Option(title: "Curves", value: false),
					], selection: $linear)
				Spacer()
				Button(action: {
					// clear all points
					curve.points.removeAll()
				}, label: {
					Text("Clear")
				})
				.buttonStyle(CastleButtonStyle(style: .gradient))
			}
		}
	}

}

struct CurveEditorControls_Previews: PreviewProvider {
	@StateObject static var curve = Curve()
	@State static var editMode = CurveEditor.EditMode.adjustPoints
	@State static var linear = false
	static var previews: some View {
		CurveEditorControls(curve: curve, editMode: $editMode, linear: $linear)
			.previewLayout(.sizeThatFits)
	}
}
