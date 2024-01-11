//
//  AnimatedCellHeight.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/13/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct AnimatedCellHeight: AnimatableModifier {

	var height: CGFloat = 0

	var animatableData: CGFloat {
		get { height }
		set { height = newValue }
	}

	func body(content: Content) -> some View {
		content.frame(height: height)
	}

}
