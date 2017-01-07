//
// HomeScene.swift
// Downhill Challenge
//
// Created by Troy Deville on 8/19/15.
// Copyright (c) 2015 Troy Deville. Licensed under the MIT license
//

import UIKit
import SpriteKit
import Foundation
import AVFoundation
import GameKit

class HomeScene: SKScene, GKGameCenterControllerDelegate {
    
    var backgroundMusic = AVAudioPlayer()
    
    let title1 : SKLabelNode = SKLabelNode(text: "Downhill")
    let title2 : SKLabelNode = SKLabelNode(text: "Challenge")
    let playButton : SKLabelNode = SKLabelNode(text: "Play")
    let gamecenter : SKLabelNode = SKLabelNode(text: "Leaderboard")

    let snow : SKEmitterNode = SKEmitterNode(fileNamed: "Snow.sks")!
    
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
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    // set up view
    override func didMove(to view: SKView) {
        backgroundMusic = setupAudioPlayerWithFile("introSong", type: "mp3")
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.volume = 0.25
        backgroundMusic.play()
        
        backgroundColor = UIColor(red: 0, green: 125/255, blue: 1, alpha: 1)
        
        addChild(snow)
        snow.position = CGPoint(x: size.width / 2, y: size.height)
        
        setLabel(title1, labelName: "Title1", fontName: "Papyrus", fontSize: 50, xPos: size.width / 2, yPos: size.height * 0.82, fontColor: UIColor.white)
        setLabel(title2, labelName: "Title2", fontName: "Papyrus", fontSize: 50, xPos: size.width / 2, yPos: size.height * 0.70, fontColor: UIColor.white)
        setLabel(playButton, labelName: "Play", fontName: "Papyrus", fontSize: 45, xPos: size.width / 2, yPos: size.height * 0.35, fontColor: UIColor.white)
        setLabel(gamecenter, labelName: "Leaderboard", fontName: "Papyrus", fontSize: 45, xPos: size.width / 2, yPos: size.height * 0.2, fontColor: UIColor.white)
    }
    
    func showLeaderboard() {
        let gcViewController: GKGameCenterViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        
        gcViewController.viewState = GKGameCenterViewControllerState.leaderboards
        
        gcViewController.leaderboardIdentifier = "dhc.sfb.leaderboard"
        
        let vc : UIViewController = self.view!.window!.rootViewController!
        vc.present(gcViewController, animated: true, completion: nil)
    }
    
    // Called when a touch begins
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            
            let touchedScreen = touch.location(in: self)
            let touchedNode = self.atPoint(touchedScreen)
            
            if touchedNode.name == "Play" {
                backgroundMusic.pause()
                let scene = GameScene(size: self.scene!.size)
                self.scene?.view?.presentScene(scene, transition: SKTransition.fade(with: UIColor.white, duration: 0.5))
            }
            if touchedNode.name == "Leaderboard" {
                showLeaderboard()
            }
        }
    }
}
