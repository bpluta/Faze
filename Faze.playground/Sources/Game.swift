import Foundation
import SceneKit
import UIKit

public class Game {
    var forceValue : Float
    var currentTime : Int
    var bestTime : Int?
    var isStopwatchRunning : Bool
    var stopwatch : Timer!
    var onStopwatchTick : (Int) -> ()
    var onNewBest : (Int) -> ()
    
    public init(forceValue: Float = 0.5) {
        self.forceValue = forceValue
        self.currentTime = 0
        self.isStopwatchRunning = false
        self.onStopwatchTick = { (a: Int) -> () in }
        self.onNewBest = { (a: Int) -> () in }
    }
    
    func setStopwatchTrigger(function: @escaping (Int) -> ()) {
        self.onStopwatchTick = function
    }
    
    func setNewBestTrigger(function: @escaping (Int) -> ()) {
        self.onNewBest = function
    }
    
    func getForceVector(ofAngle angle : NSNumber, movingLeft : Bool) -> SCNVector3{
        let roundFactor : Float = 1000.0
        let angle = angle as! Float
        
        let direction : Float = movingLeft ? 1.0 : -1.0
        let z = direction*round(sin(angle) * forceValue * roundFactor) / roundFactor
        let x = direction*round(cos(angle) * forceValue * roundFactor) / roundFactor
        
        return SCNVector3(x: x, y: 0, z: z)
    }
    
    func startStopwatch() {
        if isStopwatchRunning { return }
        self.onStopwatchTick(self.currentTime)
        self.stopwatch = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            self.currentTime += 1
            self.onStopwatchTick(self.currentTime)
        }
    }
    
    func pauseStopwatch() {
        if self.stopwatch != nil {
            self.stopwatch.invalidate()
        }
        self.isStopwatchRunning = false
        
    }
    
    func resetStopwatch() {
        self.pauseStopwatch()
        self.currentTime = 0
        self.onStopwatchTick(self.currentTime)
    }
    
    func startNewGame() {
        self.pauseStopwatch()
        self.resetStopwatch()
        self.currentTime = 0
        self.isStopwatchRunning = false
        self.startStopwatch()
    }
    
    func endGame() {
        self.pauseStopwatch()
        if bestTime == nil {
            self.bestTime = self.currentTime
            self.onNewBest(self.bestTime!)
        }
        else if self.bestTime! > self.currentTime {
            self.bestTime = self.currentTime
            self.onNewBest(self.bestTime!)
        }
        self.resetStopwatch()
    }
}
