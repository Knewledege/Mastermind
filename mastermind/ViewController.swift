//
//  ViewController.swift
//  mastermind
//

//  Copyright © 2017年 takahashi kei. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
}



class ViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var fightlabel: UILabel!
    var number:Double=0
    
    @IBOutlet weak var myButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let app:AppDelegate=(UIApplication.shared.delegate as! AppDelegate)
        let label = UILabel.init()
        label.adjustsFontSizeToFitWidth=true
        
        
        // 「ud」というインスタンスをつくる。
        let fight_label_ud = UserDefaults.standard
        
        if((fight_label_ud.object(forKey: "fight_labelid")) == nil){
            fightlabel.text="0"
            
        }else{
            
            app.fight_label=fight_label_ud.object(forKey: "fight_labelid") as! Double
            
            print(app.fight_label)
            
            fightlabel.text=String(format:"%.0f",app.fight_label)
        }
        // Do any additional setup after loading the view, typically from }a nib.
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

