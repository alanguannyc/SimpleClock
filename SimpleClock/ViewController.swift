//
//  ViewController.swift
//  SimpleClock
//
//  Created by Alan on 3/12/19.
//  Copyright © 2019 AlanG. All rights reserved.
//

import UIKit
//import MaterialComponents.MaterialButtons_ButtonThemer
import MaterialComponents.MaterialButtons
//import MaterialConainerScheme


class ViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    var timer: Timer?
    var expanded = false
    var themeArray = ["#000000", "#F4976C","#EAE7DC"]
    var fontColor = ["#ffffff", "B4DFE5", "E85A4F"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.showButtons))
        self.view.addGestureRecognizer(tapGesture)

        for i in 0..<themeArray.count
        {
            var button = newThemeButton(x: 25, y: 45, color: themeArray[i])
            button.tag = i + 1
            button.alpha = 0
            button.addTarget(self, action: #selector(ViewController.updateThemeByButton(sender:)), for: .touchUpInside)
            self.view.addSubview(button)
        }
        
        let button = addThemeButton()
        self.view.addSubview(button)
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTimeLabel()
    }

    @objc func updateTimeLabel()
    {
        var timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        timeLabel.adjustsFontSizeToFitWidth = true;
        timeLabel.numberOfLines = 1;
        timeLabel.minimumScaleFactor = 0.1
        timeLabel.text = timeFormatter.string(from: Date() as Date)
    }
    
    deinit {
        if let timer = timer
        {
            timer.invalidate()
            
        }
    }
    
    func addThemeButton()->(MDCFloatingButton)
    {
        let plusImage = UIImage(named: "plus")!.withRenderingMode(.alwaysTemplate)
        let button = MDCFloatingButton()
        button.setImage(plusImage, for: .normal)
        button.frame = CGRect(x: 25, y: 45, width: 50, height: 50)
        //        MDCFloatingActionButtonThemer.applyScheme(buttonScheme, to: button)
        button.setElevation(ShadowElevation(rawValue: 12), for: .highlighted)
        button.tintColor = UIColor.white
        button.tag = 0
        
        button.addTarget((Any).self, action: #selector(ViewController.expandButton), for: .touchUpInside)
        
        return button
    }
    
    func newThemeButton(x: CGFloat, y: CGFloat, color: String)->(MDCButton)
    {
        let button = MDCButton()
        button.frame = CGRect(x: x, y: y, width: 50, height: 50)
        button.backgroundColor = UIColor().HexToColor(hexString: color)
        
        return button
        
    }
    
    @objc func expandButton(sender:UIButton)
    {
        if(sender.tag == 0)
        {
            UIView.animate(withDuration: 0.5) {
                sender.transform = sender.transform.rotated(by: CGFloat(Double.pi / 2))
            }
        }
        
        expanded ? closeMenu() : expandMenu()

    }
    
    func expandMenu()
    {
        
        for i in 0..<themeArray.count
        {
            if let button = self.view.viewWithTag(i+1)
            {
                UIView.animate(withDuration: 0.5) {
                    button.transform = CGAffineTransform(translationX: 0, y: CGFloat(i * 50 + 55))
                    button.alpha = 1
                }
                
            }
        }
        expanded = true
    }
    
    func closeMenu()
    {
        for i in 0..<themeArray.count
        {
            if let button = self.view.viewWithTag(i+1)
            {
                UIView.animate(withDuration: 0.5) {
                    button.transform = CGAffineTransform.identity
                    button.alpha = 0
                }
                
            }
        }
        expanded = false
    }
    
    @objc func updateThemeByButton(sender: UIButton)
    {
        updateTheme(fontColor: fontColor[sender.tag - 1], backgroundColor: themeArray[sender.tag - 1])
    }

    func updateTheme(fontColor: String, backgroundColor: String)
    {
        timeLabel.textColor = UIColor().HexToColor(hexString: fontColor, alpha: 1.0)
        backgroundView.backgroundColor = UIColor().HexToColor(hexString: backgroundColor, alpha: 1.0)
    }
    
    @objc func showButtons()
    {
        
    }

}



extension UIColor {
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
