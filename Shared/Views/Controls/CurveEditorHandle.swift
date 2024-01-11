//
//  CurveEditorHandle.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/13/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CurveEditorHandle: View {

	static let diameter: CGFloat = 22

	@ObservedObject var point: CurvePoint
	let graphSize: CGSize
	let highlighted: Bool

	// MARK: -

	var body: some View {
		Circle()
			.foregroundColor(Color(highlighted ? "CurveHandleActive" : "CurveHandle"))
			.frame(width: CurveEditorHandle.diameter, height: CurveEditorHandle.diameter)
			.position(point.viewPoint(with: graphSize))
	}

}
