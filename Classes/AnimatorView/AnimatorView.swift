//
//  AnimatorView.swift
//  CWProgressHUD
//
//  Created by Chrishon Wyllie on 11/14/17.
//

import Foundation
import UIKit

/*
 Swift 3 & 4 : https://medium.com/@abhimuralidharan/swift-3-0-1-access-control-9e71d641a56c
 Swift 2 and below? : https://stackoverflow.com/questions/26087447/private-var-is-accessible-from-outside-the-class
 
 Access modifiers in Swift are implemented differently than other languages. There are three levels:
 
 private: accessible only within that particular file
 
 internal: accessible only within the module (project)
 
 public: accessible from anywhere
 
 Unless marked otherwise, everything you write is internal by default.
 
 Specified as 'internal' to avoid modules that import this library from accessing this directly
 */
@IBDesignable internal class AnimatorView: UIView {
    
    var animationDuration: Double = 0.0
    var defaultStrokeStart: CGFloat = 0.08
    var defaultStrokeEnd: CGFloat = 0.95
    
    var rotatesClockwise: Bool = true
    
    var progress: CGFloat? // Should be out of 1.0 (percent of 100)
    var previousStrokeEnd: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(animationDuration: Double, rotatesClockwise: Bool, progress: CGFloat?) {
        self.animationDuration = animationDuration
        self.rotatesClockwise = rotatesClockwise
        self.progress = progress
        //let someDefaultFrame: CGRect = CGRect(x: deviceScreenWidth / 2 - 30, y: deviceScreenHeight / 2 - 30, width: 120, height: 120)
        let someDefaultFrame: CGRect = CGRect(x: 0, y: 0, width: 80, height: 80)
        super.init(frame: someDefaultFrame)
    }
    
    // Get a reference to this UIView's CAShapeLayer. Will use later
    override var layer: CAShapeLayer {
        get { return super.layer as! CAShapeLayer }
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        //layer.strokeColor = defaultTheme.colors.textColor.cgColor
        layer.lineWidth = 3
        
        // If this is being presented the normal way using "beginLoadingAnimation"
        if progress == nil {
            layer.strokeStart = defaultStrokeStart
            layer.strokeEnd = defaultStrokeEnd
        } else {
            //layer.strokeStart = 0.0
            //layer.strokeEnd = progress!
        }
        
        setBezierPath(forLayer: layer)
    }
    
    override func didMoveToWindow() {
        // no longer calling this function automatically since the 'updateProgressAnimation' may be called
        //beginLoadingAnimation()
    }
    
    var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.darkGray.cgColor, UIColor.black.cgColor]
        
        //let stopOne: CGFloat = 0.0
        //let stopTwo: CGFloat = 1.0
        //let locations : [CGFloat] = [stopOne, stopTwo]
        //gradientLayer.locations = locations as [NSNumber]?
        
        return gradientLayer
    }()
    
    private func setBezierPath(forLayer layer: CAShapeLayer) {
        let circleBezierPath = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
        layer.path = circleBezierPath
        layer.bounds = circleBezierPath.boundingBox
        
        /*
         // Attempt at adding gradient to layer
         let lineLayer = CAShapeLayer()
         lineLayer.fillColor = nil
         lineLayer.strokeColor = UIColor.red.cgColor
         lineLayer.lineWidth = 3
         lineLayer.strokeStart = defaultStrokeStart
         lineLayer.strokeEnd = defaultStrokeEnd
         lineLayer.path = circleBezierPath
         lineLayer.bounds = circleBezierPath.boundingBox
         lineLayer.frame = circleBezierPath.boundingBox
         
         gradientLayer.frame = lineLayer.bounds
         gradientLayer.mask = lineLayer
         layer.addSublayer(gradientLayer)
         */
    }
    
    func beginLoadingAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        
        // Configure these better to create a smoother rotation. The number of keyTimes must match the number of values
        animation.keyTimes = [0.0, 0.1,
                              0.2, 0.3,
                              0.4, 0.5,
                              0.6, 0.7,
                              0.8, 0.9,
                              1.0]
        animation.values = [0,             1 * Double.pi,
                            2 * Double.pi, 3 * Double.pi,
                            4 * Double.pi, 5 * Double.pi,
                            6 * Double.pi, 7 * Double.pi,
                            8 * Double.pi, 9 * Double.pi,
                            10 * Double.pi]
        
        /*
         if rotatesClockwise {
         animation.values?.reverse()
         }*/
        rotatesClockwise ? animation.values?.reverse() : nil
        
        animation.calculationMode = kCAAnimationLinear
        animation.duration = animationDuration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
    
    
    func updateProgressAnimation(toProgress progress: CGFloat) {
        
        //layer.strokeStart = 0.0
        layer.strokeEnd = progress
        
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // Set the duration of this animation. Passed in on initialization
        drawAnimation.duration = animationDuration
        // Animate only once..
        drawAnimation.repeatCount = 1.0
        
        // Animate FROM the previous end of the stroke
        drawAnimation.fromValue = Double(previousStrokeEnd)
        
        // Set the previousStrokeEnd to the progress that was passed in
        // This keeps the animation moving forward
        previousStrokeEnd = progress
        
        // Animate TO the passed in progress value
        drawAnimation.toValue = Double(progress)
        
        // Experiment with timing to get the appearence to look the way you want
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Add the animation to the circle
        layer.add(drawAnimation, forKey: "draw")
    }
    
    
    // Reset all variables and remove all animations. Reset to default settings
    func reset() {
        animationDuration = 0.0
        defaultStrokeStart = 0.08
        defaultStrokeEnd = 0.95
        
        progress = 0.0
        previousStrokeEnd = 0.0
        layer.removeAllAnimations()
    }
}
