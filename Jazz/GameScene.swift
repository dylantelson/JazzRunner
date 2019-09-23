//
//  GameScene.swift
//  First Game
//
//  Created by Dylan Telson on 9/23/19.
//  Copyright © 2019 Dylan Telson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
//        player = SKSpriteNode(color: UIColor.white, size: CGSize(width: 100, height: 160))
//        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        player.position = CGPoint(x: -590, y: -120)
//        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 160))
//        
//        self.addChild(player)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
