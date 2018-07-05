import SpriteKit
import AudioToolbox

class GameScene: SKScene {
    
    var idle = true
    
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    
    var TextureAtlasWalk = SKTextureAtlas()
    var TextureAtlasIdle = SKTextureAtlas()
    var TextureAtlasBlast = SKTextureAtlas()
    var TextureAtlasBlastBall = SKTextureAtlas()
    var TextureAtlasBlastBallEnd = SKTextureAtlas()
    var TextureAtlasSuperCat = SKTextureAtlas()
    var TextureAtlasCatKick = SKTextureAtlas()
    var TextureAtlasCharge = SKTextureAtlas()



    var TextureArrayWalk = [SKTexture]()
    var TextureArrayIdle = [SKTexture]()
    var TextureArrayBlast = [SKTexture]()
    var TextureArrayBlastHold = [SKTexture]()
    var TextureArrayBlastBall = [SKTexture]()
    var TextureArrayBlastBallEnd = [SKTexture]()
    var TextureArraySuperCat = [SKTexture]()
    var TextureArraySuperCatHold = [SKTexture]()
    var TextureArrayCatKick = [SKTexture]()
    var TextureArrayCharge = [SKTexture]()
    var TextureArrayChargeHold = [SKTexture]()




    var background = SKSpriteNode( imageNamed : "clouds")
    var touching_wall = false
    var blasting = false
    var facingRight = true;
    
    var appleNode: SKSpriteNode?
    var blastNode : SKSpriteNode?
    let setJoystickStickImageBtn = SKLabelNode()
    let setJoystickSubstrateImageBtn = SKLabelNode()
    
    let moveAnalogStick = 🕹(diameter: 110) // from Emoji
    let rotateAnalogStick = AnalogJoystick(diameter: 100) // from Class
    let blastButton = 🕹(diameter: 50)
    let kickButton = 🕹(diameter: 50)
    let superKickButton = 🕹(diameter: 50)
    
    override func didMove(to view: SKView) {
       
        setUp()
        setUpBlastHandlers()
        setUpCatHandlers()
        setUpKickHandler()
        setSuperKickHandler()
    }
    
