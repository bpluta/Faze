import Foundation
import SceneKit

let fire = "fire.scnp"
let finish = "finish.scn"
let board = "maze.scn"
let ball = "ball.scn"
let barrel = "barrel.scn"

let defaults = LevelDefaults(
    startPosition: SCNVector3(8, 1, -8),
    finishPosition: SCNVector3(-7.5, 0.5, 6),
    barrelsPositions: [
        SCNVector3(-8, 1.5, 8),
        SCNVector3(-4, 1.5, 3.5),
        SCNVector3(7, 1.5, -1),
        SCNVector3(4, 1.5, -2.5),
        SCNVector3(3, 1.5, 7),
        SCNVector3(-4, 1.5, -7),
        SCNVector3(-8.5, 1.5, 1),
        SCNVector3(0, 1.5, 4),
        SCNVector3(8, 1.5, 7)
    ]
)


struct LevelDefaults {
    
    var fireParticle : String
    var boardModel : String
    
    var finishModel : String
    var finishPosition : SCNVector3
    
    var ballModel : String
    var startPosition : SCNVector3
    
    var barrelsModel : String
    var barrelsPositions : [SCNVector3]
    
    init() {
        self.boardModel = board
        self.ballModel = ball
        self.barrelsModel = barrel
        self.fireParticle = fire
        self.finishModel = finish
        
        self.startPosition = SCNVector3(x:0,y:0,z:0)
        self.finishPosition = SCNVector3(x:0,y:0,z:0)
        self.barrelsPositions = []
    }
    
    init(startPosition: SCNVector3, finishPosition: SCNVector3, barrelsPositions: [SCNVector3]) {
        self.init()
        self.startPosition = startPosition
        self.finishPosition = finishPosition
        self.barrelsPositions = barrelsPositions
    }
}
