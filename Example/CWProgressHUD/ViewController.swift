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
    
    lazy var progressHUDStyleSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.insertSegment(withTitle: "Light", at: 0, animated: true)
        sc.insertSegment(withTitle: "Dark", at: 1, animated: true)
        sc.selectedSegmentIndex = 0
        sc.isUserInteractionEnabled = true
        sc.addTarget(self, action: #selector(switchProgressHUDStyle(_:)), for: .valueChanged)
        return sc
    }()

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
    
    lazy var showProgressHUDWithProgressAndMessageButton: TestButton = {
        let button = TestButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show With Progress And Message", for: .normal)
        button.addTarget(self, action: #selector(showProgressHUDWithProgressAndMessage(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var showProgressHUDWithSuccessButton: TestButton = {
        let button = TestButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show With Success", for: .normal)
        button.addTarget(self, action: #selector(showProgressHUDWithSuccess(_:)), for: .touchUpInside)
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
        print("showing default animation")
        CWProgressHUD.show()
    }
    
    @objc private func showProgressHUDWithMessage(_ sender: Any) {
        print("showing with message")
        CWProgressHUD.show(withMessage: "Attempting to fetch your images. Please wait..")
    }
    
    @objc private func showProgressHUDWithProgress(_ sender: Any) {
        print("showing with progress and no message")
        showWithProgress(andMessage: nil)
    }
    
    @objc private func showProgressHUDWithProgressAndMessage(_ sender: Any) {
        print("showing with progress and a message")
        showWithProgress(andMessage: "Please wait while we fetch your data. This may take some time so bare with us and watch this cool animation while you wait")
    }
    
    @objc private func showProgressHUDWithSuccess(_ sender: Any) {
        print("showing with success")
        CWProgressHUD.createCustomStyle(withBackgroundColor: UIColor(red: 40/255, green: 145/255, blue: 112/255, alpha: 1.0), andTextColor: UIColor(red: 20/255, green: 65/255, blue: 82/255, alpha: 1.0))
        CWProgressHUD.showSuccess(withMessage: "Successfully uploaded your image!")
    }
    
    @objc private func showProgressHUDWithError(_ sender: Any) {
        print("showing with error")
        CWProgressHUD.showError(withMessage: "There was an error fetching your login information. Perhaps this user was deleted...")
    }
    
    
    
    
    
    
    private func showWithProgress(andMessage message: String?) {
        
        // timeInterval should be same as animationDuration
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { (timer) in
                
                if let mssg = message {
                    CWProgressHUD.show(withProgress: self.progress, andMessage: mssg)
                } else {
                    CWProgressHUD.show(withProgress: self.progress, andMessage: nil)
                }
                self.progress += 0.1
                
                if self.progress >= 1.0 {
                    print("Progress has reached 1.0 or greater. Invalidating timer...")
                    
                    timer.invalidate()
                    self.progress = 0.0
                }
            })
        } else {
            // Fallback on earlier versions
            print("Fell back to previous versions")
        }
    }
    
    @objc private func switchProgressHUDStyle(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: CWProgressHUD.setStyle(.light)
        default: CWProgressHUD.setStyle(.dark)
        }
    }
    
    @objc private func dismissProgressHUD(_ sender: Any) {
        CWProgressHUD.dismiss()
    }
    
    private func setupUIElements() {
        self.view.addSubview(progressHUDStyleSegmentedControl)
        self.view.addSubview(showProgressHUDButton)
        self.view.addSubview(showProgressHUDWithMessage)
        self.view.addSubview(showProgressHUDWithProgressButton)
        self.view.addSubview(showProgressHUDWithProgressAndMessageButton)
        self.view.addSubview(showProgressHUDWithSuccessButton)
        self.view.addSubview(showProgressHUDWithErrorButton)
        self.view.addSubview(dismissProgresHUDButton)
        
        // show button
        progressHUDStyleSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressHUDStyleSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        
        // show button
        showProgressHUDButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showProgressHUDButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        showProgressHUDButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        showProgressHUDButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        // message button
        showProgressHUDWithMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showProgressHUDWithMessage.topAnchor.constraint(equalTo: showProgressHUDButton.bottomAnchor, constant: 30).isActive = true
        showProgressHUDWithMessage.widthAnchor.constraint(equalToConstant: 180).isActive = true
        showProgressHUDWithMessage.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        // progress button
        showProgressHUDWithProgressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showProgressHUDWithProgressButton.topAnchor.constraint(equalTo: showProgressHUDWithMessage.bottomAnchor, constant: 30).isActive = true
        showProgressHUDWithProgressButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        showProgressHUDWithProgressButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        // progress and message button
        showProgressHUDWithProgressAndMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showProgressHUDWithProgressAndMessageButton.topAnchor.constraint(equalTo: showProgressHUDWithProgressButton.bottomAnchor, constant: 30).isActive = true
        showProgressHUDWithProgressAndMessageButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        showProgressHUDWithProgressAndMessageButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        // success button
        showProgressHUDWithSuccessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showProgressHUDWithSuccessButton.topAnchor.constraint(equalTo: showProgressHUDWithProgressAndMessageButton.bottomAnchor, constant: 30).isActive = true
        showProgressHUDWithSuccessButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        showProgressHUDWithSuccessButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        // error button
        showProgressHUDWithErrorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showProgressHUDWithErrorButton.topAnchor.constraint(equalTo: showProgressHUDWithSuccessButton.bottomAnchor, constant: 30).isActive = true
        showProgressHUDWithErrorButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        showProgressHUDWithErrorButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        // dimiss button
        dismissProgresHUDButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissProgresHUDButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        dismissProgresHUDButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        dismissProgresHUDButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        setupUIElements()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //CWProgressHUD.setStyle(.dark)
        
        //CWProgressHUD.show()
        
        //CWProgressHUD.show(withMessage: "Performing some time consuming task. Please wait...")
        
        //showWithProgress()

        //CWProgressHUD.showSuccess(withMessage: "Successfully uploaded image!")
        
        //CWProgressHUD.showError(withMessage: "Could not perform (operation)")
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

