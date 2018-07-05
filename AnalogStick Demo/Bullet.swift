import Foundation
import SpriteKit

class Bullet: SKNode {
    let bulletSpeed:CGFloat = 15;
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init (pos:CGPoint) {
        super.init();
        let bulletSprite = SKSpriteNode(imageNamed:"cat_blast_ball_1")
        self.position = pos;
        
        self.addChild(bulletSprite)
        
        bulletSprite.size = CGSize(width: 200, height: 200)
        bulletSprite.xScale = 0.4;
        bulletSprite.yScale = 0.4;
        bulletSprite.physicsBody = SKPhysicsBody(circleOfRadius: bulletSprite.size.width / 2)
        bulletSprite.physicsBody!.categoryBitMask = BodyType.bullet.rawValue
        bulletSprite.physicsBody!.contactTestBitMask = BodyType.wheelObject.rawValue | BodyType.deathObject.rawValue | BodyType.enemy.rawValue
        bulletSprite.physicsBody!.friction = 1
        bulletSprite.physicsBody!.isDynamic = true
        bulletSprite.physicsBody!.affectedByGravity = false
        bulletSprite.physicsBody!.restitution = 0
        bulletSprite.physicsBody!.allowsRotation = true
        self.zPosition = 102
    }
    
    func bulletDirection(_ facingRight: Bool){
        
    }
    
    func update(){
        self.position.x += bulletSpeed;
    }
}
