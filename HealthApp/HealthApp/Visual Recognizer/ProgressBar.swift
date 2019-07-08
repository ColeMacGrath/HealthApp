import UIKit

class ProgressBar: UIView {
    
    private var innerProgress: CGFloat = 0.0
    
    var progress : CGFloat {
        set (newProgress){
            if newProgress > 1.0 {
                innerProgress = 1.0
            } else if newProgress < 0.0 {
                innerProgress = 0.0
            } else {
                innerProgress = newProgress
            }
            setNeedsDisplay()
        }
        
        get{
            return innerProgress * bounds.width
        }
    }
    
    override func draw(_ rect: CGRect) {
        drawProgressBar(frame: bounds, progress: progress)
    }
    
    func drawProgressBar(frame: CGRect = CGRect(x: 0, y: 1, width: 288, height: 12),
                         progress : CGFloat = 274){
        let green  = UIColor(red: 100/255, green: 221/255, blue: 23/255, alpha: 1.0)
        let yellow = UIColor(red: 255/255, green: 171/255, blue: 0/255,  alpha: 1.0)
        let red    = UIColor(red: 244/255, green: 67/255,  blue: 54/255, alpha: 1.0)
        
        
        
        let progressPath = UIBezierPath(roundedRect: CGRect(x: frame.minX+1, y: frame.minY+1, width: frame.width-2, height: frame.height-2),
                                        cornerRadius: ( frame.height-2)/2)
        if progress / bounds.width <= 0.66666 {
            red.setStroke()
        } else  if progress / bounds.width <= 0.8333333 {
            yellow.setStroke()
        } else {
            green.setStroke()
        }
        progressPath.lineWidth = 1
        progressPath.stroke()
        progressPath.addClip()
        
        
        let progressActivePath = UIBezierPath(roundedRect: CGRect(x:1, y:1, width: progress, height: frame.height-2), cornerRadius: (frame.height - 2)/2)
        
        if progress / bounds.width <= 0.66666 {
            red.setFill()
        } else  if progress / bounds.width <= 0.8333333 {
            yellow.setFill()
        } else {
            green.setFill()
        }
        progressActivePath.fill()
    }
}
