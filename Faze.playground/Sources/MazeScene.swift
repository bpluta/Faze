import SceneKit

public class Maze {
    public var boardScene : SCNScene!
    public var board : SCNNode!
    public var ball : SCNNode!
    public var barrels = [] as [SCNNode]
    public var finish : SCNNode!
    public var fire: SCNParticleSystem!
    
    private let defaults : LevelDefaults

    
    init(_ defaults: LevelDefaults) {
        self.defaults = defaults
        self.fire = SCNParticleSystem(named: defaults.fireParticle, inDirectory: nil)
        setupBoard()
        setupBall()
        setupBarrels()
        setupFinishCube()
    }
    
    func setupBarrels() {
        for barrelPosition in defaults.barrelsPositions {
            self.setupBarrel(atPosition: barrelPosition)
        }
    }
    
    func setupBoard() {
        self.boardScene = SCNScene(named: defaults.boardModel)
        self.board = boardScene.rootNode.childNode(withName: "board", recursively: true)
        self.board.name = "board"
        self.board.castsShadow = true
        self.board.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        self.board.physicsBody?.categoryBitMask = 0b001
        self.board.physicsBody?.collisionBitMask = 0b110
        self.board.physicsBody?.contactTestBitMask = 0b110
    }
    
    func setupBall() {
        let ballScene = SCNScene(named: defaults.ballModel)
        self.ball = ballScene?.rootNode
        self.ball.name = "ball"
        self.ball.castsShadow = true
        self.ball.position.x = defaults.startPosition.x
        self.ball.position.y = defaults.startPosition.y
        self.ball.position.z = defaults.startPosition.z
        self.ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        self.ball.physicsBody?.categoryBitMask = 0b0010
        self.ball.physicsBody?.collisionBitMask = 0b1101
        self.ball.physicsBody?.contactTestBitMask = 0b1111
        
        self.boardScene.rootNode.addChildNode(self.ball)
    }
    
    func setupBarrel(atPosition position: SCNVector3) {
        
        let barrelScene = SCNScene(named: defaults.barrelsModel)
        var barrel = barrelScene?.rootNode
        barrel = barrelScene?.rootNode
        barrel!.name = "barrel"
        barrel!.castsShadow = true
        barrel!.position.x = position.x
        barrel!.position.y = position.y
        barrel!.position.z = position.z
        barrel!.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        barrel!.physicsBody?.categoryBitMask = 0b100
        barrel!.physicsBody?.collisionBitMask = 0b011
        barrel!.physicsBody?.contactTestBitMask = 0b0111
        self.barrels.append(barrel!)

        self.boardScene.rootNode.addChildNode(barrel!)
    }
    
    func setupFinishCube() {
        let finishScene = SCNScene(named: defaults.finishModel)
        self.finish = finishScene?.rootNode
        self.finish.name = "finish"
        self.finish.castsShadow = true
        self.finish.position.x = defaults.finishPosition.x
        self.finish.position.y = defaults.finishPosition.y
        self.finish.position.z = defaults.finishPosition.z
        
        self.finish!.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        self.finish!.physicsBody?.categoryBitMask = 0b1000
        self.finish!.physicsBody?.categoryBitMask = 0b0111
        self.finish!.physicsBody?.categoryBitMask = 0b1111
        
        let rotate = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 2)
        let moveSequence = SCNAction.sequence([rotate])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        self.finish.runAction(moveLoop)
    
        self.boardScene.rootNode.addChildNode(self.finish)
    }
    
    func resetGame() {
        resetBarrels()
        resetBall()
    }
    
    func resetBall() {
        self.ball.position.x = defaults.startPosition.x
        self.ball.position.y = defaults.startPosition.y
        self.ball.position.z = defaults.startPosition.z
        self.ball.physicsBody!.clearAllForces()
    }
    
    func resetBarrels() {
        for barrel in barrels {
            barrel.isHidden = false
        }
    }
}
