//
//  thirdViewController.swift
//  mastermind
//
//  Copyright © 2017年 takahashi kei. All rights reserved.
//

import UIKit
import GoogleMobileAds
class thirdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate{
    
    
    
    @IBOutlet weak var admobView: GADBannerView!
    
    let AdMobID = " ca-app-pub-4512223201861912~9267310587"
    let TEST_ID = "ca-app-pub-4512223201861912/3220776980"
    
    let AdMobTest:Bool = true
    
    @IBOutlet weak var text4: UILabel!
    @IBOutlet weak var result_label: UILabel!
    @IBOutlet weak var mine2Tableview: UITableView!
    @IBOutlet weak var cpu2Tableview: UITableView!
    @IBOutlet weak var cpu: UILabel!
    @IBOutlet weak var mine: UILabel!
    
    var minenumber:String=" "
    var cpunumber:String=" "
    
    let app:AppDelegate=(UIApplication.shared.delegate as! AppDelegate)
    
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag==100){
            return app.mine_cell.count
        }
        return app.cpu_cell.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath :IndexPath) -> UITableViewCell {
        
        //左のラベル
        if(tableView.tag==100){
            
            // セルを取得する
            let left_cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "mineCell", for: indexPath)
            
            //Tag番号でセルに含まれるラベルを取得
            let label1 = left_cell.viewWithTag(1) as! UILabel
            let label2 = left_cell.viewWithTag(2) as! UILabel
            let label3 = left_cell.viewWithTag(3) as! UILabel
            
            // セルに表示する値を設定する
            label1.text = String(describing: app.mine_cell[indexPath.row])
            label2.text = String(describing: app.mine_hit_cell[indexPath.row])
            label3.text = String(describing: app.mine_blow_cell[indexPath.row])
            
            
            return left_cell
        }
        //右のラベル
        
        // セルを取得する
        let right_cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cpuCell", for: indexPath)
        
        //Tag番号でセルに含まれるラベルを取得
        let label1 = right_cell.viewWithTag(4) as! UILabel
        let label2 = right_cell.viewWithTag(5) as! UILabel
        let label3 = right_cell.viewWithTag(6) as! UILabel
        
        // セルに表示する値を設定する
        label1.text = String(describing: app.cpu_cell[indexPath.row])
        label2.text = String(describing: app.cpu_hit_cell[indexPath.row])
        label3.text = String(describing: app.cpu_blow_cell[indexPath.row])
        
        return right_cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        
        admobView.delegate = self
        
        if AdMobTest {
            admobView.adUnitID = TEST_ID
        }
        else{
            admobView.adUnitID = AdMobID
        }
        
        admobView.rootViewController = self
        admobView.load(GADRequest())
        
        self.view.addSubview(admobView)
        
        
        
        let label = UILabel.init()
        label.adjustsFontSizeToFitWidth=true
        self.text4.text=String(format:"%.0f",app.fight_label)
        
        
        switch app.result {
        case 3:
            let label = NSLocalizedString("勝利!!!!!!!!", comment: "")
            result_label.text=label
            break
        case 2:
            let label = NSLocalizedString("引き分け・・・・", comment: "")
            result_label.text=label
            break
        case 1:
            let label = NSLocalizedString("敗け。。。", comment: "")
            result_label.text=label
            break
            
        default:
            let label = NSLocalizedString("エラー", comment: "")
            result_label.text=label
        }
        
        mine.text=minenumber
        cpu.text=cpunumber
        
        //dataSourceの設定
        mine2Tableview.dataSource = self
        //delegateの設定
        mine2Tableview.delegate = self
        
        
        
        //dataSourceの設定
        cpu2Tableview.dataSource = self
        //delegateの設定
        cpu2Tableview.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //tableviewリセット
    @IBAction func returnbutton(_ sender: AnyObject) {
        
        //データの削除
        self.app.mine_cell.removeAllObjects()
        self.app.mine_hit_cell.removeAllObjects()
        self.app.mine_blow_cell.removeAllObjects()
        
        self.app.cpu_cell.removeAllObjects()
        self.app.cpu_hit_cell.removeAllObjects()
        self.app.cpu_blow_cell.removeAllObjects()
        
        self.mine2Tableview.reloadData()
        self.cpu2Tableview.reloadData()
        
        
    }
    @IBAction func oncebutton(_ sender: AnyObject) {
        
        //データの削除
        self.app.mine_cell.removeAllObjects()
        self.app.mine_hit_cell.removeAllObjects()
        self.app.mine_blow_cell.removeAllObjects()
        
        self.app.cpu_cell.removeAllObjects()
        self.app.cpu_hit_cell.removeAllObjects()
        self.app.cpu_blow_cell.removeAllObjects()
        
        self.mine2Tableview.reloadData()
        self.cpu2Tableview.reloadData()
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
