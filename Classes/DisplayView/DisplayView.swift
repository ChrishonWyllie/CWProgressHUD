//
//  DisplayView.swift
//  CWProgressHUD
//
//  Created by Chrishon Wyllie on 11/14/17.
//

import Foundation
import UIKit



private let deviceScreenWidth: CGFloat = UIScreen.main.bounds.width
private let deviceScreenHeight: CGFloat = UIScreen.main.bounds.height

private let darkColor: UIColor  = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0/1.0)
private let lightColor: UIColor = .white
private let XsymbolImageNameDark: String = "x-symbol-darktheme"
private let XsymbolImageNameLight: String = "x-symbol-whitetheme"

private struct Theme {
    var backgroundColor: UIColor
    var textColor: UIColor
    var XsymbolImageName: String
}

private let darkTheme   = Theme(backgroundColor: darkColor,  textColor: lightColor, XsymbolImageName: XsymbolImageNameLight)
private let lightTheme  = Theme(backgroundColor: lightColor, textColor: darkColor, XsymbolImageName: XsymbolImageNameDark)


public enum CWProgressHUDStyle {
    case dark, light
    
    fileprivate var colors: Theme {
        // 'self' pointing to this CWProgressHUDStyle enum. So must exhaust all cases
        switch self {
        case .dark:  return darkTheme
        case .light: return lightTheme
        }
    }
}

var selectedTheme: CWProgressHUDStyle = .light



public class CWProgressHUD: NSObject {
    
    private class func loadImage(name: String) -> UIImage? {
        let podBundle = Bundle(for: CWProgressHUD.self)
        if let url = podBundle.url(forResource: "CWProgressHUD/Resources", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
        return nil
    }
    
    static var isShowing: Bool = false
    
    private static var progressHUDBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.backgroundColor = selectedTheme.colors.backgroundColor
        return view
    }()
    
