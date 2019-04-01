import Foundation
import SceneKit

public class SceneView: SCNView {
    
    public override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
    }
    public override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 480, height: 640))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setupView(scene: SCNScene) {
        self.scene = scene
        self.allowsCameraControl = true
        self.defaultCameraController.interactionMode = .truck
        self.defaultCameraController.inertiaEnabled = true
        self.defaultCameraController.maximumVerticalAngle = -80
        self.defaultCameraController.minimumVerticalAngle = -100
        self.isPlaying = true
    }
}
