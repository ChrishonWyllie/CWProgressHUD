//
//  AnimatedCheckmarkView.swift
//  CWProgressHUD
//
//  Created by Chrishon Wyllie on 12/15/17.
//

import UIKit

@IBDesignable internal class AnimatedCheckmarkView: UIView {
    
    private var checkmarkAnimationLayer: CAShapeLayer?
    public var animationLayerColor: UIColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 60/255)
    public var animationLayerWidth: CGFloat = 3.6
    public var animationDuration: Double = 0.25
    //private var animationMask: CALayer?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //initializeAnimationLayer()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //initializeAnimationLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        initializeAnimationLayer()
        
        setBezierPath(forLayer: checkmarkAnimationLayer!)
        
    }
    
    private func initializeAnimationLayer() {
        
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
        
        checkmarkAnimationLayer = CAShapeLayer()
        checkmarkAnimationLayer?.fillColor = nil
        checkmarkAnimationLayer?.strokeColor = animationLayerColor.cgColor
        checkmarkAnimationLayer?.strokeStart = 0.0
        checkmarkAnimationLayer?.strokeEnd = 0.0
        checkmarkAnimationLayer?.lineWidth = animationLayerWidth
        
        // Makes the ends of the trackLayer rounded, or otherwise...
        checkmarkAnimationLayer?.lineCap = kCALineCapRound
        // Makes the bottom part of the checkmark rounded, or otherwise. Basically wherever another line is added (addLine function)
        checkmarkAnimationLayer?.lineJoin = kCALineJoinRound
        // This causes a cut off at the bottom of the checkmark
        //layer.lineJoin = kCALineJoinBevel
    }
    
    
    
    private func setBezierPath(forLayer layer: CAShapeLayer) {
        
        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: bounds.width * 0.08, y: bounds.height * 0.60))
        checkmarkPath.addLine(to: CGPoint(x: bounds.width * 0.30, y: bounds.height * 0.80))
        checkmarkPath.addLine(to: CGPoint(x: bounds.width * 0.92, y: bounds.height * 0.20))
        
        layer.path = checkmarkPath.cgPath
        layer.frame = self.bounds
        
        self.layer.addSublayer(layer)
    }
    
    private lazy var checkmarkAnimation: CABasicAnimation = {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = animationDuration
        pathAnimation.fromValue = NSNumber(floatLiteral: 0)
        pathAnimation.toValue = NSNumber(floatLiteral: 1)
        // Keep from disappearing after
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.fillMode = kCAFillModeBoth
        return pathAnimation
    }()
    
    func beginAnimation() {
        
        // Timer.scheduledTimer(withTimeInterval: <#T##TimeInterval#>, repeats: <#T##Bool#>, block: <#T##(Timer) -> Void#>)
        // Is only available on iOS 10.0 and greater. Although it may be unlikely this will be used with apps with
        // lower build targets, here is a safe approach.
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                self.beginAnimationsAfterTimePeriod()
            }
        } else {
            // Fallback on earlier versions
            
            _ = Timer(timeInterval: 0.5, target: self, selector: #selector(beginAnimationsAfterTimePeriod), userInfo: nil, repeats: false)
        }
        
    }
    
    @objc private func beginAnimationsAfterTimePeriod() {
        // Wait for the view to finish animating to the center of the screen
        self.checkmarkAnimationLayer?.add(self.checkmarkAnimation, forKey: "strokeEnd")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