    override func update(_ currentTime: TimeInterval) {
        outOfBounds()
    }
    
 
    func catAnimation(_ animation: [SKTexture], _ action: String){
        
        var anim = [SKTexture]()
        anim = animation
        
        if action == "Cat"{
            guard let aN = self.appleNode else {
                return
            }
            aN.run(SKAction.repeatForever(SKAction.animate(with: anim, timePerFrame: 0.1)))

        }
        
        if action == "Blast"{
            guard let bN = self.blastNode else {
                return
            }
            bN.run(SKAction.repeatForever(SKAction.animate(with: anim, timePerFrame: 0.1)))
        }
        
        if action == "BlastEnd"{
            guard let bN = self.blastNode else {
                return
            }
            bN.run(SKAction.repeat(SKAction.animate(with: anim, timePerFrame: 0.1), count: 1))
        }
        
    }//End catAnimation
    func outOfBounds(){
        guard let bN = self.blastNode else {
            return
        }
        guard let aN = self.appleNode else {
            return
        }
        let screenSize = UIScreen.main.bounds
        //print(screenSize.minX,  bN.position.x )
        if  ((bN.position.x >= screenSize.maxX - 65) && touching_wall == false) || ((bN.position.x <= screenSize.minX + 65) && touching_wall == false)  {
            bN.removeAllActions()
            bN.physicsBody?.isDynamic = false
            catAnimation(TextureArrayBlastBallEnd, "BlastEnd")
            touching_wall = true
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.appleNode!.run(SKAction.repeatForever(SKAction.animate(with: self.TextureArrayIdle, timePerFrame: 0.1)))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        if let touch = touches.first {
            let node = atPoint(touch.location(in: self))
            
            switch node {
            case setJoystickStickImageBtn:
                joystickStickImageEnabled = !joystickStickImageEnabled
            case setJoystickSubstrateImageBtn:
                joystickSubstrateImageEnabled = !joystickSubstrateImageEnabled
            default:
                break
                //print("Otherwise, do something else.")
                //addApple(touch.location(in: self))
            }
        }
    }
    func setRandomStickColor() {
        let randomColor = UIColor.random()
        moveAnalogStick.stick.color = randomColor
        rotateAnalogStick.stick.color = randomColor
    }
    
    func setRandomSubstrateColor() {
        let randomColor = UIColor.random()
        moveAnalogStick.substrate.color = randomColor
        rotateAnalogStick.substrate.color = randomColor
    }
    var joystickStickImageEnabled = true {
        didSet {
            let image = joystickStickImageEnabled ? UIImage(named: "jStick") : nil
            moveAnalogStick.stick.image = image
            rotateAnalogStick.stick.image = image
            //setJoystickStickImageBtn.text = "\(joystickStickImageEnabled ? "Remove" : "Set") stick image"
            let image2 = joystickStickImageEnabled ? UIImage(named: "jStick") : nil
            blastButton.stick.image = image2
            kickButton.stick.image = image2
            superKickButton.stick.image = image2
        }
    }
    var joystickSubstrateImageEnabled = true {
        didSet {
            let image = joystickSubstrateImageEnabled ? UIImage(named: "jSubstrate") : nil
            moveAnalogStick.substrate.image = image
            rotateAnalogStick.substrate.image = image
            //setJoystickSubstrateImageBtn.text = "\(joystickSubstrateImageEnabled ? "Remove" : "Set") substrate image"
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Setup
    func setUp(){
        
        //Declaration of background
        backgroundColor = UIColor.white
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        screenWidth = self.view!.bounds.width
        screenHeight = self.view!.bounds.height
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        moveAnalogStick.position = CGPoint(x: moveAnalogStick.radius + 15, y: moveAnalogStick.radius + 15)
        rotateAnalogStick.position = CGPoint(x: self.frame.maxX - rotateAnalogStick.radius - 15, y:rotateAnalogStick.radius + 15)
        blastButton.position = CGPoint(x: moveAnalogStick.radius , y: moveAnalogStick.radius + 100)
        kickButton.position = CGPoint(x: moveAnalogStick.radius + 50, y: moveAnalogStick.radius + 100)
        superKickButton.position = CGPoint(x: moveAnalogStick.radius + 100, y: moveAnalogStick.radius + 100)

        let btnsOffset: CGFloat = 10
        let btnsOffsetHalf = btnsOffset / 2
        
        setJoystickStickImageBtn.fontColor = UIColor.black
        setJoystickStickImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .bottom
        setJoystickStickImageBtn.position = CGPoint(x: frame.midX, y: moveAnalogStick.position.y - btnsOffsetHalf)
        setJoystickSubstrateImageBtn.fontColor  = UIColor.black
        setJoystickSubstrateImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .top
        setJoystickSubstrateImageBtn.position = CGPoint(x: frame.midX, y: moveAnalogStick.position.y + btnsOffsetHalf)
        
        joystickStickImageEnabled = true
        joystickSubstrateImageEnabled = true
        
        setRandomStickColor()
        
        addApple(CGPoint(x: frame.midX, y: frame.midY))
        addChild(moveAnalogStick)
        addChild(rotateAnalogStick)
        addChild(blastButton)
        addChild(kickButton)
        addChild(superKickButton)
        addChild(setJoystickSubstrateImageBtn)
        addChild(setJoystickStickImageBtn)
        
        view?.isMultipleTouchEnabled = true
        
        blastNode?.physicsBody = SKPhysicsBody(circleOfRadius: max(blastNode!.size.width / 2, blastNode!.size.height / 2))
        blastNode?.physicsBody?.affectedByGravity = false
        blastNode?.physicsBody?.restitution = 0.0
        
    }
    func setUpCatHandlers(){
        //Movement Controls
        moveAnalogStick.beginHandler = { [unowned self] in
            guard let aN = self.appleNode else {
                return
            }
            self.catAnimation(self.TextureArrayWalk, "Cat")
            AudioServicesPlaySystemSound(1519)
        }
        moveAnalogStick.trackingHandler = { [unowned self] data in
            guard let aN = self.appleNode else {
                return
            }
            aN.position = CGPoint(x: aN.position.x + (data.velocity.x * 0.12), y: aN.position.y + (data.velocity.y * 0.12))
            if(data.velocity.x < 0){
                aN.run(SKAction.sequence([SKAction.scaleX(to: -1, duration: 0.4)] ))
                self.facingRight = false
            }
            if(data.velocity.x > 0){
                aN.run(SKAction.sequence([SKAction.scaleX(to: 1, duration: 0.4)] ))
                self.facingRight = true
            }
        }
        moveAnalogStick.stopHandler = { [unowned self] in
            //self.appleNode!.removeAllActions()
            guard let aN = self.appleNode else {
                return
            }
            self.catAnimation(self.TextureArrayIdle, "Cat")
        }
        
        //Rotation Controls
        rotateAnalogStick.trackingHandler = { [unowned self] jData in
            //self.appleNode?.zRotation = jData.angular
        }
        rotateAnalogStick.stopHandler =  { [unowned self] in
            guard let aN = self.appleNode else {
                return
            }
        }
    }
    func setSuperKickHandler(){
        
        //Blast Controls
        superKickButton.beginHandler = { [unowned self] in
            guard let aN = self.appleNode else {
                return
            }
            guard let bN = self.blastNode else {
                return
            }
            self.blasting = false;
        
            aN.run(SKAction.repeat(SKAction.animate(with: self.TextureArrayCharge, timePerFrame: 0.1), count: 1))
            {
                aN.run(SKAction.repeatForever(SKAction.animate(with: self.TextureArrayChargeHold, timePerFrame: 0.05)))
                bN.run(SKAction.repeatForever(SKAction.animate(with: self.TextureArraySuperCat, timePerFrame: 0.05)))
                self.touching_wall = false
                bN.position = CGPoint(x:aN.position.x + 20, y: aN.position.y)
                bN.isHidden = false
                bN.physicsBody?.isDynamic = true
                if(self.facingRight){
                    bN.run(SKAction.sequence([SKAction.scaleX(to: 1, duration: 0.4)] ))
                    bN.physicsBody?.applyImpulse((CGVector(dx: 180, dy: 0 )))
                }
                if(self.facingRight == false){
                    bN.run(SKAction.sequence([SKAction.scaleX(to: -1, duration: 0.4)] ))
                    bN.physicsBody?.applyImpulse((CGVector(dx: -180, dy: 0 )))
                }
            }
        }
        superKickButton.trackingHandler = { [unowned self] jData in
            if(self.blasting == false){
                //self.catAnimation(self.TextureArraySuperCatHold, "Cat")
                self.blasting = true
            }
            //bN.zRotation = jData.angular
            //bN.physicsBody?.applyImpulse(CGVector (dx: sin(aN.position.x) * 100, dy: cos(aN.position.y) * 100 ))
        }
        superKickButton.stopHandler = { [unowned self] in
            self.catAnimation(self.TextureArrayIdle, "Cat")
            AudioServicesPlaySystemSound(1521)
        }
    }
    func setUpKickHandler(){
        
        //Blast Controls
        kickButton.beginHandler = { [unowned self] in
            guard let aN = self.appleNode else {
                return
            }
            self.blasting = false;
            aN.run(SKAction.repeatForever(SKAction.animate(with: self.TextureArrayCatKick, timePerFrame: 0.05)))
            guard let bN = self.blastNode else {
                return
            }
            self.catAnimation(self.TextureArrayBlastBall, "Blast")
            self.touching_wall = false
            
            bN.position = CGPoint(x:aN.position.x + 20, y: aN.position.y)
            bN.isHidden = false
            bN.physicsBody?.isDynamic = true
            
            if(self.facingRight){
                bN.run(SKAction.sequence([SKAction.scaleX(to: 1, duration: 0.4)] ))
                bN.physicsBody?.applyImpulse((CGVector(dx: 180, dy: 0 )))
            }
            if(self.facingRight == false){
                bN.run(SKAction.sequence([SKAction.scaleX(to: -1, duration: 0.4)] ))
                bN.physicsBody?.applyImpulse((CGVector(dx: -180, dy: 0 )))
            }
        }
        kickButton.trackingHandler = { [unowned self] jData in
            guard let aN = self.appleNode else {
                return
            }
            guard let bN = self.blastNode else {
                return
            }
            
            if(self.blasting == false){
                //self.catAnimation(self.TextureArrayBlastHold, "Cat")
                self.blasting = true
            }
            //bN.zRotation = jData.angular
            //bN.physicsBody?.applyImpulse(CGVector (dx: sin(aN.position.x) * 100, dy: cos(aN.position.y) * 100 ))
        }
        kickButton.stopHandler = { [unowned self] in
            guard let aN = self.appleNode else {
                return
            }
            self.catAnimation(self.TextureArrayIdle, "Cat")
            AudioServicesPlaySystemSound(1521)
        }
    }
    func setUpBlastHandlers(){
        
        //Blast Controls
        blastButton.beginHandler = { [unowned self] in
            guard let aN = self.appleNode else {
                return
            }
            guard let bN = self.blastNode else {
                return
            }
            self.blasting = false;
            aN.run(SKAction.repeat(SKAction.animate(with: self.TextureArrayBlast, timePerFrame: 0.1), count: 1))
            {
                aN.run(SKAction.repeatForever(SKAction.animate(with: self.TextureArrayBlastHold, timePerFrame: 0.1)))
                self.touching_wall = false
                bN.position = CGPoint(x:aN.position.x + 20, y: aN.position.y)
                bN.isHidden = false
                bN.physicsBody?.isDynamic = true
                bN.run(SKAction.repeatForever(SKAction.animate(with: self.TextureArrayBlastBall, timePerFrame: 0.1)))
                if(self.facingRight){
                    bN.run(SKAction.sequence([SKAction.scaleX(to: 1, duration: 0.4)] ))
                    bN.physicsBody?.applyImpulse((CGVector(dx: 180, dy: 0 )))
                }
                if(self.facingRight == false){
                    bN.run(SKAction.sequence([SKAction.scaleX(to: -1, duration: 0.4)] ))
                    bN.physicsBody?.applyImpulse((CGVector(dx: -180, dy: 0 )))
                }
            }
        }
        blastButton.trackingHandler = { [unowned self] jData in
            guard let aN = self.appleNode else {
                return
            }
            guard let bN = self.blastNode else {
                return
            }
            
            if(self.blasting == false){
                self.blasting = true
            }
            //bN.zRotation = jData.angular
            //bN.physicsBody?.applyImpulse(CGVector (dx: sin(aN.position.x) * 100, dy: cos(aN.position.y) * 100 ))
        }
        blastButton.stopHandler = { [unowned self] in
            guard let aN = self.appleNode else {
                return
            }
             self.catAnimation(self.TextureArrayIdle, "Cat")
            AudioServicesPlaySystemSound(1521)
        }
    }
    func addApple(_ position: CGPoint) {
        
        TextureAtlasIdle = SKTextureAtlas(named: "dance")
        
        for i in 1...TextureAtlasIdle.textureNames.count{
            
            let Name = "dance_\(i).png"
            TextureArrayIdle.append(SKTexture (imageNamed: Name))
        }
        
        TextureAtlasBlast = SKTextureAtlas(named: "cat_blast")
        
        for j in 1...4{
            
            let Name2 = "cat_blast_\(j).png"
            TextureArrayBlast.append(SKTexture (imageNamed: Name2))
        }
        
        for j in 1...8{
            
            let Name2 = "cat_blast_\(j+4).png"
            TextureArrayBlastHold.append(SKTexture (imageNamed: Name2))
        }
        
        TextureAtlasWalk = SKTextureAtlas(named: "cat_walk")
        
        for j in 1...TextureAtlasWalk.textureNames.count{
            
            let Name2 = "cat_walk_\(j).png"
            TextureArrayWalk.append(SKTexture (imageNamed: Name2))
        }
        
        TextureAtlasBlastBall = SKTextureAtlas(named: "cat_blast_ball")
        
        for j in 1...TextureAtlasBlastBall.textureNames.count{
            
            let Name2 = "cat_blast_ball_\(j).png"
            TextureArrayBlastBall.append(SKTexture (imageNamed: Name2))
        }
        
        TextureAtlasBlastBallEnd = SKTextureAtlas(named: "cat_blast_end")
        
        for j in 1...TextureAtlasBlastBallEnd.textureNames.count{
            
            let Name2 = "cat_blast_end_\(j).png"
            TextureArrayBlastBallEnd.append(SKTexture (imageNamed: Name2))
        }
        
        TextureAtlasSuperCat = SKTextureAtlas(named: "super_kick")
        
       for j in 1...10{
            
            let Name2 = "high_kick_\(j).png"
            TextureArraySuperCat.append(SKTexture (imageNamed: Name2))
        }
        for j in 1...2{
            
            let Name2 = "high_kick_\(j+8).png"
            TextureArraySuperCatHold.append(SKTexture (imageNamed: Name2))
        }
        TextureAtlasCatKick = SKTextureAtlas(named: "cat_kick")
        
        for j in 1...TextureAtlasCatKick.textureNames.count{
            
            let Name2 = "kick_\(j).png"
            TextureArrayCatKick.append(SKTexture (imageNamed: Name2))
        }
    
        TextureAtlasCharge = SKTextureAtlas(named: "cat_charge")
        for j in 1...TextureAtlasCharge.textureNames.count{
            
            let Name2 = "charge_\(j).png"
            TextureArrayCharge.append(SKTexture (imageNamed: Name2))
        }
        for j in 1...2{
            
            let Name2 = "charge_\(j+4).png"
            TextureArrayChargeHold.append(SKTexture (imageNamed: Name2))
        }
      
        let apple = SKSpriteNode(imageNamed: TextureAtlasWalk.textureNames[0] as String)
        let blast = SKSpriteNode(imageNamed: TextureAtlasBlastBall.textureNames[0] as String)
        
        
        apple.position = position
        blast.position = position
        appleNode = apple
        appleNode?.size = CGSize(width: 100, height: 100)
        blastNode = blast
        blastNode?.size = CGSize(width: 100, height: 100)
        blastNode?.isHidden = true
        addChild(apple)
        addChild(blast)
    }
    
}//End Class
extension UIColor {
    
    static func random() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
