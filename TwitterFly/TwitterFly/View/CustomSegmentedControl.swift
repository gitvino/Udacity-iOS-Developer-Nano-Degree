//
//  CustomSegmentedControl.swift
//  TwitterFly
//
//  Created by Vinoth on 22/8/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSegmentedControl: UIControl {
    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable
    var borderWidth: CGFloat = 1.0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable
    var commaSeperatedButtonTitles: String = "" {
        didSet{
            updateView()
        }
    }
    @IBInspectable
    var textColor: UIColor = UIColor.gray {
        didSet{
            updateView()
        }
    }
    @IBInspectable
    var selectorColor: UIColor = UIColor.blue {
        didSet{
            updateView()
        }
    }
    @IBInspectable
    var selectedTextColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    
    func updateView() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview()
        }
        let buttonTitles = commaSeperatedButtonTitles.components(separatedBy: ",")
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectedTextColor, for: .normal)
        
        let selectorWidth = frame.width/CGFloat(buttons.count)
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selector.layer.cornerRadius = frame.height/2
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sv)
        sv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    
    }
   
    override func draw(_ rect: CGRect) {
        // Drawing code
        layer.cornerRadius = frame.height/2
    }
    @objc func buttonTapped(button: UIButton)  {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            
            if button == btn {
                selectedSegmentIndex = buttonIndex
                btn.setTitleColor(selectedTextColor, for: .normal)
                let selectorStarPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                
                UIView.animate(withDuration: 0.3) {
                    self.selector.frame.origin.x = selectorStarPosition
            }
           
            }
        }
        sendActions(for: .touchUpInside)
    }
    
   
    

}
