//
//  ViewController.swift
//  CWProgressHUD
//
//  Created by ChrishonWyllie on 11/14/2017.
//  Copyright (c) 2017 ChrishonWyllie. All rights reserved.
//

import UIKit
import CWProgressHUD


class ViewController: UIViewController {

    lazy var showProgressHUDButton: TestButton = {
        let button = TestButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show", for: .normal)
        button.addTarget(self, action: #selector(showProgressHUD(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var showProgressHUDWithMessage: TestButton = {
        let button = TestButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show With Message", for: .normal)
        button.addTarget(self, action: #selector(showProgressHUDWithMessage(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var showProgressHUDWithProgressButton: TestButton = {
        let button = TestButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show With Progress", for: .normal)
        button.addTarget(self, action: #selector(showProgressHUDWithProgress(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var showProgressHUDWithErrorButton: TestButton = {
        let button = TestButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show With Error", for: .normal)
        button.addTarget(self, action: #selector(showProgressHUDWithError(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissProgresHUDButton: TestButton = {
        let button = TestButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissProgressHUD(_:)), for: .touchUpInside)
        return button
    }()
    
    var progress: CGFloat = 0.0
    
    @objc private func showProgressHUD(_ sender: Any) {
        //CWProgressHUD.setStyle(.dark)
        print("showing default animation")
        CWProgressHUD.show()
    }
    
    @objc private func showProgressHUDWithMessage(_ sender: Any) {
        CWProgressHUD.setStyle(.dark)
        print("showing with message")
        CWProgressHUD.show(withMessage: "Attempting to fetch your images. Please wait..")
    }
    
    @objc private func showProgressHUDWithProgress(_ sender: Any) {
        print("showing with progress")
        //CWProgressHUD.show(withProgress: 0.5)
        showWithProgress()
    }
    
    @objc private func showProgressHUDWithError(_ sender: Any) {
        print("showing with error")
        CWProgressHUD.setStyle(.dark)
        CWProgressHUD.showError(withMessage: "There was an error fetching your login information. Perhaps this user was deleted...")
    }
    
    private func showWithProgress() {
        
        CWProgressHUD.setStyle(.dark)
        // timeInterval should be same as animationDuration
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { (timer) in
                
                CWProgressHUD.show(withProgress: self.progress)
                self.progress += 0.1
                
                if self.progress >= 1.0 {
                    print("Progress has reached 1.0 or greater. Invalidating timer...")
                    
                    timer.invalidate()
                    self.progress = 0.0
                }
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func dismissProgressHUD(_ sender: Any) {
        CWProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        self.view.addSubview(showProgressHUDButton)
        self.view.addSubview(showProgressHUDWithMessage)
        self.view.addSubview(showProgressHUDWithProgressButton)
        self.view.addSubview(showProgressHUDWithErrorButton)
        self.view.addSubview(dismissProgresHUDButton)
        
        showProgressHUDButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showProgressHUDButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        showProgressHUDButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        showProgressHUDButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        showProgressHUDWithMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showProgressHUDWithMessage.topAnchor.constraint(equalTo: showProgressHUDButton.bottomAnchor, constant: 30).isActive = true
        showProgressHUDWithMessage.widthAnchor.constraint(equalToConstant: 180).isActive = true
        showProgressHUDWithMessage.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        showProgressHUDWithProgressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showProgressHUDWithProgressButton.topAnchor.constraint(equalTo: showProgressHUDWithMessage.bottomAnchor, constant: 30).isActive = true
        showProgressHUDWithProgressButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        showProgressHUDWithProgressButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        showProgressHUDWithErrorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showProgressHUDWithErrorButton.topAnchor.constraint(equalTo: showProgressHUDWithProgressButton.bottomAnchor, constant: 30).isActive = true
        showProgressHUDWithErrorButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        showProgressHUDWithErrorButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        
        dismissProgresHUDButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissProgresHUDButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        dismissProgresHUDButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        dismissProgresHUDButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}














class TestButton: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            
            setTitleColor(UIColor(red: 240/255, green: 40/255, blue: 20/255, alpha: 1.0/1.0), for: .normal)
            clipsToBounds = true
            layer.masksToBounds = true
            layer.cornerRadius = 15
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 2
            layer.backgroundColor = UIColor.groupTableViewBackground.cgColor
            
            //print("shadow layer was nil. instantiatiing...")
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

