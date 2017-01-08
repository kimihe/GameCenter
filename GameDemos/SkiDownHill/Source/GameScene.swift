//
// GameScene.swift
// Downhill Challenge
//
// Created by Troy Deville on 8/19/15.
// Copyright (c) 2015 Troy Deville. Licensed under the MIT license
//

import SpriteKit
import Foundation
import GameKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let lv1: Int = 3
    let lv2: Int = 5
    let lv3: Int = 7
    let lv4: Int = 11
    let lv5: Int = 13
    
    var backgroundMusic = AVAudioPlayer()
    var coinCounter : Int = 0
    var playerSpeed : CGFloat = 240
    var pSpeed : TimeInterval = 200
    var upSpawn : Bool = false
    var actionCounter : Bool = false
    let trailParticle : SKEmitterNode = SKEmitterNode(fileNamed: "SnowParticle.sks")!
    var gameLogic = GameLogic(tSpeed: 4.5, tRespawn: 0.5, sSpeed: 10, sRespawn: 18, cSpeed: 5.2, cRespawn: 0.6, trSpeed: 4, trRespawn: 18)
    var didComeToGame : Bool = true
    
    let number = UserDefaults.standard
    
    let player = NewObject(imageName: "Snowman", scaleX: 0.63, scaleY: 0.63).addSprite()
    
    let snowball = NewObject(imageName: "Snowball", scaleX: 0.7, scaleY: 0.7)
    let tree = NewObject(imageName: "Tree", scaleX: 0.7, scaleY: 0.7)
    let coin = NewObject(imageName: "Coin", scaleX: 0.25, scaleY: 0.25)
    
    var score : SKLabelNode = SKLabelNode(text: "0")
    let help : SKLabelNode = SKLabelNode(text: "Tap or hold sides to move")
    
    let snowmanAnimation : SKTextureAtlas = SKTextureAtlas(named: "Snowman.atlas")
    var snowmanArray = Array<SKTexture>()
    var coinArray = Array<SKTexture>()
    
    /* Setup your scene here */
    override func didMove(to view: SKView) {
        
        playCoinSound()
        
        snowmanArray.append(snowmanAnimation.textureNamed("Snowman1"))
        snowmanArray.append(snowmanAnimation.textureNamed("Snowman2"))
        snowmanArray.append(snowmanAnimation.textureNamed("Snowman3"))
        
        backgroundMusic = setupAudioPlayerWithFile("mainSong2", type: "mp3")
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.play()
        backgroundMusic.volume = 0.2
        
        self.backgroundColor = UIColor.white
        physicsWorld.contactDelegate = self
        
        trailParticle.targetNode = self.scene
        trailParticle.zPosition = 0
        
        // Score label
        score.position = CGPoint(x: size.width / 2, y: size.height * 0.90)
        score.fontName = "Papyrus"
        score.fontColor = UIColor.black
        score.fontSize = 40
        score.zPosition = 10
        
        help.position = CGPoint(x: size.width / 2, y: size.height / 2)
        help.fontName = "Papyrus"
        help.fontColor = UIColor.black
        help.fontSize = 25
        help.zPosition = 10
        
        setPlayer()
        
        addChild(help)
        snowmanAnimate()
    }
    
    func playCoinSound() {
        let playSound : SKAction = SKAction.playSoundFileNamed("coinSound.mp3", waitForCompletion: true)
        let removeSound : SKAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([playSound, removeSound]), withKey: "theCoinSound")
        self.removeAction(forKey: "theCoinsound")
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
    
    // Setting the player up.
    func setPlayer() {
        player.addChild(trailParticle)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.25)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 4)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.categoryBitMask = Body.playerBody.rawValue
        player.physicsBody!.contactTestBitMask = Body.treeBody.rawValue | Body.coinBody.rawValue
        player.physicsBody!.collisionBitMask = 0
        player.zPosition = 1
        player.position = CGPoint(x: size.width / 2, y: size.height / 1.35)
        addChild(player)
    }
    
    func reportLeaderboard(_ x : Int64) {
        //scoreObject.context = 0
        let scoreObject : GKScore = GKScore(leaderboardIdentifier: "dhc.sfb.leaderboard")
        scoreObject.context = 0
        scoreObject.value = x
        GKScore.report([scoreObject], withCompletionHandler: {(error) -> Void in})
    }
    
    func getScores() {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            reportLeaderboard(Int64(coinCounter))
        } else {
            print("Not authenticated.", terminator: "")
        }
        if let gotScore = number.value(forKey: "score") as? Int {
            if coinCounter > gotScore {
                number.set(coinCounter, forKey: "score")
            }
        } else {
            number.set(coinCounter, forKey: "score")
        }
        number.set(coinCounter, forKey: "currentScore")
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func runActions(runTree: Bool, runSnowball: Bool, runCoin: Bool, runTruck : Bool) {
        if runTree == true {
            self.removeAction(forKey: "tree")
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(moveTree),SKAction.wait(forDuration: gameLogic.treeRespawn)])), withKey: "tree")
        }
        if runSnowball == true {
            self.removeAction(forKey: "snowball")
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(moveSnowball),SKAction.wait(forDuration: gameLogic.snowballRespawn)])), withKey: "snowball")
        }
        if runCoin == true {
            self.removeAction(forKey: "coin")
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(moveCoin),SKAction.wait(forDuration: gameLogic.coinRespawn)])), withKey: "coin")
        }
        if runTruck == true {
            self.removeAction(forKey: "truck")
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(moveTruck),SKAction.wait(forDuration: gameLogic.truckRespawn)])), withKey: "truck")
        }
    }
    
    func snowmanAnimate() {
        let animateAction = SKAction.animate(with: self.snowmanArray, timePerFrame: 0.10)
        let repeatAction = SKAction.repeatForever(animateAction)
        player.run(repeatAction)
    }
    
    /* Called when a touch begins */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            
            if didComeToGame == false {
                let touchedScreen = touch.location(in: self)
                
                let distanceResultRight : CGFloat = (size.width - player.position.x) / playerSpeed
                let distanceResultLeft : CGFloat = (player.position.x) / playerSpeed
                let time1 : TimeInterval = TimeInterval(distanceResultRight)
                let time2 : TimeInterval = TimeInterval(distanceResultLeft)
                if touchedScreen.x < size.width / 2 {
                    player.run(movePlayer(0.0, time: time2))
                }
                if touchedScreen.x > size.width / 2 {
                    player.run(movePlayer(size.width, time: time1))
                }
            } else if didComeToGame == true {
                runActions(runTree: true, runSnowball: false, runCoin: true, runTruck: false)
                self.addChild(score)
                help.removeFromParent()
                didComeToGame = false
            }
            
        }
    }
    
    func findDistance(_ pointA : CGFloat, pointB : CGFloat) -> TimeInterval {
        let distancePartA = pointA - pointB
        let distancePartB = distancePartA * distancePartA
        let distancePartC : TimeInterval = TimeInterval(sqrt(distancePartB))
        let time : TimeInterval = distancePartC / pSpeed
        return time
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.removeAllActions()
        snowmanAnimate()
    }
    
    func gameOver() {
        getScores()
        backgroundMusic.pause()
        self.removeAllActions()
        let scene = GameOverScene(size: self.scene!.size)
        self.scene?.view?.presentScene(scene, transition: SKTransition.moveIn(with: SKTransitionDirection.up, duration: 0.5))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody, secondBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        let contactMask = firstBody.categoryBitMask | secondBody.categoryBitMask
        
        switch(contactMask) {
        case 3:
            // Snowball hit Player
            secondBody.node?.removeFromParent()
            gameOver()
        case 5:
            // Snowball hit Tree
            secondBody.node?.removeFromParent()
        case 9:
            // Snowball hit Coin
            secondBody.node?.removeFromParent()
        case 6:
            // Player hit Tree
            firstBody.node?.removeFromParent()
            gameOver()
        case 10:
            // Player hit Coin
            //self.coinSound.play()
            playCoinSound()
            coinCounter += 1
            score.text = "\(coinCounter)"
            secondBody.node?.removeFromParent()
        case 17:
            // Truck hit snowball
            firstBody.node?.removeFromParent()
        case 18:
            // Truck hit player
            firstBody.node?.removeFromParent()
            gameOver()
        case 20:
            // Truck hit Tree
            firstBody.node?.removeFromParent()
        case 24:
            // Truck hit Coin
            firstBody.node?.removeFromParent()
        case 33:
            // Truck ball hit Snowball
            firstBody.node?.removeFromParent()
        case 36:
            // truck hit tree
            firstBody.node?.removeFromParent()
        case 40:
            // truck hit coin
            firstBody.node?.removeFromParent()
        default:
            return
        }
    }
    
    // Declaring game objects to move
    
    func movePlayer(_ direction : CGFloat, time : TimeInterval) -> SKAction {
        let playerMove : SKAction = SKAction.moveTo(x: direction, duration: time)
        return playerMove
    }
    
    func moveTree() {
        addChild(tree.setMovingTree(randomTreeLocation(), destination: CGPoint(x: 0, y: size.height * 2), speed: gameLogic.treeSpeed))
    }
    
    func moveSnowball() {
        addChild(snowball.setMovingSnowball(randomSnowballLocation(), destination: CGPoint(x: 0, y: -size.height * 2), speed: gameLogic.snowballSpeed))
    }
    
    func moveCoin() {
        addChild(coin.setMovingCoin(randomCoinLocation(), destination: CGPoint(x: 0, y: size.height * 2), speed: gameLogic.coinSpeed))
    }
    
    func moveTruck() {
        let truck : SKSpriteNode = SKSpriteNode(imageNamed: "SnowTruck")
        let truckParticle : SKEmitterNode = SKEmitterNode(fileNamed: "TruckParticle.sks")!
        truckParticle.position = CGPoint(x: truck.size.width / 2, y: truck.size.height)
        
        truckParticle.zPosition = 10
        
        truck.position = randomTruckLocation()
        truck.xScale = 1
        truck.yScale = 1
        
        truck.physicsBody = SKPhysicsBody(rectangleOf: truck.size)
        truck.zPosition = 5
        truck.physicsBody!.affectedByGravity = false
        truck.physicsBody!.allowsRotation = false
        truck.physicsBody!.categoryBitMask = Body.truck.rawValue
        truck.physicsBody!.contactTestBitMask = Body.playerBody.rawValue | Body.treeBody.rawValue | Body.coinBody.rawValue
        truck.physicsBody!.collisionBitMask = 0
        
        let moveTruck = SKAction.move(to: CGPoint(x: player.position.x, y: player.position.y + (player.size.height * 2.2)), duration: TimeInterval(gameLogic.truckSpeed))
        let moveTruck2 = SKAction.moveBy(x: 0, y: -size.height * 1.5, duration: gameLogic.truckSpeed)
        let removeTruck = SKAction.removeFromParent()
        
        addChild(truck)
        truck.addChild(truckParticle)
        
        truck.run(SKAction.sequence([moveTruck, moveTruck2, removeTruck]))
    }
    
    // Setting game object spawn location
    func randomTruckLocation() -> CGPoint {
        var result : CGPoint
        let randomNumber : UInt32 = arc4random_uniform(UInt32(size.width))
        result = CGPoint(x: CGFloat(randomNumber), y: size.height + 200)
        
        return result
    }
    
    func randomTreeLocation() -> CGPoint {
        var result : CGPoint
        let randomNumber : UInt32 = arc4random_uniform(UInt32(size.width))
        result = CGPoint(x: CGFloat(randomNumber), y: -100)
        
        return result
    }
    
    func randomSnowballLocation() -> CGPoint {
        var result : CGPoint
        let randomNumber : UInt32 = arc4random_uniform(UInt32(size.width))
        result = CGPoint(x: CGFloat(randomNumber), y: size.height + 200)
        
        return result
    }
    
    func randomCoinLocation() -> CGPoint {
        var result : CGPoint
        let randomNumber : UInt32 = arc4random_uniform(UInt32(size.width))
        result = CGPoint(x: CGFloat(randomNumber), y: -100)
        
        return result
    }
    
    /* Called before each frame is rendered */
    override func update(_ currentTime: TimeInterval) {
        switch coinCounter {
        case lv1:
            if upSpawn == false {
                gameLogic.treeRespawn = 0.3
                upSpawn = true
            }
        case lv2:
            if upSpawn == false {
                gameLogic.treeRespawn = 0.22
                upSpawn = true
            }
        case lv3:
            if upSpawn == false {
                playerSpeed += 5
                gameLogic.treeRespawn  = 0.18
                upSpawn = true
            }
        case lv4:
            if upSpawn == false {
                gameLogic.snowballRespawn = 10
                gameLogic.treeRespawn  = 0.15
                upSpawn = true
            }
        case lv5:
            if upSpawn == false {
                gameLogic.truckRespawn = 13
                upSpawn = true
            }
        default:
            upSpawn = false
        }
    }
    
    override func didEvaluateActions() {
        switch coinCounter {
        case lv1:
            if actionCounter == false {
                //gameLogic.treeRespawn = 0.3
                runActions(runTree: true, runSnowball: true, runCoin: false, runTruck: false)
                actionCounter = true
            }
        case lv2:
            if actionCounter == false {
                runActions(runTree: true, runSnowball: false, runCoin: true, runTruck: false)
                actionCounter = true
            }
        case lv3:
            if actionCounter == false {
                runActions(runTree: true, runSnowball: false, runCoin: false, runTruck: true)
                actionCounter = true
            }
        case lv4:
            if actionCounter == false {
                runActions(runTree: true, runSnowball: true, runCoin: false, runTruck: false)
                actionCounter = true
            }
        case lv5:
            if actionCounter == false {
                runActions(runTree: false, runSnowball: false, runCoin: false, runTruck: true)
                actionCounter = true
            }
        default:
            actionCounter = false
        }
    }
}
