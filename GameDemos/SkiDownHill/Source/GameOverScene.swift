//
// GameOverScene.swift
// Downhill Challenge
//
// Created by Troy Deville on 8/19/15.
// Copyright (c) 2015 Troy Deville. Licensed under the MIT license
//

import Foundation
import UIKit
import SpriteKit
import Foundation
import GameKit
import AVFoundation

class GameOverScene : SKScene {
    
    var backgroundMusic = AVAudioPlayer()
    
    let title1 : SKLabelNode = SKLabelNode(text: "Game Over")
    let mainMenu: SKLabelNode = SKLabelNode(text: "Main Menu")
    let restart : SKLabelNode = SKLabelNode(text: "Restart")
    let currentScore : SKLabelNode = SKLabelNode(text: "Score")
    let highScore : SKLabelNode = SKLabelNode(text: "High Score")
    let snow : SKEmitterNode = SKEmitterNode(fileNamed: "Snow.sks")!
    
    let score = UserDefaults.standard
    
    func setLabel(_ label : SKLabelNode, labelName : String, fontName: String, fontSize : CGFloat, xPos : CGFloat, yPos : CGFloat, fontColor : UIColor) {
        label.name = labelName
        label.fontName = fontName
        label.fontSize = fontSize
        label.position = CGPoint(x: xPos, y: yPos)
        label.fontColor = fontColor
        addChild(label)
    }
    
    func setupAudioPlayerWithFile(_ file: String, type: String) -> AVAudioPlayer {
        let path = Bundle.main.path(forResource: file, ofType: type)
        let url = URL(fileURLWithPath: path!)
        
        var audioPlayer : AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error1 as NSError {
            print("\(error1)")
            audioPlayer = nil
        }
        
        return audioPlayer!
    }
    
    // set up view
    override func didMove(to view: SKView) {
        
        backgroundMusic = setupAudioPlayerWithFile("gameOverSong", type: "mp3")
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.play()
        backgroundMusic.volume = 0.25
        
        snow.position = CGPoint(x: size.width / 2, y: size.height)
        addChild(snow)
        
        if let gotCurrentScore = score.value(forKey: "currentScore") as? Int {
            score.set(gotCurrentScore, forKey: "currentScore")
            currentScore.text = "Score: \(gotCurrentScore)"
        }
        if let gotScore = score.value(forKey: "score") as? Int {
            score.set(gotScore, forKey: "score")
            highScore.text = "Best: \(gotScore)"
        }
        
        setLabel(title1, labelName: "Title1", fontName: "Papyrus", fontSize: 50, xPos: size.width / 2, yPos: size.height * 0.8, fontColor: UIColor.white)
        setLabel(mainMenu, labelName: "Home", fontName: "Papyrus", fontSize: 35, xPos: size.width / 2, yPos: size.height / 2, fontColor: UIColor.white)
        setLabel(restart, labelName: "Restart", fontName: "Papyrus", fontSize: 35, xPos: size.width / 2, yPos: (size.height / 2) - (restart.fontSize * 2), fontColor: UIColor.white)
        setLabel(currentScore, labelName: "CurrentScore", fontName: "Papyrus", fontSize: 25, xPos: size.width / 2, yPos: size.height / 4, fontColor: UIColor.white)
        setLabel(highScore, labelName: "HighScore", fontName: "Papyrus", fontSize: 25, xPos: size.width / 2, yPos: (size.height / 4) - (currentScore.fontSize * 2), fontColor: UIColor.white)
    }
    
    
    // Called when a touch begins
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches ) {
            
            let touchedScreen = touch.location(in: self)
            let touchedNode = self.atPoint(touchedScreen)
            
            if touchedNode.name == "Restart" {
                backgroundMusic.pause()
                let scene = GameScene(size: self.scene!.size)
                self.scene?.view?.presentScene(scene, transition: SKTransition.moveIn(with: SKTransitionDirection.down, duration: 0.5))
            }
            if touchedNode.name == "Home" {
                backgroundMusic.pause()
                let scene = HomeScene(size: self.scene!.size)
                self.scene!.view!.presentScene(scene, transition: SKTransition.fade(with: UIColor(red: 0, green: 165/255, blue: 1, alpha: 1), duration: 0.75))
            }
        }
        
    }
    
}
