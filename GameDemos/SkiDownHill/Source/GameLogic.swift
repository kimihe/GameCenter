//
// GameLogic.swift
// Downhill Challenge
//
// Created by Troy Deville on 8/19/15.
// Copyright (c) 2015 Troy Deville. Licensed under the MIT license
//

import Foundation
import SpriteKit

class GameLogic {
    
    var treeSpeed : TimeInterval
    var treeRespawn : TimeInterval
    var snowballSpeed : TimeInterval
    var snowballRespawn : TimeInterval
    var coinSpeed : TimeInterval
    var coinRespawn : TimeInterval
    var truckSpeed : TimeInterval
    var truckRespawn : TimeInterval
    
    init(tSpeed: TimeInterval, tRespawn: TimeInterval, sSpeed: TimeInterval, sRespawn: TimeInterval, cSpeed: TimeInterval, cRespawn: TimeInterval, trSpeed: TimeInterval, trRespawn: TimeInterval){
        self.treeSpeed = tSpeed
        self.treeRespawn = tRespawn
        self.snowballSpeed = sSpeed
        self.snowballRespawn = sRespawn
        self.coinSpeed = cSpeed
        self.coinRespawn = cRespawn
        self.truckSpeed = trSpeed
        self.truckRespawn = trRespawn
    }
 }
