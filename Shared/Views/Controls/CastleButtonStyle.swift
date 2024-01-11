//
//  CastleButtonStyle.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CastleButtonStyle: ButtonStyle {

    static let buttonHeight: CGFloat = 48
    
	enum Style: Int {
		case flat = 0
		case gradient = 1
		case highlighted = 2
	}

	static private let flatActive = LinearGradient(colors: [ Color("ButtonActive") ], startPoint: .top, endPoint: .bottom)
	static private let flatInactive = LinearGradient(colors: [ Color("ButtonInactive") ], startPoint: .top, endPoint: .bottom)

	static private let gradientActive = LinearGradient(colors: [ Color("ButtonGradient1"), Color("ButtonGradient0") ], startPoint: .top, endPoint: .bottom)
	static private let gradientInactive = LinearGradient(colors: [ Color("ButtonGradient0"), Color("ButtonGradient1") ], startPoint: .top, endPoint: .bottom)

	static private let highlightedActive = LinearGradient(colors: [ Color("HighlightGradient1"), Color("HighlightGradient0") ], startPoint: .top, endPoint: .bottom)
	static private let highlightedInactive = LinearGradient(colors: [ Color("HighlightGradient0"), Color("HighlightGradient1") ], startPoint: .top, endPoint: .bottom)

	let style: Style

	// MARK: -

	func makeBody(configuration: Self.Configuration) -> some View {
		ZStack {
			// background
			RoundedRectangle(cornerRadius: 4)
				.stroke(lineWidth: (style != .highlighted) ? 1 : 0)
				.foregroundColor(.black)
                .frame(height: CastleButtonStyle.buttonHeight)
				.layoutPriority(-1)
				.background(configuration.isPressed ? ((style == .highlighted) ? CastleButtonStyle.highlightedActive : ((style == .gradient) ? CastleButtonStyle.gradientActive : CastleButtonStyle.flatActive)) : ((style == .highlighted) ? CastleButtonStyle.highlightedInactive : ((style == .gradient) ? CastleButtonStyle.gradientInactive : CastleButtonStyle.flatInactive)))
				.cornerRadius(4)
			// label
			configuration.label
				.font(.system(size: 12, weight: .semibold))
				.foregroundColor(Color("TextPrimary"))
				.padding(8)
		}
        .frame(height: CastleButtonStyle.buttonHeight)
		.cornerRadius(4)
	}

}

struct CastleFixedButtonStyle: ButtonStyle {

	let isHighlighted: Bool
	let width: CGFloat

	func makeBody(configuration: Self.Configuration) -> some View {
		ZStack {
			LinearGradient(colors: isHighlighted ? (configuration.isPressed ? [ Color("HighlightGradient1"), Color("HighlightGradient0") ] : [ Color("HighlightGradient0"), Color("HighlightGradient1") ]) : (configuration.isPressed ? [ Color("ButtonActive") ] : [ Color("ButtonInactive") ]), startPoint: .top, endPoint: .bottom)
                .frame(width: width, height: CastleButtonStyle.buttonHeight)
			configuration.label
				.font(.system(size: 12, weight: .semibold))
				.foregroundColor(Color("TextPrimary"))
				.padding(8)
		}
	}

}

struct CastleSegmentButtonStyle: ButtonStyle {

	let isHighlighted: Bool
	let width: CGFloat

	func makeBody(configuration: Self.Configuration) -> some View {
		ZStack {
			LinearGradient(colors: isHighlighted ? (configuration.isPressed ? [ Color("HighlightGradient1"), Color("HighlightGradient0") ] : [ Color("HighlightGradient0"), Color("HighlightGradient1") ]) : (configuration.isPressed ? [ Color("ButtonActive") ] : [ Color.clear ]), startPoint: .top, endPoint: .bottom)
                .frame(width: width, height: CastleButtonStyle.buttonHeight)
			configuration.label
				.font(.system(size: 12, weight: .semibold))
				.foregroundColor(Color("TextPrimary"))
				.padding(8)
		}
	}

	static func buttonWidth(for title: String) -> CGFloat {
#if os(macOS)
		let font = NSFont.systemFont(ofSize: 12, weight: .semibold)
#else
		let font = UIFont.systemFont(ofSize: 12, weight: .semibold)
#endif // os(macOS)
		let attributes: [NSAttributedString.Key : Any] = [ .font : font ]
		let stringSize = title.size(withAttributes: attributes)
		return (ceil(stringSize.width) + (8 * 2))
	}

}

struct CastleButtonStyle_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			HStack {
				Button("Highlighted") {
				}
				.buttonStyle(CastleButtonStyle(style: .highlighted))
				Button("Gradient") {
				}
				.buttonStyle(CastleButtonStyle(style: .gradient))
				Button("Flat") {
				}
				.buttonStyle(CastleButtonStyle(style: .flat))
			}
			HStack {
				Button("Fixed Size") {
				}
				.buttonStyle(CastleFixedButtonStyle(isHighlighted: true, width: 100))
				Button("Fixed Size") {
				}
				.buttonStyle(CastleFixedButtonStyle(isHighlighted: false, width: 100))
			}
		}
		.previewLayout(.sizeThatFits)
	}
}
