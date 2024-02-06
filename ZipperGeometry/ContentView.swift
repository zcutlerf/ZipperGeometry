//
//  ContentView.swift
//  ZipperGeometry
//
//  Created by Zoe Cutler on 2/5/24.
//

import SwiftUI

struct ContentView: View {
    let audioManager = AudioManager()
    
    @State private var position = CGPoint(x: 0, y: 300)
    @State private var speed = CGFloat.zero
    @State private var yVelocity = CGFloat.zero
    
    var body: some View {
        ZStack {
            Zipper(position: position, filled: true)
                .foregroundColor(.teal)
            Zipper(position: position, filled: true)
                .foregroundColor(.teal)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            Zipper(position: position, filled: false)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .square, lineJoin: .bevel))
            Zipper(position: position, filled: false)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .square, lineJoin: .bevel))
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            Text(yVelocity.description)
                .font(.largeTitle)
                .background {
                    Rectangle()
                        .foregroundStyle(.green)
                }
        }
        .contentShape(Rectangle())
        .gesture (
            DragGesture()
                .onChanged { value in
                    self.yVelocity = value.velocity.height
                    if !audioManager.isPlaying {
                        audioManager.resume()
                    }
                    position.y = value.location.y
                    let speed = log10(abs(value.velocity.height)) - 0.5
                    self.speed = speed
                    audioManager.speedControl.rate = Float(speed)
                }
                .onEnded { value in
                    position.y = value.location.y
                    let speed = log10(abs(value.velocity.height))
                    self.speed = speed
                    audioManager.speedControl.rate = Float(speed)
                    Task {
                        for slowdownSpeed in stride(from: speed, through: (speed / 10), by: -(speed / 10)) {
                            audioManager.speedControl.rate = Float(slowdownSpeed)
                            self.speed = slowdownSpeed
                            try await Task.sleep(for: Duration.seconds(0.05))
                        }
                        audioManager.pause()
                    }
                }
        )
        .ignoresSafeArea()
        .onAppear {
            try? audioManager.play("themchanges")
            audioManager.pause()
        }
    }
}

#Preview {
    ContentView()
}
