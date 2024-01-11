//
//  Line.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/31/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct Line: View {

	let color: Color = .black
	let lineWidth: CGFloat = 1

	// MARK: -

	var body: some View {
		GeometryReader { geometry in
			// create the line points
			let x = ((geometry.size.width - lineWidth) / 2)
			let y = ((geometry.size.height - lineWidth) / 2)
			let point0 = (geometry.size.width > geometry.size.height) ? CGPoint(x: 0, y: y) : CGPoint(x: x, y: 0)
			let point1 = (geometry.size.width > geometry.size.height) ? CGPoint(x: geometry.size.width, y: y) : CGPoint(x: x, y: geometry.size.height)

			// draw the line
			Path() { path in
				path.move(to: point0)
				path.addLine(to: point1)
			}
			.stroke(color, lineWidth: lineWidth)
		}
	}

}

struct Line_Previews: PreviewProvider {
	static var previews: some View {
		Line()
	}
}
