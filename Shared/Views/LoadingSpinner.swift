//
//  LoadingSpinner.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 15.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct LoadingSpinner: View {
    
    @State private var appear = false
    
    private let lineWidth = 10.0
    
    var body: some View {
        GeometryReader { geometry in
            let circleSize = min(geometry.size.width, geometry.size.height)
            
            let gradient = RadialGradient(
                gradient   : Gradient(colors: [Color("Spinner0").opacity(0.1), Color("Spinner1")]),
                    center     : UnitPoint(x: 0.75, y: 0.25),
                    startRadius: 0.0,
                    endRadius  : circleSize / 2.0
                )
            
            let path = Path { path in
                path.addEllipse(in: .init(origin: .zero, size: CGSize(width: circleSize, height: circleSize)))
            }
            
            path.stroke(Color("Spinner0").opacity(0.25), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(Angle(degrees: appear ? 270 : -90))
                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
                .onAppear {
                    appear = true
                }
        }.padding()
    }
}

struct LoadingSpinner_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSpinner()
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
