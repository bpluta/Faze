import SpriteKit
import Foundation
import AVFoundation

public class HelpPopup: UIView {
    
    var background : UIView!
    var statusBackground : UIVisualEffectView!
    var playerLayer : AVPlayerLayer!
    var player : AVPlayer!
    var titleLabel : UILabel!
    var descriptionLabel : UILabel!
    var secondDescriptionLabel : UILabel!
    
    var playerWidth: CGFloat!
    var playerHeight: CGFloat!
    
    var playbackOvserver: NotificationCenter!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initBackground()
        createTitleLabel()
        createDescriptionLabel()
        createSecondDescriptionLabel()
        playVideo(fileName: "faceControl", fileType: "mov")
    }
    
    func playVideo(fileName: String, fileType: String) {
        let urlString = Bundle.main.path(forResource: fileName, ofType: fileType)
        let url = URL(fileURLWithPath: urlString!)
        let item = AVPlayerItem(url: url)
        let currentPlayer = AVPlayer(playerItem: item)
        let currentPlayerLayer = AVPlayerLayer(player: currentPlayer)
        self.layer.addSublayer(currentPlayerLayer)
        
        self.player = currentPlayer
        self.playerLayer = currentPlayerLayer
    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { notification in
            self.player.seek(to: CMTime.zero)
            self.player.play()
        }
        self.player.isMuted = true
        self.player.play()
    }
    
    func startPlaying() {
        if self.player != nil {
            self.player.play()
        }
    }
    
    public func createTitleLabel() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Helvetica", size: 40)
        titleLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        titleLabel.textAlignment = .center
        
        titleLabel.text = "Welcome to Faze!"
        self.addSubview(titleLabel)
    }
    
    public func createDescriptionLabel() {
        descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.numberOfLines = 5
        descriptionLabel.font = UIFont(name: "Helvetica", size: 15)
        descriptionLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        descriptionLabel.textAlignment = .center
        
        descriptionLabel.text = "Faze is a face-controlled maze game created with Vision and SceneKit framework."
        self.addSubview(descriptionLabel)
    }
    
    
    public func createSecondDescriptionLabel() {
        secondDescriptionLabel = UILabel(frame: .zero)
        secondDescriptionLabel.numberOfLines = 5
        secondDescriptionLabel.font = UIFont(name: "Helvetica", size: 15)
        secondDescriptionLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        secondDescriptionLabel.textAlignment = .center
        
        secondDescriptionLabel.text = "In order to move a ball simply turn your head left or right. The direction of Your move depends on Your head roll relative to the iPad."
        self.addSubview(secondDescriptionLabel)
    }
    
    func stopVideo() {
        if self.player != nil {
            self.player.pause()
        }
    }
    
    func initBackground() {
        self.background = UIView(frame: .zero)
        self.background.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.background.layer.cornerRadius = 25
        
        self.addSubview(self.background)
    }
    
    public func createStatusBackground() {
        statusBackground = UIVisualEffectView(effect : UIBlurEffect(style: .dark))
        
        self.addSubview(statusBackground)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("error")
        
    }
    
    public func layoutComponents(frame: CGRect) {

        self.background.frame = CGRect(x: frame.size.width/2 - 200, y: frame.size.height/2 - 300, width: 400, height: 600)
        if self.playerLayer != nil {
            self.playerLayer.frame = CGRect(x: (frame.size.width/2) - 200, y: (frame.size.height/2), width: 400, height: 200)
        }
        self.titleLabel.frame = CGRect(x: frame.size.width/2 - 200, y: frame.size.height/2 - 230, width: 400, height: 40)
        
        self.descriptionLabel.frame = CGRect(x: frame.size.width/2 - 150, y: frame.size.height/2 - 170, width: 300, height: 40)
        
        self.secondDescriptionLabel.frame = CGRect(x: frame.size.width/2 - 150, y: frame.size.height/2 - 120, width: 300, height: 100)

        
    }
}
