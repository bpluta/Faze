import SpriteKit
import Foundation

public class StatusOverlay: UIView {
    var timeLabel : UILabel!
    var bestLabel : UILabel!
    var titleLabel : UILabel!
    var statusBackground : UIVisualEffectView!
    var blurredBackground : UIVisualEffectView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        createStatusBackground()
        createTimeLabel()
        createBestLabel()
        createTitleLabel()
        createBlurredBackground()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    public func layoutComponents(frame: CGRect) {
        statusBackground.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 70)
        bestLabel.frame = CGRect(x: 20, y: 12, width: frame.size.width, height: 20)
        timeLabel.frame = CGRect(x: 20, y: 37, width: frame.size.width, height: 20)
        titleLabel.frame = CGRect(x: frame.size.width/2-50, y: 20, width: 100, height: 30)
        blurredBackground.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    
    public func createTimeLabel() {
        timeLabel = UILabel(frame: .zero)
        timeLabel.numberOfLines = 0
        timeLabel.font = UIFont(name: "Helvetica", size: 20)
        timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timeLabel.textAlignment = .left
        
        timeLabel.text = formatTime(nil)
        self.addSubview(timeLabel)
    }
    
    public func createTitleLabel() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Helvetica", size: 30)
        titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        titleLabel.textAlignment = .center
        
        titleLabel.text = "Faze"
        self.addSubview(titleLabel)
    }
    
    public func createBlurredBackground() {
        blurredBackground = UIVisualEffectView(effect : UIBlurEffect(style: .light))
        blurredBackground.isHidden = true
        self.addSubview(blurredBackground)
    }
    
    public func toggleBlurredBackground(to value: Bool) {
        if blurredBackground != nil {
            blurredBackground.isHidden = !value
        }
    }
    
    public func createBestLabel() {
        bestLabel = UILabel(frame: .zero)
        bestLabel.numberOfLines = 0
        bestLabel.font = UIFont(name: "Helvetica", size: 18)
        bestLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        bestLabel.textAlignment = .left
        
        bestLabel.text = formatTime(nil)
        self.addSubview(bestLabel)
    }
    
    public func createStatusBackground() {
        statusBackground = UIVisualEffectView(effect : UIBlurEffect(style: .light))
        
        self.addSubview(statusBackground)
    }
    
    public func updateCurrentTime(_ currentTime: Int?) {
        self.timeLabel.text = formatTime(currentTime)
    }
    
    public func updateBestTime(_ recordTime: Int) {
        self.bestLabel.text = formatTime(recordTime)
    }
    
    public func formatTime(_ currentTime: Int?) -> String {
        if currentTime != nil {
            let minutes = Int(floor(Double(currentTime!)/60.0))
            let seconds = currentTime!%60
            return "\(minutes < 10 ? "0\(minutes)" : "\(minutes)" ):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")"
        }
        else { return "- - : - -" }
    }
}
