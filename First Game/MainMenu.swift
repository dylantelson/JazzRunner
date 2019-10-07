//
//  MainMenu.swift
//  First Game
//
//  Created by Dylan Telson on 10/2/19.
//  Copyright © 2019 Dylan Telson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MainMenu: SKScene, SKPhysicsContactDelegate {
    var myButton = SKSpriteNode()
    var ball = SKSpriteNode()
    
    
    var touchedCoords = CGPoint(x: 0, y: 0)
    var releasedCoords = CGPoint(x: 0, y: 0)
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -17)
        myButton = self.childNode(withName: "button") as! SKSpriteNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        let touch = touches.first!
        touchedCoords = touch.location(in: self.view)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        releasedCoords = touch.location(in: self.view)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.applyImpulse(CGVector(dx: (touchedCoords.x - releasedCoords.x) * 13, dy: (releasedCoords.y - touchedCoords.y) * 13))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(myButton.position.x != 3) {
            myButton.position.x = 3
        }
        if(myButton.position.y > -111) {
            myButton.position.y = -111
        }
        if(myButton.position.y < -130) {
            let transition : SKTransition = SKTransition.fade(withDuration: 0.1)
            let newScene = GameScene(fileNamed: "GameScene")
            newScene!.scaleMode = SKSceneScaleMode.aspectFill
            DispatchQueue.main.async {
                self.view?.presentScene(newScene!, transition: transition)
            }
        }
    }

}
