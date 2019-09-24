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
    var ball = SKSpriteNode()

    
    lazy var floors = [floor1, floor2, floor3, floor4]
    
    var currColors = [0,0,0,0]
    
    var screenSize = UIScreen.main.bounds
    
    var initialx = CGFloat(0)
    var initialy = CGFloat(0)
    
    var touchedCoords = CGPoint(x: 0, y: 0)
    var releasedCoords = CGPoint(x: 0, y: 0)
    
    var onFloor = true
    
    var floorColors = [UIColor(red: 0.333, green: 0.254, blue: 0.333, alpha: 1), UIColor(red: 1, green: 0.533, blue: 0.862, alpha: 1)]
    
    override func didMove(to view: SKView) {
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        screenSize = UIScreen.main.bounds
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -30)
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        initialx = ball.position.x
        initialy = ball.position.y
        
        floor1 = self.childNode(withName: "floor1") as! SKSpriteNode
        floor2 = self.childNode(withName: "floor2") as! SKSpriteNode
        floor3 = self.childNode(withName: "floor3") as! SKSpriteNode
        floor4 = self.childNode(withName: "floor4") as! SKSpriteNode
        
        for floor in floors {
            floor.color = floorColors[0]
        }
    }
    
    func collisionBetween(player: SKNode, object: SKNode, floorNum: Int) {
        onFloor = true
        if(currColors[floorNum-1] == 0)  {
            floors[floorNum-1].color = floorColors[1]
            currColors[floorNum-1] = 1
        } else {
            floors[floorNum-1].color = floorColors[0]
            currColors[floorNum-1] = 0
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.name?.prefix(5) == "floor" {
            print("damn")
            collisionBetween(player: contact.bodyA.node!, object: contact.bodyB.node!, floorNum: Int(String((contact.bodyB.node!.name?.last!)!))!)
        }
        if contact.bodyA.node?.name?.prefix(5) == "floor" {
            collisionBetween(player: contact.bodyB.node!, object: contact.bodyA.node!, floorNum: Int(String((contact.bodyA.node!.name?.last!)!))!)
        }
    }
    
    func reset() {
        ball.position.x = initialx
        ball.position.y = initialy
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        floors[0].position.x = -375
        floors[0].position.y = -319
        floors[0].color = floorColors[0]
        for n in 1...floors.count - 1 {
            floors[n].color = floorColors[0]
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
        let touch = touches.first!
        touchedCoords = touch.location(in: self.view)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        releasedCoords = touch.location(in: self.view)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.applyImpulse(CGVector(dx: (touchedCoords.x - releasedCoords.x) * 16, dy: (releasedCoords.y - touchedCoords.y) * 16))
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if(ball.position.x < screenSize.width * -1 || ball.position.y < screenSize.height * -1) {
            self.reset()
        }
        if(player.position.x < -640) {
            player.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 0))
        } else if (player.position.x > 520) {
            player.physicsBody?.applyImpulse(CGVector(dx: -60, dy: 0))
        }
        
        for n in 0...floors.count - 1 {
            floors[n].position.x = floors[n].position.x - 10
            
            if(floors[n].position.x + floors[n].size.width < screenSize.width * -1 + 250) {
                if(currColors[n] == 0) {
                    reset()
                    break
                }
            }
            
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
                floors[n].color = floorColors[0]
                currColors[n] = 0
            }
            if(floors[n].position.y < -1 * screenSize.height) {
                floors[n].position.y += 75
            }
        }
    }
}
