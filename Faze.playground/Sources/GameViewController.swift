import UIKit
import SceneKit
import AVFoundation
import Vision

public class GameViewController: UIViewController {
    
    let barrelCategory = 0b0100
    let finishCubeCategory = 0b1111
    
    var game : Game!
    
    var sceneView : SceneView!
    var scene : SCNScene!
    var status : StatusOverlay!
    var help : HelpPopup!
    var maze : Maze!
   
    var ballNode : SCNNode!
    var boardNode : SCNNode!
    var barrelsNode : [SCNNode]!
    
    var faceObserver : FaceObserver!
    var gesture : UITapGestureRecognizer!
    
    public init(ofGame game: Game) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    override public func viewDidLoad() {
        setupScene()
        setupNodes()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.faceObserver.stopObservation()
    }
    
    func setupNodes() {
        boardNode = maze.board
        barrelsNode = maze.barrels
        ballNode = maze.ball
    }
    
    func setupFaceObserver() {
        self.faceObserver = FaceObserver(onCameraAccepted: {
            self.game.setStopwatchTrigger() { (time) in self.status.updateCurrentTime(time) }
            self.game.setNewBestTrigger() { (time) in self.status.updateBestTime(time) }
        }, onCameraDenied: {
            self.cameraDenied()
        }, onFaceObserved: { (request: VNRequest, error: Error?) in
            self.onFaceObservation(request,error)
        })
        self.game.pauseStopwatch()
        self.game.startNewGame()
        self.faceObserver.startObservation()
    }
    
    func setupScene() {
        self.maze = Maze(defaults)
        self.scene = maze.boardScene
        
        self.sceneView = SceneView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.sceneView.setupView(scene: scene)
        self.scene.physicsWorld.contactDelegate = self
        self.view = sceneView
        
        self.status = StatusOverlay(frame: self.view.frame)
        
        self.game.setStopwatchTrigger() { (time) in self.status.updateCurrentTime(time) }
        self.game.setNewBestTrigger() { (time) in self.status.updateBestTime(time) }
        self.view.addSubview(status)
        
        self.initializePopup()
    }
    
    func initializePopup() {
        self.help = HelpPopup(frame: self.view.frame)
        self.gesture = UITapGestureRecognizer(target: self, action:  #selector(self.closePopup))
        self.view.addGestureRecognizer(self.gesture)
        
        self.view.addSubview(help)
        self.status.toggleBlurredBackground(to: true)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func closePopup(sender : UITapGestureRecognizer) {
        self.status.toggleBlurredBackground(to: false)
        self.help.removeFromSuperview()
        self.setupFaceObserver()
        self.maze.resetGame()
    }

    func cameraDenied() {
        let alert = UIAlertController(title: "Camera access denied", message: "You have to allow camera access to play the game", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in })
        alert.addAction(okAction)
        alert.view.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        self.present(alert, animated: true, completion: nil)
    }
    

    func onFaceObservation(_ request: VNRequest,_ error: Error?) {
        for observation in request.results as! [VNFaceObservation] {
            if let yaw = observation.yaw, let roll = observation.roll {
                if yaw.doubleValue != 0.0 {
                    let vector = self.game.getForceVector(ofAngle: roll, movingLeft: yaw.doubleValue > 0)
                    self.ballNode.physicsBody?.applyForce(vector, asImpulse: true)
                }
            }
            else {
                self.ballNode.physicsBody?.clearAllForces()
            }
        }
    }

    override public var shouldAutorotate: Bool {
        return false
    }
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        status.layoutComponents(frame: self.view.frame)
        help.layoutComponents(frame: self.view.frame)
    }
}

extension GameViewController : SCNPhysicsContactDelegate {

    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode:SCNNode!
        
        if contact.nodeA.name == "ball" {
            contactNode = contact.nodeB
        }else{
            contactNode = contact.nodeA
        }

        if contactNode.physicsBody?.categoryBitMask == barrelCategory {
           handleBarrelCollision(contactNode)
        }
        
        if contactNode.physicsBody?.categoryBitMask == finishCubeCategory {
            handleFinishCubeCollision(contactNode)
        }
    }
    
    public func handleBarrelCollision(_ contactNode: SCNNode) {
        contactNode.addParticleSystem(self.maze.fire)
        let waitAction = SCNAction.wait(duration: 2)
        let unhideAction = SCNAction.run { (node) in
            node.removeAllParticleSystems()
            node.isHidden = true
        }
        
        let actionSequence = SCNAction.sequence([waitAction, unhideAction])
        contactNode.runAction(actionSequence)
        self.maze.resetBall()
    }
    
    public func handleFinishCubeCollision(_ contactNode: SCNNode) {
        let alert = UIAlertController(title: "Well done!", message: "You have finshed the Faze game. Try again and set a new record!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            self.maze.resetGame()
            self.game.pauseStopwatch()
            self.game.startNewGame()
        })
        alert.addAction(okAction)
        
        alert.view.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        self.present(alert, animated: true, completion: nil)
        
        self.maze.resetGame()
        self.game.endGame()
    }
}
