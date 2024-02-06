//
//  AudioManager.swift
//  ZipperGeometry
//
//  Created by Zoe Cutler on 2/6/24.
//

import AVFoundation

class AudioManager {
    var isPlaying = false
    
    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    let pitchControl = AVAudioUnitTimePitch()
    private let audioPlayer = AVAudioPlayerNode()
    
    func play(_ mp3: String) throws {
        isPlaying = true
        guard let url = Bundle.main.url(forResource: mp3, withExtension: "mp3") else { return }
        // 1: load the file
        let file = try AVAudioFile(forReading: url)

        // 3: connect the components to our playback engine
        engine.attach(audioPlayer)
        engine.attach(pitchControl)
        engine.attach(speedControl)

        // 4: arrange the parts so that output from one is input to another
        engine.connect(audioPlayer, to: speedControl, format: nil)
        engine.connect(speedControl, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        audioPlayer.scheduleFile(file, at: nil)

        // 6: start the engine and player
        try engine.start()
        audioPlayer.play()
    }
    
    func pause() {
        audioPlayer.pause()
        isPlaying = false
    }
    
    func resume() {
        audioPlayer.play()
    }
}