    private static var hudImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private static var hudMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = selectedTheme.colors.textColor
        return label
    }()
    
    private static var timer: Timer = Timer()
    
    private static var windowHeight: CGFloat = 0
    private static var windowWidth: CGFloat = 0
    private static var halfViewSize: CGFloat = 0
    private static let progressHUDWidthXHeight: CGFloat = 120
    
    
    private static var layerOneSpinnerViewWidthXHeight: CGFloat = 80
    private static var layerTwoSpinnerViewWidthXHeight: CGFloat = 70
    private static var layerThreeSpinnerViewWidthXHeight: CGFloat = 60
    private static let layerOneSpinnerView = AnimatorView(animationDuration: 8, rotatesClockwise: true, progress: nil)
    private static let layerTwoSpinnerView = AnimatorView(animationDuration: 7, rotatesClockwise: false, progress: nil)
    private static let layerThreeSpinnerView = AnimatorView(animationDuration: 6, rotatesClockwise: true, progress: nil)
    
    private static var spinnersGroup: [AnimatorView] = []
    
    private static var hudCenterXAnchor: NSLayoutConstraint?
    private static var hudCenterYAnchor: NSLayoutConstraint?
    private static var hudWidthAnchor: NSLayoutConstraint?
    private static var hudHeightAnchor: NSLayoutConstraint?
    
    private static var layerOneWidthAnchor: NSLayoutConstraint?
    private static var layerOneHeightAnchor: NSLayoutConstraint?
    private static var layerOneTopAnchor: NSLayoutConstraint?
    private static var layerTwoWidthAnchor: NSLayoutConstraint?
    private static var layerTwoHeightAnchor: NSLayoutConstraint?
    private static var layerTwoTopAnchor: NSLayoutConstraint?
    private static var layerThreeWidthAnchor: NSLayoutConstraint?
    private static var layerThreeHeightAnchor: NSLayoutConstraint?
    private static var layerThreeTopAnchor: NSLayoutConstraint?
    
    
    
    
    
    
    
    
    // Default initializer. Most likely won't be used.
    override init() {
        super.init()
    }
    
    
    
    // MARK: - Show functions
    
    public class func show() {
        
        if let window = UIApplication.shared.keyWindow {
            
            if isShowing == true {
                dismiss()
            }
            isShowing = true
            
            //window.isUserInteractionEnabled = true
            //window.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            window.addSubview(self.progressHUDBackgroundView)
            progressHUDBackgroundView.backgroundColor = selectedTheme.colors.backgroundColor
            
            print("CWProgressHUD is now showing")
            print("screen width: \(UIScreen.main.bounds.width)")
            print("screen height: \(UIScreen.main.bounds.height)")
            
            
            windowWidth = window.frame.width
            windowHeight = window.frame.height
            halfViewSize = progressHUDWidthXHeight / 2
            
            
            hudWidthAnchor = progressHUDBackgroundView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight)
            hudHeightAnchor = progressHUDBackgroundView.heightAnchor.constraint(equalToConstant: progressHUDWidthXHeight)
            hudCenterXAnchor = progressHUDBackgroundView.centerXAnchor.constraint(equalTo: window.centerXAnchor)
            hudCenterYAnchor = progressHUDBackgroundView.centerYAnchor.constraint(equalTo: window.centerYAnchor, constant: windowHeight)
            print("hudWidthAnchor constant: \(String(describing: hudWidthAnchor?.constant))")
            print("hudHeightAnchor constant: \(String(describing: hudHeightAnchor?.constant))")
            print("hudCenterXAnchor constant: \(String(describing: hudCenterXAnchor?.constant))")
            print("hudCenterYAnchor constant: \(String(describing: hudCenterYAnchor?.constant))")
            hudWidthAnchor?.isActive = true
            hudHeightAnchor?.isActive = true
            hudCenterXAnchor?.isActive = true
            hudCenterYAnchor?.isActive = true
            
            self.progressHUDBackgroundView.superview?.layoutIfNeeded()
            
            
            
            spinnersGroup = [layerOneSpinnerView, layerTwoSpinnerView, layerThreeSpinnerView]
            
            // The smaller the number, the faster the animation occurs. Basically complete a revolution in x seconds
            layerOneSpinnerView.animationDuration = 7.2
            layerTwoSpinnerView.animationDuration = 9.6
            layerThreeSpinnerView.animationDuration = 12.0
            
            let _ = spinnersGroup.map {
                progressHUDBackgroundView.addSubview($0)
                $0.layer.strokeColor = selectedTheme.colors.textColor.cgColor
                $0.beginLoadingAnimation()
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.centerXAnchor.constraint(equalTo: progressHUDBackgroundView.centerXAnchor).isActive = true
            }
            
            layerOneWidthAnchor = layerOneSpinnerView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 40)
            layerOneHeightAnchor = layerOneSpinnerView.heightAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 40)
            layerOneTopAnchor = layerOneSpinnerView.topAnchor.constraint(equalTo: progressHUDBackgroundView.topAnchor, constant: 20)
            
            layerTwoWidthAnchor = layerTwoSpinnerView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 50)
            layerTwoHeightAnchor = layerTwoSpinnerView.heightAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 50)
            layerTwoTopAnchor = layerTwoSpinnerView.topAnchor.constraint(equalTo: progressHUDBackgroundView.topAnchor, constant: 25)
            
            layerThreeWidthAnchor = layerThreeSpinnerView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 60)
            layerThreeHeightAnchor = layerThreeSpinnerView.heightAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 60)
            layerThreeTopAnchor = layerThreeSpinnerView.topAnchor.constraint(equalTo: progressHUDBackgroundView.topAnchor, constant: 30)
            
            layerOneWidthAnchor?.isActive = true
            layerOneHeightAnchor?.isActive = true
            layerOneTopAnchor?.isActive = true
            layerTwoWidthAnchor?.isActive = true
            layerTwoHeightAnchor?.isActive = true
            layerTwoTopAnchor?.isActive = true
            layerThreeWidthAnchor?.isActive = true
            layerThreeHeightAnchor?.isActive = true
            layerThreeTopAnchor?.isActive = true
            
            progressHUDBackgroundView.layoutIfNeeded()
            
            // Finally, animate the view onto screen by moving up the centerYAnchor
            hudCenterYAnchor?.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                
                self.progressHUDBackgroundView.superview?.layoutIfNeeded()
                //progressHUDBackgroundView.frame = CGRect(x: windowWidth / 2 - halfViewSize, y: windowHeight / 2 - halfViewSize, width: progressHUDWidthXHeight, height: progressHUDWidthXHeight)
                
            }, completion: { (completed) in
                
                // Perhaps there should be no timer. Show the progressHUD indefinitely until the user decides to dismiss it
                //timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.dismiss), userInfo: nil, repeats: false)
                
            })
        }
    }
    
    
    
    
    // --------------------------------------------------------------------------------------------------------------------------------------- //
    
    
    
    
    public class func show(withMessage message: String) {
        
        if let window = UIApplication.shared.keyWindow {
            
            if isShowing == true {
                dismiss()
            }
            isShowing = true
            
            windowWidth = window.frame.width
            windowHeight = window.frame.height
            halfViewSize = progressHUDWidthXHeight / 2
            //window.isUserInteractionEnabled = true
            //window.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            window.addSubview(self.progressHUDBackgroundView)
            progressHUDBackgroundView.addSubview(hudMessageLabel)
            progressHUDBackgroundView.backgroundColor = selectedTheme.colors.backgroundColor
            
            
            print("CWProgressHUD is now showing: \(isShowing), with message: \(message)")
            print("screen width: \(UIScreen.main.bounds.width)")
            print("screen height: \(UIScreen.main.bounds.height)")
            
            
            
            
            
            
            // Could have a variable height depending on message text
            hudWidthAnchor = progressHUDBackgroundView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight)
            hudCenterXAnchor = progressHUDBackgroundView.centerXAnchor.constraint(equalTo: window.centerXAnchor)
            hudCenterYAnchor = progressHUDBackgroundView.centerYAnchor.constraint(equalTo: window.centerYAnchor, constant: windowHeight)
            hudWidthAnchor?.isActive = true
            hudCenterXAnchor?.isActive = true
            hudCenterYAnchor?.isActive = true
            
            self.progressHUDBackgroundView.superview?.layoutIfNeeded()
            
            
            spinnersGroup = [layerOneSpinnerView, layerTwoSpinnerView, layerThreeSpinnerView]
            
            // The smaller the number, the faster the animation occurs. Basically complete a revolution in x seconds
            layerOneSpinnerView.animationDuration = 7.2
            layerTwoSpinnerView.animationDuration = 9.6
            layerThreeSpinnerView.animationDuration = 12.0
            
            let _ = spinnersGroup.map {
                progressHUDBackgroundView.addSubview($0)
                $0.layer.strokeColor = selectedTheme.colors.textColor.cgColor
                $0.beginLoadingAnimation()
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.centerXAnchor.constraint(equalTo: progressHUDBackgroundView.centerXAnchor).isActive = true
            }
            
            
            
            layerOneWidthAnchor = layerOneSpinnerView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 60)
            layerOneHeightAnchor = layerOneSpinnerView.heightAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 60)
            layerOneTopAnchor = layerOneSpinnerView.topAnchor.constraint(equalTo: progressHUDBackgroundView.topAnchor, constant: 8)
            
            layerTwoWidthAnchor = layerTwoSpinnerView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 70)
            layerTwoHeightAnchor = layerTwoSpinnerView.heightAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 70)
            layerTwoTopAnchor = layerTwoSpinnerView.topAnchor.constraint(equalTo: progressHUDBackgroundView.topAnchor, constant: 13)
            
            layerThreeWidthAnchor = layerThreeSpinnerView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 80)
            layerThreeHeightAnchor = layerThreeSpinnerView.heightAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 80)
            layerThreeTopAnchor = layerThreeSpinnerView.topAnchor.constraint(equalTo: progressHUDBackgroundView.topAnchor, constant: 18)
            
            layerOneWidthAnchor?.isActive = true
            layerOneHeightAnchor?.isActive = true
            layerOneTopAnchor?.isActive = true
            layerTwoWidthAnchor?.isActive = true
            layerTwoHeightAnchor?.isActive = true
            layerTwoTopAnchor?.isActive = true
            layerThreeWidthAnchor?.isActive = true
            layerThreeHeightAnchor?.isActive = true
            layerThreeTopAnchor?.isActive = true
            
            
            
            
            
            
            
            
            hudMessageLabel.text = message
            hudMessageLabel.textColor = selectedTheme.colors.textColor
            hudMessageLabel.leadingAnchor.constraint(equalTo: progressHUDBackgroundView.leadingAnchor, constant: 8).isActive = true
            hudMessageLabel.topAnchor.constraint(equalTo: progressHUDBackgroundView.topAnchor, constant: 76).isActive = true
            hudMessageLabel.trailingAnchor.constraint(equalTo: progressHUDBackgroundView.trailingAnchor, constant: -8).isActive = true
            hudMessageLabel.bottomAnchor.constraint(equalTo: progressHUDBackgroundView.bottomAnchor, constant: -8).isActive = true
            
            
            progressHUDBackgroundView.layoutIfNeeded()
            
            // Finally, animate the view onto screen by moving up the centerYAnchor
            hudCenterYAnchor?.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                
                self.progressHUDBackgroundView.superview?.layoutIfNeeded()
                
            }, completion: { (completed) in
                
                timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.dismiss), userInfo: nil, repeats: false)
                
            })
        }
    }
    
    // --------------------------------------------------------------------------------------------------------------------------------------- //
    
    
    public class func show(withProgress progress: CGFloat) {
        
        spinnersGroup = [layerOneSpinnerView]
        
        if let window = UIApplication.shared.keyWindow {
            
            //window.isUserInteractionEnabled = true
            //window.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            windowWidth = window.frame.width
            windowHeight = window.frame.height
            halfViewSize = progressHUDWidthXHeight / 2
            
            hudWidthAnchor = progressHUDBackgroundView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight)
            hudCenterXAnchor = progressHUDBackgroundView.centerXAnchor.constraint(equalTo: window.centerXAnchor)
            hudCenterYAnchor = progressHUDBackgroundView.centerYAnchor.constraint(equalTo: window.centerYAnchor, constant: windowHeight)
            //hudWidthAnchor?.isActive = true
            //hudCenterXAnchor.isActive = true
            //hudCenterYAnchor.isActive = true
            //progressHUDBackgroundView.backgroundColor = selectedTheme.colors.backgroundColor
            
            
            
            
            
            
            if isShowing == true {
                print("The progressHUD was already showing")
                let _ = spinnersGroup.map {
                    $0.layer.strokeEnd = $0.previousStrokeEnd
                    $0.updateProgressAnimation(toProgress: progress)
                    
                }
                
                // WARNING!
                // This may never get called. Possible reason? : since the timer is invalidated at 1.0
                print("Determining to dismiss. Progress is now: \(progress)")
                if progress >= 1.0 {
                    print("time-consuming task has been completed. Progress is now: \(progress). Dismissing...")
                    dismiss()
                }
                
            } else {
                
                // Show the ProgressHUD for the first time
                // Configure constraints and set up animations
                
                print("the progressHUD was not already showing")
                
                isShowing = true
                window.addSubview(self.progressHUDBackgroundView)
                progressHUDBackgroundView.addSubview(hudMessageLabel)
                
                hudWidthAnchor?.isActive = true
                hudCenterXAnchor?.isActive = true
                hudCenterYAnchor?.isActive = true
                
                self.progressHUDBackgroundView.superview?.layoutIfNeeded()
                
                
                let _ = spinnersGroup.map {
                    progressHUDBackgroundView.addSubview($0)
                    $0.layer.strokeColor = selectedTheme.colors.textColor.cgColor
                    
                    $0.layer.removeAllAnimations()
                    $0.layer.strokeStart = 0.0
                    $0.animationDuration = 0.4
                    $0.progress = progress
                    $0.updateProgressAnimation(toProgress: progress)
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.centerXAnchor.constraint(equalTo: progressHUDBackgroundView.centerXAnchor).isActive = true
                }
                
                layerOneWidthAnchor = layerOneSpinnerView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 60)
                layerOneHeightAnchor = layerOneSpinnerView.heightAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 60)
                layerOneTopAnchor = layerOneSpinnerView.topAnchor.constraint(equalTo: progressHUDBackgroundView.topAnchor, constant: 8)
                layerOneWidthAnchor?.isActive = true
                layerOneHeightAnchor?.isActive = true
                layerOneTopAnchor?.isActive = true
                
                
                hudMessageLabel.text = "Loading..."
                hudMessageLabel.textColor = selectedTheme.colors.textColor
                hudMessageLabel.leadingAnchor.constraint(equalTo: progressHUDBackgroundView.leadingAnchor, constant: 8).isActive = true
                hudMessageLabel.topAnchor.constraint(equalTo: progressHUDBackgroundView.topAnchor, constant: 76).isActive = true
                hudMessageLabel.trailingAnchor.constraint(equalTo: progressHUDBackgroundView.trailingAnchor, constant: -8).isActive = true
                hudMessageLabel.bottomAnchor.constraint(equalTo: progressHUDBackgroundView.bottomAnchor, constant: -8).isActive = true
                hudMessageLabel.textColor = selectedTheme.colors.textColor
                
                progressHUDBackgroundView.layoutIfNeeded()
                
                // Finally, animate the view onto screen by moving up the centerYAnchor
                hudCenterYAnchor?.constant = 0
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                    
                    self.progressHUDBackgroundView.superview?.layoutIfNeeded()
                    
                }, completion: nil)
            }
        }
    }
    
    
    
    
    // --------------------------------------------------------------------------------------------------------------------------------------- //
    
    
    public class func showError(withMessage message: String) {
        if let window = UIApplication.shared.keyWindow {
            
            if isShowing == true {
                dismiss()
            }
            isShowing = true
            
            windowWidth = window.frame.width
            windowHeight = window.frame.height
            halfViewSize = progressHUDWidthXHeight / 2
            //window.isUserInteractionEnabled = true
            //window.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            window.addSubview(self.progressHUDBackgroundView)
            progressHUDBackgroundView.addSubview(hudImageView)
            if let xsymbol = loadImage(name: selectedTheme.colors.XsymbolImageName) {
                hudImageView.image = xsymbol
            } else {
                print("Could not find image")
            }
            progressHUDBackgroundView.addSubview(hudMessageLabel)
            progressHUDBackgroundView.backgroundColor = selectedTheme.colors.backgroundColor
            
            
            print("CWProgressHUD is now showing: \(isShowing), with message: \(message)")
            print("screen width: \(UIScreen.main.bounds.width)")
            print("screen height: \(UIScreen.main.bounds.height)")
            
            
            
            
            
            
            // Could have a variable height depending on message text
            hudWidthAnchor = progressHUDBackgroundView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight)
            hudCenterXAnchor = progressHUDBackgroundView.centerXAnchor.constraint(equalTo: window.centerXAnchor)
            hudCenterYAnchor = progressHUDBackgroundView.centerYAnchor.constraint(equalTo: window.centerYAnchor, constant: windowHeight)
            hudWidthAnchor?.isActive = true
            hudCenterXAnchor?.isActive = true
            hudCenterYAnchor?.isActive = true
            
            self.progressHUDBackgroundView.superview?.layoutIfNeeded()
            
            // 120 - 80 = 40
            hudImageView.widthAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 80).isActive = true
            hudImageView.heightAnchor.constraint(equalToConstant: progressHUDWidthXHeight - 80).isActive = true
            hudImageView.centerXAnchor.constraint(equalTo: progressHUDBackgroundView.centerXAnchor).isActive = true
            hudImageView.topAnchor.constraint(equalTo: progressHUDBackgroundView.topAnchor, constant: 16).isActive = true
            
            
            
            
            
            hudMessageLabel.text = message
            hudMessageLabel.textColor = selectedTheme.colors.textColor
            hudMessageLabel.leadingAnchor.constraint(equalTo: progressHUDBackgroundView.leadingAnchor, constant: 8).isActive = true
            hudMessageLabel.topAnchor.constraint(equalTo: hudImageView.bottomAnchor, constant: 16).isActive = true
            hudMessageLabel.trailingAnchor.constraint(equalTo: progressHUDBackgroundView.trailingAnchor, constant: -8).isActive = true
            hudMessageLabel.bottomAnchor.constraint(equalTo: progressHUDBackgroundView.bottomAnchor, constant: -8).isActive = true
            
            
            progressHUDBackgroundView.layoutIfNeeded()
            
            // Finally, animate the view onto screen by moving up the centerYAnchor
            hudCenterYAnchor?.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                
                self.progressHUDBackgroundView.superview?.layoutIfNeeded()
                
            }, completion: { (completed) in
                
                timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.dismiss), userInfo: nil, repeats: false)
                
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Dismiss functions
    
    @objc public class func dismiss() {
        if let _ = UIApplication.shared.keyWindow {
            if isShowing == true {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                    
                    progressHUDBackgroundView.frame = CGRect(x: windowWidth / 2 - halfViewSize, y: 1200, width: progressHUDWidthXHeight, height: progressHUDWidthXHeight)
                    
                }, completion: { (completed) in
                    
                    // Reset all NSLayoutConstraints
                    let layoutsGroup: [NSLayoutConstraint?] = [hudHeightAnchor, hudHeightAnchor,
                                                               layerOneWidthAnchor, layerOneHeightAnchor, layerOneTopAnchor,
                                                               layerTwoWidthAnchor, layerTwoHeightAnchor, layerTwoTopAnchor,
                                                               layerThreeWidthAnchor, layerThreeHeightAnchor, layerThreeTopAnchor]
                    
                    let _ = layoutsGroup.map {
                        $0?.isActive = false
                        //$0 = nil <- can't do this because this is an immutable value
                    }
                    hudWidthAnchor = nil
                    hudHeightAnchor = nil
                    layerOneWidthAnchor = nil
                    layerOneHeightAnchor = nil
                    layerOneTopAnchor = nil
                    layerTwoWidthAnchor = nil
                    layerTwoHeightAnchor = nil
                    layerTwoTopAnchor = nil
                    layerThreeWidthAnchor = nil
                    layerThreeHeightAnchor = nil
                    layerThreeTopAnchor = nil
                    
                    
                    // Remove the subviews of the progressHUDBackgroundView and remove it from the view
                    self.progressHUDBackgroundView.subviews.forEach({ $0.removeFromSuperview() })
                    self.progressHUDBackgroundView.removeFromSuperview()
                    
                    // Reset all animations for each AnimatorView in the 'spinnersGroup' and restart the strokeStart and strokeEnd
                    let _ = spinnersGroup.map {
                        $0.reset()
                        // For if planning to show regular way without progress
                        $0.layer.strokeStart = $0.defaultStrokeStart
                        $0.layer.strokeEnd = $0.defaultStrokeEnd
                    }
                    isShowing = false
                    print("CWProgressHUD has now been dismissed. isShowing: \(isShowing)")
                })
            }
        }
    }
    
    public class func dismissWithError(_ message: String) {
        
    }
    
    // MARK: - Set style funcs
    
    public class func setStyle(_ style: CWProgressHUDStyle) {
        print("CWProgressHUD style set to: .\(style)")
        selectedTheme = style
    }
}
