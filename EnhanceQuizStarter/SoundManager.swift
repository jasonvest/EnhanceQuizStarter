//
//  SoundManager.swift
//  EnhanceQuizStarter
//
//  Created by Jason Vest on 6/3/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//
import AudioToolbox

struct SoundManager {
    var gameSound: SystemSoundID = 0
    var wrongSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 0
    var perfectGameSound: SystemSoundID = 0
    var wompSound: SystemSoundID = 0
    
    init() {
        let pathGameSound = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrlGameSound = URL(fileURLWithPath: pathGameSound!)
        AudioServicesCreateSystemSoundID(soundUrlGameSound as CFURL, &self.gameSound)
        
        let pathWrongSound = Bundle.main.path(forResource: "WrongSound", ofType: "wav")
        let soundUrlWrongSound = URL(fileURLWithPath: pathWrongSound!)
        AudioServicesCreateSystemSoundID(soundUrlWrongSound as CFURL, &wrongSound)
        
        let pathCorrectSound = Bundle.main.path(forResource: "CorrectSound", ofType: "wav")
        let soundUrlCorrectSound = URL(fileURLWithPath: pathCorrectSound!)
        AudioServicesCreateSystemSoundID(soundUrlCorrectSound as CFURL, &correctSound)
        
        let pathPerfectGameSound = Bundle.main.path(forResource: "PerfectGameSound", ofType: "wav")
        let soundUrlPerfectGameSound = URL(fileURLWithPath: pathPerfectGameSound!)
        AudioServicesCreateSystemSoundID(soundUrlPerfectGameSound as CFURL, &perfectGameSound)
        
        let pathWompSound = Bundle.main.path(forResource: "WompSound", ofType: "wav")
        let soundUrlWompSound = URL(fileURLWithPath: pathWompSound!)
        AudioServicesCreateSystemSoundID(soundUrlWompSound as CFURL, &wompSound)
    }
    
    //Play the requested sound
    func playGameSound(_ sound: SystemSoundID) -> Void {
        AudioServicesPlaySystemSound(sound)
    }
}
