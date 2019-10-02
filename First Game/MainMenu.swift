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

class MainMenu: SKScene {
    var myButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        myButton = self.childNode(withName: "button") as! SKSpriteNode
        myButton.color = SKColor.blue
        myButton.size = CGSize(width: 100, height: 44)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if myButton.contains(touchLocation) {
            let transition : SKTransition = SKTransition.fade(withDuration: 0.1)
            let newScene = GameScene(fileNamed: "GameScene")
            newScene!.scaleMode = SKSceneScaleMode.aspectFill
            DispatchQueue.main.async {
                self.view?.presentScene(newScene!, transition: transition)
            }
        }
        
    }

}
