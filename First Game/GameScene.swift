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
    
    //var player = SKSpriteNode()
    
    //bigger = has to go left FASTER, swipes have to be less impactful
    
    var floor1 = SKSpriteNode()
    var floor2 = SKSpriteNode()
    var floor3 = SKSpriteNode()
    var floor4 = SKSpriteNode()
    
    var ceil1 = SKSpriteNode()
    var ceil2 = SKSpriteNode()
    var ceil3 = SKSpriteNode()
    var ceil4 = SKSpriteNode()
    
    var topBottom = SKNode()
    var mediumMedium = SKNode()
    var topMedium = SKNode()
    var bottomMedium = SKNode()
    var cross = SKNode()
    var threeMedium = SKNode()
    var topMediumBottom = SKNode()
    
    var currSpeed = Float(4)
    
    var ball = SKSpriteNode()
    
    var speedMultiplier = Float(1)
    var swipeMultiplier = Float(1)

    
    lazy var floors = [floor1, floor2, floor3, floor4]
    lazy var ceils = [ceil1, ceil2, ceil3, ceil4]
    lazy var floorsCeils = [floor1, floor2, floor3, floor4, ceil1, ceil2, ceil3, ceil4]
    lazy var obstacles = [topBottom, mediumMedium, topMedium, bottomMedium, cross, threeMedium, topMediumBottom]
    
    var currColors = [0,0,0,0,0,0,0,0]
    
    var screenSize = UIScreen.main.bounds
    
    var initialx = CGFloat(0)
    var initialy = CGFloat(0)
    
    var touchedCoords = CGPoint(x: 0, y: 0)
    var releasedCoords = CGPoint(x: 0, y: 0)
    
    var onFloor = true
    var lastTouched = 99
    
    var floorColors = [UIColor(red: 0.333, green: 0.254, blue: 0.333, alpha: 1), UIColor(red: 1, green: 0.533, blue: 0.862, alpha: 1)]
    
    var currObstacle = 0
    
    override func didMove(to view: SKView) {
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                speedMultiplier = 1
                
            case 1334:
                speedMultiplier = 1
                swipeMultiplier = 0.95
                
            case 1792:
                speedMultiplier = 1
                swipeMultiplier = 0.925
                
            case 1920, 2208:
                speedMultiplier = 1.3
                swipeMultiplier = 0.9
                
            case 2436:
                speedMultiplier = 1.4
                swipeMultiplier = 0.875
                
            case 2688:
                speedMultiplier = 1.5
                swipeMultiplier = 0.85
                
            default:
                speedMultiplier = 1
            }
        }
        
        screenSize = UIScreen.main.bounds
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -30)
        
        //player = self.childNode(withName: "player") as! SKSpriteNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.position.y = floor1.position.y + floor1.size.height/2
        initialx = ball.position.x
        initialy = ball.position.y
        
        floor1 = self.childNode(withName: "floor1") as! SKSpriteNode
        floor2 = self.childNode(withName: "floor2") as! SKSpriteNode
        floor3 = self.childNode(withName: "floor3") as! SKSpriteNode
        floor4 = self.childNode(withName: "floor4") as! SKSpriteNode
        
        ceil1 = self.childNode(withName: "ceil1") as! SKSpriteNode
        ceil2 = self.childNode(withName: "ceil2") as! SKSpriteNode
        ceil3 = self.childNode(withName: "ceil3") as! SKSpriteNode
        ceil4 = self.childNode(withName: "ceil4") as! SKSpriteNode
        
        ball.setScale(0.5)
        
        topBottom = self.childNode(withName: "topbottom") as! SKNode
        mediumMedium = self.childNode(withName: "mediummedium") as! SKNode
        topMedium = self.childNode(withName: "topmedium") as! SKNode
        bottomMedium = self.childNode(withName: "bottommedium") as! SKNode
        cross = self.childNode(withName: "cross") as! SKNode
        threeMedium = self.childNode(withName: "threemedium") as! SKNode
        topMediumBottom = self.childNode(withName: "topmediumbottom") as! SKNode
        
        for floor in floorsCeils {
            floor.color = floorColors[0]
            //floor.setScale(0.5)
        }
        for obstacle in obstacles {
            obstacle.setScale(0.5)
        }
        
        obstacles[currObstacle].position.x = screenSize.width + 150
    }
    
    func collisionBetween(player: SKNode, object: SKNode, type: String, floorNum: Int) {
        if(type == "saw") {
            DispatchQueue.main.async {
                self.reset()
                return
            }
        } else {
            onFloor = true
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.affectedByGravity = false
            var m = 0
            if(type == "ceil") {
                m = 4
            }
            if(lastTouched == floorNum-1+m && currColors[floorNum-1+m] == 1) {
                return
            }
            lastTouched = floorNum-1+m
            if(currColors[floorNum-1+m] == 0)  {
                floorsCeils[floorNum-1+m].color = floorColors[1]
                currColors[floorNum-1+m] = 1
            } else {
                floorsCeils[floorNum-1+m].color = floorColors[0]
                currColors[floorNum-1+m] = 0
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.name?.prefix(5) == "floor" {
            collisionBetween(player: contact.bodyA.node!, object: contact.bodyB.node!, type: "floor", floorNum: Int(String((contact.bodyB.node!.name?.last!)!))!)
        }
        if contact.bodyA.node?.name?.prefix(5) == "floor" {
            collisionBetween(player: contact.bodyB.node!, object: contact.bodyA.node!, type: "floor", floorNum: Int(String((contact.bodyA.node!.name?.last!)!))!)
        }
        if contact.bodyB.node?.name?.prefix(4) == "ceil" {
            collisionBetween(player: contact.bodyA.node!, object: contact.bodyB.node!, type: "ceil", floorNum: Int(String((contact.bodyB.node!.name?.last!)!))!)
        }
        if contact.bodyA.node?.name?.prefix(4) == "ceil" {
            collisionBetween(player: contact.bodyB.node!, object: contact.bodyA.node!, type: "ceil", floorNum: Int(String((contact.bodyA.node!.name?.last!)!))!)
        }
        if contact.bodyA.node?.name == "saw" {
            collisionBetween(player: contact.bodyB.node!, object: contact.bodyA.node!, type: "saw", floorNum: 0)
        }
        if contact.bodyB.node?.name == "saw" {
            collisionBetween(player: contact.bodyB.node!, object: contact.bodyA.node!, type: "saw", floorNum: 0)
        }
    }
    
    func newObstacle() {
        obstacles[currObstacle].position.x = screenSize.width + 150
//        for saw in obstacles[currObstacle].children {
//            saw.position.x = 0
//        }
        currObstacle = Int.random(in: 0...obstacles.count - 1)
        obstacles[currObstacle].position.x = screenSize.width + 150
    }
    
    func reset() {
        newObstacle()
        currSpeed = 4 * speedMultiplier
        ball.position.x = initialx
        ball.position.y = initialy
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        floors[0].position.x = -375
        floors[0].position.y = -180
        floors[0].color = floorColors[0]
        ceils[0].position.x = -50
        ceils[0].position.y = 180
        ceils[0].color = floorColors[0]
        for n in 0...floorsCeils.count - 1 {
            currColors[n] = 0
        }
        for n in 1...floors.count - 1 {
            currColors[n] = 0
            floors[n].color = floorColors[0]
            floors[n].position.x = floors[n-1].position.x + 900
//            if(floors[n-1].position.y > screenSize.height / 5) {
//                floors[n].position.y = floors[n-1].position.y - CGFloat(Int.random(in: 0 ... 100))
//            } else if(floors[n-1].position.y < -1 * screenSize.height) {
//                floors[n].position.y = floors[n-1].position.y + CGFloat(Int.random(in: 0 ... 100))
//            } else {
                floors[n].position.y = floors[n-1].position.y //+ CGFloat(Int.random(in: -50 ... 50))
            //}
        }
        for n in 1...ceils.count - 1 {
            currColors[n] = 0
            ceils[n].color = floorColors[0]
            ceils[n].position.x = ceils[n-1].position.x + 900
//            if(ceils[n-1].position.y > screenSize.height) {
//                ceils[n].position.y = ceils[n-1].position.y - CGFloat(Int.random(in: 0 ... 100))
//            } else if(ceils[n-1].position.y < screenSize.height / 2) {
//                ceils[n].position.y = ceils[n-1].position.y + CGFloat(Int.random(in: 0 ... 100))
//            } else {
                ceils[n].position.y = ceils[n-1].position.y //+ CGFloat(Int.random(in: -50 ... 50))
            //}
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                      with event: UIEvent?) {
//        if(onFloor) {
//            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy:1200))
//            onFloor = false
//        }
        let touch = touches.first!
        touchedCoords = touch.location(in: self.view)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        releasedCoords = touch.location(in: self.view)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.applyImpulse(CGVector(dx: (touchedCoords.x - releasedCoords.x) * CGFloat(16 * swipeMultiplier), dy: (releasedCoords.y - touchedCoords.y) * CGFloat(16 * swipeMultiplier)))
        if(onFloor) {
            onFloor = false
        }
        ball.physicsBody?.affectedByGravity = true
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        print(screenSize.width)
        if(ball.position.x < -450 || ball.position.y < screenSize.height * -1 || ball.position.y > screenSize.height) {
            self.reset()
            return
        }
//        if(player.position.x < -640) {
//            player.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 0))
//        } else if (player.position.x > 520) {
//            player.physicsBody?.applyImpulse(CGVector(dx: -60, dy: 0))
//        }
        
        if(onFloor) {
            ball.position.x -= CGFloat(currSpeed)
        }
        
        currSpeed *= 1.0004
        
        for n in 0...floors.count - 1 {
            floors[n].position.x -= CGFloat(currSpeed)
            
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
//                if(floors[m].position.y > -1 * screenSize.height / 1.5) {
//                    floors[n].position.y = floors[m].position.y - CGFloat(Int.random(in: 0 ... 100))
//                } else if(floors[m].position.y < -1 * screenSize.height) {
//                    floors[n].position.y = floors[m].position.y + CGFloat(Int.random(in: 0 ... 100))
//                } else {
                    floors[n].position.y = floors[m].position.y //+ CGFloat(Int.random(in: -50 ... 50))
                //}
                floors[n].color = floorColors[0]
                currColors[n] = 0
            }
            if(floors[n].position.y < -1 * screenSize.height) {
                floors[n].position.y += 75
            }
        }
        for n in 0...ceils.count - 1 {
            ceils[n].position.x = ceils[n].position.x - CGFloat(currSpeed)
            
            if(ceils[n].position.x + ceils[n].size.width < screenSize.width * -1 + 250) {
                if(currColors[n + 4] == 0) {
                    reset()
                    break
                }
            }
            
            if(ceils[n].position.x + ceils[n].size.width < screenSize.width * -1 - ceils[n].size.width) {
                ceils[n].position.x = screenSize.width + ceils[n].size.width/2 + 20
                var m = 0
                if(n == 0) {
                    m = ceils.count-1
                }
                else {
                    m = n - 1
                }
//                if(ceils[m].position.y > screenSize.height) {
//                    ceils[n].position.y = ceils[m].position.y - CGFloat(Int.random(in: 0 ... 100))
//                } else if(ceils[m].position.y < screenSize.height / 2) {
//                    ceils[n].position.y = ceils[m].position.y + CGFloat(Int.random(in: 0 ... 100))
//                } else {
                    ceils[n].position.y = ceils[m].position.y //+ CGFloat(Int.random(in: -50 ... 50))
//                }
                ceils[n].color = floorColors[0]
                currColors[n + 4] = 0
            }
            if(ceils[n].position.y < -1 * screenSize.height) {
                ceils[n].position.y += 75
            }
        }
        obstacles[currObstacle].position.x -= CGFloat(currSpeed) * 1.7
        for saw in obstacles[currObstacle].children {
            saw.zRotation -= 0.5
        }
        if(obstacles[currObstacle].position.x < -1 * screenSize.width - 100) {
            newObstacle()
        }
    }
}
