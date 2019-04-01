import PlaygroundSupport
import Foundation

let ballForce : Float = 0.3
let game = Game(forceValue: ballForce)

let viewController = GameViewController(ofGame: game)

PlaygroundSupport.PlaygroundPage.current.liveView = viewController

