//
//  AnimatedErrorView.swift
//  CWProgressHUD
//
//  Created by Chrishon Wyllie on 12/15/17.
//

import UIKit

@IBDesignable internal class AnimatedErrorView: UIView {
    
    private var errorAnimationLeftLayer: CAShapeLayer?
    private var errorAnimationRightLayer: CAShapeLayer?
    private var animationLayers: [CAShapeLayer] = []
    public var animationLayerColor: UIColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0)
    public var animationLayerWidth: CGFloat = 3.6
    public var animationDuration: Double = 0.25
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        initializeAnimationLayers()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeAnimationLayers()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Perhaps the _ = animationLayers.map {} causes the layers to not be visible
        // Reset the colors in case the theme was changed
        
        errorAnimationLeftLayer?.strokeColor = animationLayerColor.cgColor
        errorAnimationRightLayer?.strokeColor = animationLayerColor.cgColor
        
        setBezierPath(forLayers: animationLayers)
        
    }
    
    private func initializeAnimationLayers() {
        
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
        errorAnimationLeftLayer = CAShapeLayer()
        errorAnimationRightLayer = CAShapeLayer()
        animationLayers.append(errorAnimationLeftLayer!)
        animationLayers.append(errorAnimationRightLayer!)
        
        _ = animationLayers.map {
            
            $0.fillColor = nil
            //$0.strokeColor = animationLayerColor.cgColor
            $0.strokeStart = 0.0
            $0.strokeEnd = 0.0
            $0.lineWidth = animationLayerWidth
            
            // Makes the ends of the trackLayer rounded, or otherwise...
            $0.lineCap = kCALineCapRound
            // Makes the bottom part of the checkmark rounded, or otherwise. Basically wherever another line is added (addLine function)
            $0.lineJoin = kCALineJoinRound
            // This causes a cut off at the bottom of the checkmark
            //layer.lineJoin = kCALineJoinBevel
            
        }
        
        
    }
    
    private func setBezierPath(forLayers layers: [CAShapeLayer]) {
        
        let leftErrorPath = UIBezierPath()
        let rightErrorPath = UIBezierPath()
        leftErrorPath.move(to: CGPoint(x: bounds.width * 0.08, y: bounds.height * 0.08))
        leftErrorPath.addLine(to: CGPoint(x: bounds.width * 0.92, y: bounds.height * 0.92))
        
        rightErrorPath.move(to: CGPoint(x: bounds.width * 0.92, y: bounds.height * 0.08))
        rightErrorPath.addLine(to: CGPoint(x: bounds.width * 0.08, y: bounds.height * 0.92))
        
        layers[0].path = leftErrorPath.cgPath
        layers[1].path = rightErrorPath.cgPath
        
        _ = layers.map {
            $0.frame = self.bounds
            self.layer.addSublayer($0)
        }
    }
    
    private lazy var errorAnimation: CABasicAnimation = {
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
        // In the case of the DisplayView, it is 0.5 seconds
        self.errorAnimationLeftLayer?.add(self.errorAnimation, forKey: "strokeEnd")
        self.errorAnimationRightLayer?.add(self.errorAnimation, forKey: "strokeEnd")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
