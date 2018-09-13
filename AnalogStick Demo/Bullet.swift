//
//  bullet.swift
//  AnalogStick Demo
//
//  Created by Squidward on 9/1/18.
//  Copyright © 2018 xaxby. All rights reserved.
//

import Foundation
import SpriteKit


class bullet {
    var distance : CGFloat
    var position : CGPoint
    var faceRight : Bool
    init(distance: CGFloat, position: CGPoint, faceRight: Bool) {
        self.distance = distance
        self.position = position
        self.faceRight = faceRight
    }
    
    func shoot(){
        
        
        let bullet = SKSpriteNode(imageNamed: "gray.png")
        //bullet.size.width = 5
        //bullet.size.height = 5
        bullet.position = position
        
        if(faceRight){
            self.distance = position.x + 1000
        }else{
            self.distance = position.x - 1000
        }
        
        
        let time: Double = 5
        let scale = SKAction.scale(to: 0.01, duration: 0)
        let move = SKAction.moveTo(x: distance, duration: time)
        
        let sequence = SKAction.sequence([scale, move])
        bullet.run(sequence)
        
    }
}
