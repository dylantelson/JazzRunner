//
//  GameScene.swift
//  First Game
//
//  Created by Dylan Telson on 9/23/19.
//  Copyright © 2019 Dylan Telson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode()
    var floor1 = SKSpriteNode()
    var floor2 = SKSpriteNode()
    var floor3 = SKSpriteNode()
    var floor4 = SKSpriteNode()
    
    lazy var floors = [floor1, floor2, floor3, floor4]
    
    var screenSize = UIScreen.main.bounds
    
    var initialx = CGFloat(0)
    var initialy = CGFloat(0)
    
    var onFloor = true
    
    override func didMove(to view: SKView) {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        screenSize = UIScreen.main.bounds
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -28)
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        initialx = player.position.x
        initialy = player.position.y
        
        floor1 = self.childNode(withName: "floor1") as! SKSpriteNode
        floor2 = self.childNode(withName: "floor2") as! SKSpriteNode
        floor3 = self.childNode(withName: "floor3") as! SKSpriteNode
        floor4 = self.childNode(withName: "floor4") as! SKSpriteNode
    }
    
    func collisionBetween(player: SKNode, object: SKNode) {
        onFloor = true
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.name?.prefix(5) == "floor" {
            collisionBetween(player: contact.bodyA.node!, object: contact.bodyB.node!)
        }
    }
    
    func reset() {
        player.position.x = initialx
        player.position.y = initialy
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        floors[0].position.x = -375
        floors[0].position.y = -319
        for n in 1...floors.count - 1 {
            floors[n].position.x = floors[n-1].position.x + 900
            if(floors[n-1].position.y > screenSize.height / 5) {
                floors[n].position.y = floors[n-1].position.y - CGFloat(Int.random(in: 0 ... 300))
            } else if(floors[n-1].position.y < -1 * screenSize.height) {
                floors[n].position.y = floors[n-1].position.y + CGFloat(Int.random(in: 0 ... 300))
            } else {
                floors[n].position.y = floors[n-1].position.y + CGFloat(Int.random(in: -200 ... 200))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                      with event: UIEvent?) {
        if(onFloor) {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy:1200))
            onFloor = false
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        if(player.position.x < screenSize.width * -1 || player.position.y < screenSize.height * -1) {
            self.reset()
        }
        if(player.position.x < -640) {
            player.position.x += 1
        }
        
        for n in 0...floors.count - 1 {
            floors[n].position.x = floors[n].position.x - 10
            if(floors[n].position.x + floors[n].size.width < screenSize.width * -1 - floors[n].size.width) {
                floors[n].position.x = screenSize.width + floors[n].size.width/2 + 20
                var m = 0
                if(n == 0) {
                    m = floors.count-1
                }
                else {
                    m = n - 1
                }
                if(floors[m].position.y > screenSize.height / 5) {
                    floors[n].position.y = floors[m].position.y - CGFloat(Int.random(in: 0 ... 300))
                } else if(floors[m].position.y < -1 * screenSize.height) {
                    floors[n].position.y = floors[m].position.y + CGFloat(Int.random(in: 0 ... 300))
                } else {
                    floors[n].position.y = floors[m].position.y + CGFloat(Int.random(in: -200 ... 200))
                }
            }
            if(floors[n].position.y < -1 * screenSize.height) {
                floors[n].position.y += 75
            }
        }
    }
}
