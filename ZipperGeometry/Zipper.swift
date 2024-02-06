//
//  ZipperView.swift
//  ZipperGeometry
//
//  Created by Zoe Cutler on 2/5/24.
//

import SwiftUI

struct Zipper: Shape {
    var position: CGPoint
    var filled: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        let numberOfSegments: CGFloat = 24
        
        let yPosition = position.y
        let yPositionOutOf12 = yPosition / (rect.height / numberOfSegments)
        
        for i in stride(from: CGFloat(numberOfSegments), to: 0, by: -1) {
            let yUp = rect.height * i / numberOfSegments
            
            var xUpOffset: CGFloat = 0
            var xOutOffset: CGFloat = 0
            var yUpOffset: CGFloat = 0
            if yUp < yPosition {
                xUpOffset = (yPositionOutOf12 - i) * (yPositionOutOf12 - i) * -4
                xOutOffset = (yPositionOutOf12 - i + 1) * (yPositionOutOf12 - i) * -4 - 10
                yUpOffset = (yPositionOutOf12 - i + 1) * 2
            }
            
            let xUp = rect.midX + xUpOffset + xOutOffset * 0.12
            let yUp1 = yUp - yUpOffset
            let up = CGPoint(x: xUp, y: yUp1)
            path.addLine(to: up)
            
            let xOut = rect.midX - 20 + xOutOffset
            let out = CGPoint(x: xOut, y: yUp)
            path.addLine(to: out)
            
            let yUp2 = rect.height * (i - 0.5) / numberOfSegments
            let xOut2 = xOut + xOutOffset * 0.25
            let up2 = CGPoint(x: xOut2, y: yUp2)
            path.addLine(to: up2)
        }
        
        if filled {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
        
        return path
    }
}

#Preview {
    Zipper(position: CGPoint(x: 100, y: 200), filled: false)
        .stroke(lineWidth: 5)
}
