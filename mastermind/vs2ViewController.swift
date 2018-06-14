//
//  vs2ViewController.swift
//  mastermind
//
//  Copyright © 2017年 takahashi kei. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import GoogleMobileAds

class vs2ViewController: UIViewController,MCBrowserViewControllerDelegate,
MCSessionDelegate,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate {
    
    
    
    
    @IBOutlet weak var admobView: GADBannerView!
    
    let AdMobID = "ca-app-pub-4512223201861912~9267310587"
    let TEST_ID = "ca-app-pub-4512223201861912/3220776980"
    
    let AdMobTest:Bool = true
    
    
    var serviceType = "mastermind"
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var peerID: MCPeerID!
    
    @IBOutlet weak var Left1label: UILabel!
    @IBOutlet weak var Left2label: UILabel!
    @IBOutlet weak var Left3label: UILabel!
    @IBOutlet weak var Right1label: UILabel!
    @IBOutlet weak var Right2label: UILabel!
    @IBOutlet weak var Right3label: UILabel!
    @IBOutlet weak var turn: UILabel!
    @IBOutlet weak var turn_name: UILabel!
    @IBOutlet weak var forecast_label1: UILabel!
    @IBOutlet weak var forecast_label2: UILabel!
    @IBOutlet weak var forecast_label3: UILabel!
    @IBOutlet weak var MineTableView: UITableView!
    @IBOutlet weak var CpuTableView: UITableView!
   
    
    
    @IBOutlet weak var zeroTouch: UIButton!
    @IBOutlet weak var oneTouch: UIButton!
    @IBOutlet weak var towTouch: UIButton!
    @IBOutlet weak var threeTouch: UIButton!
    @IBOutlet weak var fourTouch: UIButton!
    @IBOutlet weak var fiveTouch: UIButton!
    @IBOutlet weak var sixTouch: UIButton!
    @IBOutlet weak var sevenTouch: UIButton!
    @IBOutlet weak var eightTouch: UIButton!
    @IBOutlet weak var nineTouch: UIButton!
    @IBOutlet weak var delTouch: UIButton!
    @IBOutlet weak var okTouch: UIButton!
    
    @IBOutlet weak var cpu_name: UILabel!
    @IBOutlet weak var mine_name: UILabel!
    @IBOutlet weak var connect: UIButton!
    @IBOutlet weak var returnHome: UIButton!

  
    
    
    var cpu = [UInt8](repeating: 0, count: 3)
    var mine = [UInt8](repeating: 0, count: 3)
    
    var win:Double=0.0
    var fight:Double=0.0
    
    let app:AppDelegate=(UIApplication.shared.delegate as! AppDelegate)
   
    var i:Int=0
    
    
    
    //ボタンが押された時に代入する値
    let zero:Int=0
    let one:Int=1
    let tow:Int=2
    let three:Int=3
    let four:Int=4
    let five:Int=5
    let six:Int=6
    let seven:Int=7
    let eight:Int=8
    let nine:Int=9
    //ジャッジ回数
    var t:Int=0
    var t2:Int=0
    var t3:Int=0
    var t4:Int=100
    var judge_turn:Int=0
    
    var turn_decition:UInt8!=nil
    var send_turn_decition:[UInt8] = [0]
    
    var cpu_turn_decition:UInt8!=nil
    
    var forecast_mine = [UInt8](repeating:0,count:3)
    var forecast_cpu = [UInt8](repeating:0,count:3)
    
    var ShowBrowser:Int = 0
    
    var connect_turn:Int=0
    
    var sendreturn:Int=0
    
    
    //プレイヤーのHITとBLOW
    var mine_hit:Int = 0
    var mine_blow:Int = 0
    
    var hitblow = [UInt8](repeating: 0, count: 2)
    //CPUのHITとBLOW
    var cpu_hit:Int = 0
    var cpu_blow:Int = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag==100){
            return app.mine_cell.count
        }
        return app.cpu_cell.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath :IndexPath) -> UITableViewCell {
        
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
    
    
    // 「ud」というインスタンスをつくる。
    let fight_ud = UserDefaults.standard
    let win_ud = UserDefaults.standard
    let fight_label_ud = UserDefaults.standard
    
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
        
        
        if(app.returntest == 0){
            
            self.peerID = MCPeerID(displayName: UIDevice.current.name)
            app.session = MCSession(peer: peerID)
            app.session?.delegate = self
            
            // create the browser viewcontroller with a unique service name
            self.browser = MCBrowserViewController(serviceType:serviceType,
                                                   session:app.session!)
            
            self.browser.delegate = self
            
            self.assistant = MCAdvertiserAssistant(serviceType:serviceType,discoveryInfo:nil, session:app.session!)
            
            // tell the assistant to start advertising our fabulous chat
            self.assistant.start()
            
        self.connect.isHidden=false
        self.returnHome.isHidden=false
        mine_name.isHidden=true
        cpu_name.isHidden=true
        Left1label.isHidden=true
        Left2label.isHidden=true
        Left3label.isHidden=true
        Right1label.isHidden=true
        Right2label.isHidden=true
        Right3label.isHidden=true
        turn.isHidden=true
        turn_name.isHidden=true
        forecast_label1.isHidden=true
        forecast_label2.isHidden=true
        forecast_label3.isHidden=true
        MineTableView.isHidden=true
        CpuTableView.isHidden=true
        zeroTouch.isHidden=true
        oneTouch
            .isHidden=true
        towTouch.isHidden=true
        threeTouch.isHidden=true
        fourTouch.isHidden=true
        fiveTouch.isHidden=true
        sixTouch.isHidden=true
        sevenTouch.isHidden=true
        eightTouch.isHidden=true
        nineTouch.isHidden=true
        delTouch.isHidden=true
        okTouch.isHidden=true
            
        print(app.session)
        }else{
            
            print("ok")
            t4 = 100
            app.session?.delegate = self
            connect.isHidden=true
            returnHome.isHidden=true
            Left1label.isHidden=false
            Left2label.isHidden=false
            Left3label.isHidden=false
            Right1label.isHidden=false
            Right2label.isHidden=false
            Right3label.isHidden=false
            turn.isHidden=false
            turn_name.isHidden=false
            forecast_label1.isHidden=false
            forecast_label2.isHidden=false
            forecast_label3.isHidden=false
            MineTableView.isHidden=false
            CpuTableView.isHidden=false
            zeroTouch.isHidden=false
            oneTouch.isHidden=false
            towTouch.isHidden=false
            threeTouch.isHidden=false
            fourTouch.isHidden=false
            fiveTouch.isHidden=false
            sixTouch.isHidden=false
            sevenTouch.isHidden=false
            eightTouch.isHidden=false
            nineTouch.isHidden=false
            delTouch.isHidden=false
            okTouch.isHidden=false
            cpu_name.isHidden=false
            mine_name.isHidden=false
            zeroTouch.isEnabled=false
            oneTouch.isEnabled = false
            towTouch.isEnabled = false
            threeTouch.isEnabled = false
            fourTouch.isEnabled = false
            fiveTouch.isEnabled = false
            sixTouch.isEnabled = false
            sevenTouch.isEnabled = false
            eightTouch.isEnabled = false
            nineTouch.isEnabled = false
            okTouch.isEnabled=false
            delTouch.isEnabled=false
            if(self.cpu_turn_decition != nil){
                self.turn_decition=UInt8(arc4random_uniform(10))
                if(turn_decition != nil){
                self.send_turn_decition[0]=turn_decition
                }
            
                let sendmine = NSData(bytes:self.send_turn_decition,length:self.send_turn_decition.count*MemoryLayout<UInt8>.size)
                do {
                
                    try app.session?.send(sendmine as Data,toPeers: (app.session?.connectedPeers)!,with: MCSessionSendDataMode.unreliable)
                } catch {
                    print("Error sending data: \(error.localizedDescription)")
                }
            
                if(self.cpu_turn_decition != nil && self.turn_decition != nil){
                    if(self.turn_decition < self.cpu_turn_decition){
                    
                        let alerttitle = NSLocalizedString("後攻", comment: "")
                        let alertmessage = NSLocalizedString("相手が数字を設定しています!", comment: "")
                        let alert10: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:UIAlertControllerStyle.alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action:UIAlertAction!) -> Void in
                            self.turn_name.text=alertmessage
                            self.t4=0
                            self.judge_turn=2
                        })
                        alert10.addAction(cancelAction)
                        /*var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                         while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                         baseview=baseview.presentedViewController!
                         }
                         baseview.*/self.present(alert10, animated: true, completion: nil)
                    }else if(self.turn_decition == self.cpu_turn_decition){
                    
                        self.turn_decition=UInt8(arc4random_uniform(10))
                        if(self.turn_decition != nil){
                            self.send_turn_decition[0]=UInt8(self.turn_decition)
                        }
                    
                        let sendmine = NSData(bytes:self.send_turn_decition,length:self.send_turn_decition.count*MemoryLayout<UInt8>.size)
                        do {
                        
                            try app.session?.send(sendmine as Data,toPeers: (app.session?.connectedPeers)!,with: MCSessionSendDataMode.unreliable)
                        } catch {
                            print("Error sending data: \(error.localizedDescription)")
                        }
                    }else{
                        let alerttitle = NSLocalizedString("先攻", comment: "")
                        let alertmessage = NSLocalizedString("自分の数字を３つ設定してください", comment: "")
                        let alert10: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:UIAlertControllerStyle.alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action:UIAlertAction!) -> Void in
                            self.turn_name.text=alertmessage
                            self.zeroTouch.isEnabled = true
                            self.oneTouch.isEnabled = true
                            self.towTouch.isEnabled = true
                            self.threeTouch.isEnabled = true
                            self.fourTouch.isEnabled = true
                            self.fiveTouch.isEnabled = true
                            self.sixTouch.isEnabled = true
                            self.sevenTouch.isEnabled = true
                            self.eightTouch.isEnabled = true
                            self.nineTouch.isEnabled = true
                            self.delTouch.isEnabled = true
                            self.okTouch.isEnabled=false
                            self.judge_turn=1
                        })
                        alert10.addAction(cancelAction)
                        /*var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                         while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                         baseview=baseview.presentedViewController!
                         }
                         baseview.*/self.present(alert10, animated: true, completion: nil)
                    }
                }
            }
        }
 
        fight_ud.register(defaults: ["fightid":fight])
        win_ud.register(defaults: ["winid":win])
        
        fight=fight_ud.object(forKey: "fightid") as! Double
        win=win_ud.object(forKey: "winid") as! Double
        
        //dataSourceの設定
        MineTableView.dataSource = self
        //delegateの設定
        MineTableView.delegate = self
        
        
        
        //dataSourceの設定
        CpuTableView.dataSource = self
        //delegateの設定
        CpuTableView.delegate = self
        
        //cpuの設定した数字表示
        Right1label.text="?"
        Right2label.text="?"
        Right3label.text="?"
        
    }
    
    
    
    
    
    
    
    
    @IBAction func zeroTouch(_ sender: UIButton) {
        if(t4==100 || t==0){
            
            if(i==0){
                Left1label.text = "0"
            }
            if(i==1){
                Left2label.text = "0"
            }
            if(i==2){
                Left3label.text = "0"
            }
            mine[i]=0
            i=i+1
            zeroTouch.isEnabled = false
            if(i==3){
                t4=0
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }else{
            if(i==0){
                forecast_label1.text = "0"
            }
            if(i==1){
                forecast_label2.text = "0"
            }
            if(i==2){
                forecast_label3.text = "0"
            }
            forecast_mine[i]=0
            i=i+1
            zeroTouch.isEnabled = false
            if(i==3){
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
                
            }
        }
    }
    
    @IBAction func oneTouch(_ sender: UIButton) {
        
        if(t4==100 || t==0){
            if(i==0){
                Left1label.text = "1"
            }
            if(i==1){
                Left2label.text = "1"
            }
            if(i==2){
                Left3label.text = "1"
            }
            mine[i]=1
            i=i+1
            oneTouch.isEnabled = false
            if(i==3){
                t4=0
                zeroTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }else{
            if(i==0){
                forecast_label1.text = "1"
            }
            if(i==1){
                forecast_label2.text = "1"
            }
            if(i==2){
                forecast_label3.text = "1"
            }
            forecast_mine[i]=1
            i=i+1
            oneTouch.isEnabled = false
            if(i==3){
                zeroTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }
    }
    
    @IBAction func towTouch(_ sender: UIButton) {
        if(t4==100 || t==0){
            if(i==0){
                Left1label.text = "2"
            }
            if(i==1){
                Left2label.text = "2"
            }
            if(i==2){
                Left3label.text = "2"
            }
            mine[i]=2
            i=i+1
            towTouch.isEnabled = false
            if(i==3){
                t4=0
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }else{
            if(i==0){
                forecast_label1.text = "2"
            }
            if(i==1){
                forecast_label2.text = "2"
            }
            if(i==2){
                forecast_label3.text = "2"
            }
            forecast_mine[i]=2
            i=i+1
            towTouch.isEnabled = false
            if(i==3){
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }
    }
    
    @IBAction func threeTouch(_ sender: UIButton) {
        if(t4==100 || t==0){
            if(i==0){
                Left1label.text = "3"
            }
            if(i==1){
                Left2label.text = "3"
            }
            if(i==2){
                Left3label.text = "3"
            }
            mine[i]=3
            i=i+1
            threeTouch.isEnabled = false
            if(i==3){
                t4=0
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }else{
            if(i==0){
                forecast_label1.text = "3"
            }
            if(i==1){
                forecast_label2.text = "3"
            }
            if(i==2){
                forecast_label3.text = "3"
            }
            forecast_mine[i]=3
            i=i+1
            threeTouch.isEnabled = false
            if(i==3){
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }
    }
    
    @IBAction func four(_ sender: UIButton) {
        if(t4==100 || t==0){
            if(i==0){
                Left1label.text = "4"
            }
            if(i==1){
                Left2label.text = "4"
            }
            if(i==2){
                Left3label.text = "4"
            }
            mine[i]=4
            i=i+1
            fourTouch.isEnabled = false
            if(i==3){
                t4=0
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }else{
            if(i==0){
                forecast_label1.text = "4"
            }
            if(i==1){
                forecast_label2.text = "4"
            }
            if(i==2){
                forecast_label3.text = "4"
            }
            forecast_mine[i]=4
            i=i+1
            fourTouch.isEnabled = false
            if(i==3){
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }
    }
    
    @IBAction func fiveTouch(_ sender: UIButton) {
        if(t4==100 || t==0){
            if(i==0){
                Left1label.text = "5"
            }
            if(i==1){
                Left2label.text = "5"
            }
            if(i==2){
                Left3label.text = "5"
            }
            mine[i]=5
            i=i+1
            fiveTouch.isEnabled = false
            if(i==3){
                t4=0
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }else{
            if(i==0){
                forecast_label1.text = "5"
            }
            if(i==1){
                forecast_label2.text = "5"
            }
            if(i==2){
                forecast_label3.text = "5"
            }
            forecast_mine[i]=5
            i=i+1
            fiveTouch.isEnabled = false
            if(i==3){
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }
    }
    
    @IBAction func sixTouch(_ sender: UIButton) {
        if(t4==100 || t==0){
            
            if(i==0){
                Left1label.text = "6"
            }
            if(i==1){
                Left2label.text = "6"
            }
            if(i==2){
                Left3label.text = "6"
            }
            mine[i]=6
            i=i+1
            sixTouch.isEnabled = false
            if(i==3){
                t4=0
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }else{
            if(i==0){
                forecast_label1.text = "6"
            }
            if(i==1){
                forecast_label2.text = "6"
            }
            if(i==2){
                forecast_label3.text = "6"
            }
            forecast_mine[i]=6
            i=i+1
            sixTouch.isEnabled = false
            if(i==3){
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }
    }
    
    @IBAction func sevenTouch(_ sender: UIButton) {
        if(t4==100 || t==0){
            if(i==0){
                Left1label.text = "7"
            }
            if(i==1){
                Left2label.text = "7"
            }
            if(i==2){
                Left3label.text = "7"
            }
            mine[i]=7
            i=i+1
            sevenTouch.isEnabled = false
            if(i==3){
                t4=0
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }else{
            if(i==0){
                forecast_label1.text = "7"
            }
            if(i==1){
                forecast_label2.text = "7"
            }
            if(i==2){
                forecast_label3.text = "7"
            }
            forecast_mine[i]=7
            i=i+1
            sevenTouch.isEnabled = false
            if(i==3){
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                eightTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }
    }
    
    @IBAction func eightTouch(_ sender: UIButton) {
        if(t4==100 || t==0){
            if(i==0){
                Left1label.text = "8"
            }
            if(i==1){
                Left2label.text = "8"
            }
            if(i==2){
                Left3label.text = "8"
            }
            mine[i]=8
            i=i+1
            eightTouch.isEnabled = false
            if(i==3){
                t4=0
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }else{
            if(i==0){
                forecast_label1.text = "8"
            }
            if(i==1){
                forecast_label2.text = "8"
            }
            if(i==2){
                forecast_label3.text = "8"
            }
            forecast_mine[i]=8
            i=i+1
            eightTouch.isEnabled = false
            if(i==3){
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                nineTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }
    }
    
    @IBAction func nineTouch(_ sender: UIButton) {
        if(t4==100 || t==0){
            if(i==0){
                Left1label.text = "9"
            }
            if(i==1){
                Left2label.text = "9"
            }
            if(i==2){
                Left3label.text = "9"
            }
            mine[i]=9
            i=i+1
            nineTouch.isEnabled = false
            if(i==3){
                t4=0
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }else{
            if(i==0){
                forecast_label1.text = "9"
            }
            if(i==1){
                forecast_label2.text = "9"
            }
            if(i==2){
                forecast_label3.text = "9"
            }
            forecast_mine[i]=9
            i=i+1
            nineTouch.isEnabled = false
            if(i==3){
                zeroTouch.isEnabled = false
                oneTouch.isEnabled = false
                towTouch.isEnabled = false
                threeTouch.isEnabled = false
                fourTouch.isEnabled = false
                fiveTouch.isEnabled = false
                sixTouch.isEnabled = false
                sevenTouch.isEnabled = false
                eightTouch.isEnabled = false
                okTouch.isEnabled=true
            }
        }
    }
    
    @IBAction func delTouch(_ sender: UIButton) {
        if(t4==100 || t==0){
            Left1label.text = "?"
            Left2label.text = "?"
            Left3label.text = "?"
            
            i=0
            
            zeroTouch.isEnabled = true
            oneTouch.isEnabled = true
            towTouch.isEnabled = true
            threeTouch.isEnabled = true
            fourTouch.isEnabled = true
            fiveTouch.isEnabled = true
            sixTouch.isEnabled = true
            sevenTouch.isEnabled = true
            eightTouch.isEnabled = true
            nineTouch.isEnabled = true
            okTouch.isEnabled=false
        }else{
            forecast_label1.text = "?"
            forecast_label2.text = "?"
            forecast_label3.text = "?"
            
            i=0
            
            zeroTouch.isEnabled = true
            oneTouch.isEnabled = true
            towTouch.isEnabled = true
            threeTouch.isEnabled = true
            fourTouch.isEnabled = true
            fiveTouch.isEnabled = true
            sixTouch.isEnabled = true
            sevenTouch.isEnabled = true
            eightTouch.isEnabled = true
            nineTouch.isEnabled = true
            okTouch.isEnabled=false
        }
    }
    
    //hitandblow
    func math(forecast:[UInt8],math:[UInt8],_ hit:inout Int,_ blow:inout Int){
        
        for i8 in 0..<3{
            for j8 in 0..<3{
                if(forecast[i8]==math[j8]){
                    if(i8==j8){
                        hit+=1
                    }else{
                        blow+=1
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    
    //mine_cell作成
    func make_mine_cells(){
        
        // myItemsに追加.
        app.mine_cell.add(String(forecast_mine[0])+String(forecast_mine[1])+String(forecast_mine[2]))
        app.mine_hit_cell.add(String(mine_hit))
        app.mine_blow_cell.add(String(mine_blow))
        
        // TableViewを再読み込み.
        MineTableView.reloadData()
        
        forecast_label1.text = "?"
        forecast_label2.text = "?"
        forecast_label3.text = "?"
        
    }
    
    //cpu_cell作成
    func make_cpu_cells(){
        
        // myItemsに追加.
        app.cpu_cell.add(String(forecast_cpu[0])+String(forecast_cpu[1])+String(forecast_cpu[2]))
        
        app.cpu_hit_cell.add(String(cpu_hit))
        app.cpu_blow_cell.add(String(cpu_blow))
        
        // TableViewを再読み込み.
        CpuTableView.reloadData()
        
        forecast_label1.text = "?"
        forecast_label2.text = "?"
        forecast_label3.text = "?"
    }
    
    
    func judge(){
        if(judge_turn==1){
            if(mine_hit == 3){
                
                // ① UIAlertControllerクラスのインスタンスを生成
                let alerttitle = NSLocalizedString("正解!!!", comment: "")
                let alertmessage = NSLocalizedString("後攻の相手が外したら勝ちです！！！", comment: "")
                let alert3: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
                
                // ② Actionの設定
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action:UIAlertAction!) -> Void in
                    self.sendreturn=500
                    self.app.result = 3
                    self.zeroTouch.isEnabled = false
                    self.oneTouch.isEnabled = false
                    self.towTouch.isEnabled = false
                    self.threeTouch.isEnabled = false
                    self.fourTouch.isEnabled = false
                    self.fiveTouch.isEnabled = false
                    self.sixTouch.isEnabled = false
                    self.sevenTouch.isEnabled = false
                    self.eightTouch.isEnabled = false
                    self.nineTouch.isEnabled=false
                    self.delTouch.isEnabled=false
                    self.okTouch.isEnabled=false
                    
                })
                
                // ③ UIAlertControllerにActionを追加
                alert3.addAction(cancelAction)
                
                // ④ Alertを表示
                var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                    baseview=baseview.presentedViewController!
                }
                baseview.present(alert3, animated: true, completion: nil)
                
            }else{
                self.mine_hit=0
                self.mine_blow=0
                self.cpu_hit=0
                self.cpu_blow=0
            }
        }else{
            if(mine_hit==3){
                if(cpu_hit==3){
                    // ① UIAlertControllerクラスのインスタンスを生成
                    let alerttitle = NSLocalizedString("引き分け・・・・", comment: "")
                    let alertmessage = NSLocalizedString("ギリギリでしたね。。。", comment: "")
                    let alert3: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
                    
                    // ② Actionの設定
                    let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action:UIAlertAction!) -> Void in
                        self.sendreturn=500
                        self.app.result = 2
                        
                        
                        //third画面遷移
                        let storyboard: UIStoryboard = self.storyboard!
                        let nextView = storyboard.instantiateViewController(withIdentifier: "vsthird") as! vsthirdViewController
                        nextView.minenumber=String(self.mine[0])+String(self.mine[1])+String(self.mine[2])
                        nextView.cpunumber=String(self.cpu[0])+String(self.cpu[1])+String(self.cpu[2])
                        //nextView.session = self.session
                        //nextView.peerID = self.peerID
                        self.present(nextView, animated: true, completion: nil)
                        
                        
                    })
                    
                    // ③ UIAlertControllerにActionを追加
                    alert3.addAction(cancelAction)
                    
                    // ④ Alertを表示
                    var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                    while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                        baseview=baseview.presentedViewController!
                    }
                    baseview.present(alert3, animated: true, completion: nil)
                }else{
                    // ① UIAlertControllerクラスのインスタンスを生成
                    let alerttitle = NSLocalizedString("正解!!!", comment: "")
                    let alertmessage = NSLocalizedString("あなたの勝ちです！！", comment: "")
                    let alert3: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
                    
                    // ② Actionの設定
                    let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action:UIAlertAction!) -> Void in
                        
                        self.app.result = 3
                        self.sendreturn=500
                        
                        //third画面遷移
                        let storyboard: UIStoryboard = self.storyboard!
                        let nextView = storyboard.instantiateViewController(withIdentifier: "vsthird") as! vsthirdViewController
                        nextView.minenumber=String(self.mine[0])+String(self.mine[1])+String(self.mine[2])
                        nextView.cpunumber=String(self.cpu[0])+String(self.cpu[1])+String(self.cpu[2])
                        self.present(nextView, animated: true, completion: nil)
                     
                        
                    })
                    
                    // ③ UIAlertControllerにActionを追加
                    alert3.addAction(cancelAction)
                    
                    // ④ Alertを表示
                    var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                    while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                        baseview=baseview.presentedViewController!
                    }
                    baseview.present(alert3, animated: true, completion: nil)
                }
            }else{
                if(cpu_hit==3){
                    // ① UIAlertControllerクラスのインスタンスを生成
                    let alerttitle = NSLocalizedString("負け。。。", comment: "")
                    let alertmessage = NSLocalizedString("残念あなたの負けです。", comment: "")
                    let alert3: UIAlertController = UIAlertController(title: alerttitle,message: alertmessage, preferredStyle:.alert)
                    
                    // ② Actionの設定
                    let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action:UIAlertAction!) -> Void in
                        
                        self.app.result = 1
                        self.sendreturn=500
                        
                         //third画面遷移
                         let storyboard: UIStoryboard = self.storyboard!
                         let nextView = storyboard.instantiateViewController(withIdentifier: "vsthird") as! vsthirdViewController
                         nextView.minenumber=String(self.mine[0])+String(self.mine[1])+String(self.mine[2])
                         nextView.cpunumber=String(self.cpu[0])+String(self.cpu[1])+String(self.cpu[2])
                         self.present(nextView, animated: true, completion: nil)
                     
                        
                    })
                    
                    // ③ UIAlertControllerにActionを追加
                    alert3.addAction(cancelAction)
                    
                    // ④ Alertを表示
                    var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                    while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                        baseview=baseview.presentedViewController!
                    }
                    baseview.present(alert3, animated: true, completion: nil)
                }
            }
            self.mine_hit=0
            self.mine_blow=0
            self.cpu_hit=0
            self.cpu_blow=0
        }
    }
    
    
    func minejudge(){
        math(forecast:forecast_mine, math:cpu, &mine_hit, &mine_blow)
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let yosou = NSLocalizedString("自分の予想", comment: "")
        let alert8: UIAlertController = UIAlertController(title: yosou+"  "+String(forecast_mine[0])+String(forecast_mine[1])+String(forecast_mine[2]), message:String(mine_hit)+" "+"HIT"+" "+String(mine_blow)+" "+"BLOW", preferredStyle:.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action:UIAlertAction!) -> Void in
            self.zeroTouch.isEnabled = false
            self.oneTouch.isEnabled = false
            self.towTouch.isEnabled = false
            self.threeTouch.isEnabled = false
            self.fourTouch.isEnabled = false
            self.fiveTouch.isEnabled = false
            self.sixTouch.isEnabled = false
            self.sevenTouch.isEnabled = false
            self.eightTouch.isEnabled = false
            self.nineTouch.isEnabled = false
            self.delTouch.isEnabled = false
            self.okTouch.isEnabled=false
            self.make_mine_cells()
            self.judge()
            let sendmine = NSData(bytes:self.forecast_mine,length:self.forecast_mine.count*MemoryLayout<Int>.size)
            do {
                
                try self.app.session?.send(sendmine as Data,
                                      toPeers: (self.app.session?.connectedPeers)!,
                                      with: MCSessionSendDataMode.unreliable)
            } catch {
                print("Error sending data: \(error.localizedDescription)")
            }
        })
        
        // ③ UIAlertControllerにActionを追加
        alert8.addAction(cancelAction)
        
        // ④ Alertを表示
        var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
            baseview=baseview.presentedViewController!
        }
        baseview.present(alert8, animated: true, completion: nil)
        
    }
    
    @IBAction func sendChat(sender: UIButton) {
        // Bundle up the text in the message field, and send it off to all
        // connected peers
        //先攻
        if((self.t==0 && self.t2 == 0) && self.t3 == 0){
            
            // ① UIAlertControllerクラスのインスタンスを生成
            // タイトル, メッセージ, Alertのスタイルを指定する
            // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
            let alerttitle = NSLocalizedString("待機", comment: "")
            let alertmessage = NSLocalizedString("相手が数字を設定します。", comment: "")
            let alert: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
            
            // ② Actionの設定
            // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
            // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
            // OKボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action:UIAlertAction!) -> Void in
                
                let messages = NSLocalizedString("相手が数字を設定しています!", comment: "")
                self.turn_name.text=messages
                self.zeroTouch.isEnabled = false
                self.oneTouch.isEnabled = false
                self.towTouch.isEnabled = false
                self.threeTouch.isEnabled = false
                self.fourTouch.isEnabled = false
                self.fiveTouch.isEnabled = false
                self.sixTouch.isEnabled = false
                self.sevenTouch.isEnabled = false
                self.eightTouch.isEnabled = false
                self.nineTouch.isEnabled = false
                self.delTouch.isEnabled = false
                self.okTouch.isEnabled=false
                let sendmine = NSData(bytes:self.mine,length:self.mine.count*MemoryLayout<Int>.size)
                do {
                    
                    try self.app.session?.send(sendmine as Data,
                                          toPeers: (self.app.session?.connectedPeers)!,
                                          with: MCSessionSendDataMode.unreliable)
                } catch {
                    print("Error sending data: \(error.localizedDescription)")
                }
                
            })
            
            // ③ UIAlertControllerにActionを追加
            alert.addAction(cancelAction)
            
            // ④ Alertを表示
            var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
            while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                baseview=baseview.presentedViewController!
            }
            baseview.present(alert, animated: true, completion: nil)
            self.t+=1
            self.i=0
            print("A")
            //後攻
        }
        if((self.t==0 && self.t2 == 1) && self.t3 == 0){
            
            // ① UIAlertControllerクラスのインスタンスを生成
            // タイトル, メッセージ, Alertのスタイルを指定する
            // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
            let alerttitle = NSLocalizedString("待機", comment: "")
            let alertmessage = NSLocalizedString("相手が数字を予想しています!", comment: "")
            let alert01: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
            
            // ② Actionの設定
            // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
            // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
            // OKボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action:UIAlertAction!) -> Void in
                
                self.turn_name.text=alertmessage
                self.zeroTouch.isEnabled = false
                self.oneTouch.isEnabled = false
                self.towTouch.isEnabled = false
                self.threeTouch.isEnabled = false
                self.fourTouch.isEnabled = false
                self.fiveTouch.isEnabled = false
                self.sixTouch.isEnabled = false
                self.sevenTouch.isEnabled = false
                self.eightTouch.isEnabled = false
                self.nineTouch.isEnabled = false
                self.delTouch.isEnabled = false
                self.okTouch.isEnabled=false
                let sendmine = NSData(bytes:self.mine,length:self.mine.count*MemoryLayout<Int>.size)
                do {
                    
                    try self.app.session?.send(sendmine as Data,
                                          toPeers:(self.app.session?.connectedPeers)!,
                                          with: MCSessionSendDataMode.unreliable)
                } catch {
                    print("Error sending data: \(error.localizedDescription)")
                }
                
            })
            
            // ③ UIAlertControllerにActionを追加
            alert01.addAction(cancelAction)
            
            // ④ Alertを表示
            var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
            while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                baseview=baseview.presentedViewController!
            }
            baseview.present(alert01, animated: true, completion: nil)
            self.i=0
            self.t+=1
            print("B")
        }
        if((t==1 && t2==0) && t3==1){
            self.i=0
            minejudge()
            print("c")
        }
        
    }
    
    func ME3(viewController:UIViewController){
        
        // ① UIAlertControllerクラスのインスタンスを生成
        let alerttitle = NSLocalizedString("負け。。。", comment: "")
        let alertmessage = NSLocalizedString("後攻に当てられたので負けです。。", comment: "")
        let alert3: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
        
        // ② Actionの設定
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action:UIAlertAction!) -> Void in
            self.sendreturn=500
            self.make_cpu_cells()
            self.app.result = 1
           
           
            //third画面遷移
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "vsthird") as! vsthirdViewController
            nextView.minenumber=String(self.mine[0])+String(self.mine[1])+String(self.mine[2])
            nextView.cpunumber=String(self.cpu[0])+String(self.cpu[1])+String(self.cpu[2])
            self.present(nextView, animated: true, completion: nil)
            
            
        })
        
        // ③ UIAlertControllerにActionを追加
        alert3.addAction(cancelAction)
        
        // ④ Alertを表示
        var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
            baseview=baseview.presentedViewController!
        }
        baseview.present(alert3, animated: true, completion: nil)
        
    }
    
    
    func ME2(viewController:UIViewController){
        
        if(self.cpu_hit == 3){
            // ① UIAlertControllerクラスのインスタンスを生成
            let alerttitle = NSLocalizedString("引き分け・・・・", comment: "")
            let alertmessage = NSLocalizedString("惜しい！相手に当てられてしまいました", comment: "")
            let alert3: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
            
            // ② Actionの設定
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action:UIAlertAction!) -> Void in
                self.sendreturn=500
                self.make_cpu_cells()
                self.app.result = 2
                
                //third画面遷移
                let storyboard: UIStoryboard = self.storyboard!
                let nextView = storyboard.instantiateViewController(withIdentifier: "vsthird") as! vsthirdViewController
                nextView.minenumber=String(self.mine[0])+String(self.mine[1])+String(self.mine[2])
                nextView.cpunumber=String(self.cpu[0])+String(self.cpu[1])+String(self.cpu[2])
                self.present(nextView, animated: true, completion: nil)
                
                
            })
            
            // ③ UIAlertControllerにActionを追加
            alert3.addAction(cancelAction)
            
            // ④ Alertを表示
            var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
            while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                baseview=baseview.presentedViewController!
            }
            baseview.present(alert3, animated: true, completion: nil)
        }else{
            // ① UIAlertControllerクラスのインスタンスを生成
            let alerttitle = NSLocalizedString("勝利!!!!!!!!", comment: "")
            let alertmessage = NSLocalizedString("相手はあなたの数を当てられませんでした", comment: "")
            let alert3: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
            
            // ② Actionの設定
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action:UIAlertAction!) -> Void in
                self.app.result = 3
                self.sendreturn=500
                self.make_cpu_cells()
                
                //third画面遷移
                let storyboard: UIStoryboard = self.storyboard!
                let nextView = storyboard.instantiateViewController(withIdentifier: "vsthird") as! vsthirdViewController
                nextView.minenumber=String(self.mine[0])+String(self.mine[1])+String(self.mine[2])
                nextView.cpunumber=String(self.cpu[0])+String(self.cpu[1])+String(self.cpu[2])
                self.present(nextView, animated: true, completion: nil)
                
                
            })
            
            // ③ UIAlertControllerにActionを追加
            alert3.addAction(cancelAction)
            
            // ④ Alertを表示
            var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
            while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                baseview=baseview.presentedViewController!
            }
            baseview.present(alert3, animated: true, completion: nil)
        }
    }
    
    func ME(viewController:UIViewController){
        
        let yosou = NSLocalizedString("相手の予想", comment: "")
        let alert5: UIAlertController = UIAlertController(title: yosou+"  "+String(self.forecast_cpu[0])+String(self.forecast_cpu[1])+String(self.forecast_cpu[2]), message:String(self.cpu_hit)+" "+"HIT"+" "+String(self.cpu_blow)+" "+"BLOW", preferredStyle:UIAlertControllerStyle.alert)
        // ② Actionの設定
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action:UIAlertAction!) -> Void in
            
            
            self.zeroTouch.isEnabled = true
            self.oneTouch.isEnabled = true
            self.towTouch.isEnabled = true
            self.threeTouch.isEnabled = true
            self.fourTouch.isEnabled = true
            self.fiveTouch.isEnabled = true
            self.sixTouch.isEnabled = true
            self.sevenTouch.isEnabled = true
            self.eightTouch.isEnabled = true
            self.nineTouch.isEnabled = true
            self.delTouch.isEnabled = true
            self.okTouch.isEnabled = false
            
            self.make_cpu_cells()
            
            if(self.judge_turn==2){
                if(self.cpu_hit==3){
                    let alerttitle = NSLocalizedString("相手が正解しました!!!", comment: "")
                    let alertmessage = NSLocalizedString("このターンで当てないと負けです。", comment: "")
                    let alert100: UIAlertController = UIAlertController(title: alerttitle, message:alertmessage, preferredStyle:UIAlertControllerStyle.alert)
                    // ② Actionの設定
                    let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action:UIAlertAction!) -> Void in
                        
                        
                    })
                    // ③ UIAlertControllerにActionを追加
                    alert100.addAction(cancelAction)
                    // ④ Alertを表示
                    var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                    while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                        baseview=baseview.presentedViewController!
                    }
                    baseview.self.present(alert100, animated: true, completion: nil)
                }
            }
            
        })
        // ③ UIAlertControllerにActionを追加
        alert5.addAction(cancelAction)
        // ④ Alertを表示
        var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
            baseview=baseview.presentedViewController!
        }
        baseview.self.present(alert5, animated: true, completion: nil)
    }
    
    //後攻のアラート
    func alertfirst(viewConroller:UIViewController){
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alerttitle = NSLocalizedString("スタート", comment: "")
        let alertmessage = NSLocalizedString("自分の数字を３つ設定してください", comment: "")
        let alert: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action:UIAlertAction!) -> Void in
            
            self.turn_name.text=alertmessage
            self.zeroTouch.isEnabled = true
            self.oneTouch.isEnabled = true
            self.towTouch.isEnabled = true
            self.threeTouch.isEnabled = true
            self.fourTouch.isEnabled = true
            self.fiveTouch.isEnabled = true
            self.sixTouch.isEnabled = true
            self.sevenTouch.isEnabled = true
            self.eightTouch.isEnabled = true
            self.nineTouch.isEnabled = true
            self.delTouch.isEnabled = true
            self.okTouch.isEnabled=false
            
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        
        // ④ Alertを表示
        var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
            baseview=baseview.presentedViewController!
        }
        baseview.self.present(alert, animated: true, completion: nil)
        
    }
    
    func alertfirst2(viewController:UIViewController){
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alerttitle = NSLocalizedString("スタート", comment: "")
        let alertmessage = NSLocalizedString("相手の数字を予想してください!", comment: "")
        let alert10: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action:UIAlertAction!) -> Void in
            
            self.turn_name.text=alertmessage
            self.zeroTouch.isEnabled = true
            self.oneTouch.isEnabled = true
            self.towTouch.isEnabled = true
            self.threeTouch.isEnabled = true
            self.fourTouch.isEnabled = true
            self.fiveTouch.isEnabled = true
            self.sixTouch.isEnabled = true
            self.sevenTouch.isEnabled = true
            self.eightTouch.isEnabled = true
            self.nineTouch.isEnabled = true
            self.delTouch.isEnabled = true
            self.okTouch.isEnabled=false
            
        })
        
        // ③ UIAlertControllerにActionを追加
        alert10.addAction(cancelAction)
        
        // ④ Alertを表示
        var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
            baseview=baseview.presentedViewController!
        }
        baseview.self.present(alert10, animated: true, completion: nil)
    }
    
    @IBAction func showBrowser(sender: UIButton) {
        // Show the browser view controller
        self.present(self.browser, animated: true, completion: nil)
        
        self.ShowBrowser = 100
        
        self.zeroTouch.isEnabled = false
        self.oneTouch.isEnabled = false
        self.towTouch.isEnabled = false
        self.threeTouch.isEnabled = false
        self.fourTouch.isEnabled = false
        self.fiveTouch.isEnabled = false
        self.sixTouch.isEnabled = false
        self.sevenTouch.isEnabled = false
        self.eightTouch.isEnabled = false
        self.nineTouch.isEnabled = false
        self.delTouch.isEnabled = false
        self.okTouch.isEnabled=false
        connect.isHidden=true
        returnHome.isHidden=true
        Left1label.isHidden=false
        Left2label.isHidden=false
        Left3label.isHidden=false
        Right1label.isHidden=false
        Right2label.isHidden=false
        Right3label.isHidden=false
        turn.isHidden=false
        turn_name.isHidden=false
        forecast_label1.isHidden=false
        forecast_label2.isHidden=false
        forecast_label3.isHidden=false
        MineTableView.isHidden=false
        CpuTableView.isHidden=false
        zeroTouch.isHidden=false
        oneTouch.isHidden=false
        towTouch.isHidden=false
        threeTouch.isHidden=false
        fourTouch.isHidden=false
        fiveTouch.isHidden=false
        sixTouch.isHidden=false
        sevenTouch.isHidden=false
        eightTouch.isHidden=false
        nineTouch.isHidden=false
        delTouch.isHidden=false
        okTouch.isHidden=false
        cpu_name.isHidden=false
        mine_name.isHidden=false
    }
    
    func browserViewControllerDidFinish(
        _ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is dismissed (ie the Done
        // button was tapped)
        
        self.dismiss(animated: true, completion: nil)
        
        
        connect.isHidden=true
        returnHome.isHidden=true
        Left1label.isHidden=false
        Left2label.isHidden=false
        Left3label.isHidden=false
        Right1label.isHidden=false
        Right2label.isHidden=false
        Right3label.isHidden=false
        turn.isHidden=false
        turn_name.isHidden=false
        forecast_label1.isHidden=false
        forecast_label2.isHidden=false
        forecast_label3.isHidden=false
        MineTableView.isHidden=false
        CpuTableView.isHidden=false
        zeroTouch.isHidden=false
        oneTouch.isHidden=false
        towTouch.isHidden=false
        threeTouch.isHidden=false
        fourTouch.isHidden=false
        fiveTouch.isHidden=false
        sixTouch.isHidden=false
        sevenTouch.isHidden=false
        eightTouch.isHidden=false
        nineTouch.isHidden=false
        delTouch.isHidden=false
        okTouch.isHidden=false
        cpu_name.isHidden=false
        mine_name.isHidden=false
        
        self.turn_decition=UInt8(arc4random_uniform(10))
        if(turn_decition != nil){
            self.send_turn_decition[0]=turn_decition
        }
        let sendmine = NSData(bytes:self.send_turn_decition,length:self.send_turn_decition.count*MemoryLayout<UInt8>.size)
        do {
            
            try app.session?.send(sendmine as Data,
                                  toPeers: (app.session?.connectedPeers)!,
                                  with: MCSessionSendDataMode.unreliable)
        } catch {
            print("Error sending data: \(error.localizedDescription)")
        }
        
        if(self.cpu_turn_decition != nil && self.turn_decition != nil){
            if(self.turn_decition < self.cpu_turn_decition){
                
                let alerttitle = NSLocalizedString("後攻", comment: "")
                let alertmessage = NSLocalizedString("相手が数字を設定しています!", comment: "")
                let alert10: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:UIAlertControllerStyle.alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action:UIAlertAction!) -> Void in
                    self.turn_name.text=alertmessage
                    self.t4=0
                    self.judge_turn=2
                })
                alert10.addAction(cancelAction)
                var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                    baseview=baseview.presentedViewController!
                }
                baseview.self.present(alert10, animated: true, completion: nil)
            }else if(self.turn_decition == self.cpu_turn_decition){
                
                self.turn_decition=UInt8(arc4random_uniform(10))
                if(self.turn_decition != nil){
                    self.send_turn_decition[0]=UInt8(self.turn_decition)
                }
                
                let sendmine = NSData(bytes:self.send_turn_decition,length:self.send_turn_decition.count*MemoryLayout<UInt8>.size)
                do {
                    
                    try app.session?.send(sendmine as Data,
                                          toPeers: (app.session?.connectedPeers)!,
                                          with: MCSessionSendDataMode.unreliable)
                } catch {
                    print("Error sending data: \(error.localizedDescription)")
                }
            }else{
                let alerttitle = NSLocalizedString("先攻", comment: "")
                let alertmessage = NSLocalizedString("自分の数字を３つ設定してください", comment: "")
                let alert10: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:UIAlertControllerStyle.alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action:UIAlertAction!) -> Void in
                    self.turn_name.text=alertmessage
                    self.zeroTouch.isEnabled = true
                    self.oneTouch.isEnabled = true
                    self.towTouch.isEnabled = true
                    self.threeTouch.isEnabled = true
                    self.fourTouch.isEnabled = true
                    self.fiveTouch.isEnabled = true
                    self.sixTouch.isEnabled = true
                    self.sevenTouch.isEnabled = true
                    self.eightTouch.isEnabled = true
                    self.nineTouch.isEnabled = true
                    self.delTouch.isEnabled = true
                    self.okTouch.isEnabled=false
                    self.judge_turn=1
                })
                alert10.addAction(cancelAction)
                var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                    baseview=baseview.presentedViewController!
                }
                baseview.self.present(alert10, animated: true, completion: nil)
            }
        }
        
    }
    
    func browserViewControllerWasCancelled(
        _ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is cancelled
        
        self.dismiss(animated: true, completion: nil)
        self.connect.isHidden=false
        self.returnHome.isHidden=false
        self.Left1label.isHidden=true
        self.Left2label.isHidden=true
        self.Left3label.isHidden=true
        self.Right1label.isHidden=true
        self.Right2label.isHidden=true
        self.Right3label.isHidden=true
        self.turn.isHidden=true
        self.turn_name.isHidden=true
        self.forecast_label1.isHidden=true
        self.forecast_label2.isHidden=true
        self.forecast_label3.isHidden=true
        self.MineTableView.isHidden=true
        self.CpuTableView.isHidden=true
        self.zeroTouch.isHidden=true
        self.oneTouch.isHidden=true
        self.towTouch.isHidden=true
        self.threeTouch.isHidden=true
        self.fourTouch.isHidden=true
        self.fiveTouch.isHidden=true
        self.sixTouch.isHidden=true
        self.sevenTouch.isHidden=true
        self.eightTouch.isHidden=true
        self.nineTouch.isHidden=true
        self.delTouch.isHidden=true
        self.okTouch.isHidden=true
        self.mine_name.isHidden=true
        self.cpu_name.isHidden=true
    }
    
    func session(_ session: MCSession, didReceive data: Data,
                 fromPeer peerID: MCPeerID)  {
        // Called when a peer sends an NSData to us
        // This needs to run on the main queue
        DispatchQueue.main.async {
            var enemy_cpu:[UInt8] = [UInt8](data)
            
            if(self.t4==100){
                
                self.cpu_turn_decition=enemy_cpu[0]
                if(self.cpu_turn_decition != nil && self.turn_decition != nil){
                    if(self.turn_decition < self.cpu_turn_decition){
                        
                        let alerttitle = NSLocalizedString("後攻", comment: "")
                        let alertmessage = NSLocalizedString("相手が数字を設定しています!", comment: "")
                        let alert10: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:UIAlertControllerStyle.alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action:UIAlertAction!) -> Void in
                            self.turn_name.text=alertmessage
                            self.t4=0
                            self.judge_turn=2
                        })
                        alert10.addAction(cancelAction)
                        var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                        while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                            baseview=baseview.presentedViewController!
                        }
                        baseview.self.present(alert10, animated: true, completion: nil)
                    }else if(self.turn_decition == self.cpu_turn_decition){
                        
                        self.turn_decition=UInt8(arc4random_uniform(10))
                        if(self.turn_decition != nil){
                            self.send_turn_decition[0]=UInt8(self.turn_decition)
                        }
                        
                        let sendmine = NSData(bytes:self.send_turn_decition,length:self.send_turn_decition.count*MemoryLayout<UInt8>.size)
                        do {
                            
                            try self.app.session?.send(sendmine as Data,
                                                  toPeers: (self.app.session?.connectedPeers)!,
                                                  with: MCSessionSendDataMode.unreliable)
                        } catch {
                            print("Error sending data: \(error.localizedDescription)")
                        }
                    }else{
                        let alerttitle = NSLocalizedString("先攻", comment: "")
                        let alertmessage = NSLocalizedString("自分の数字を３つ設定してください", comment: "")
                        let alert10: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:UIAlertControllerStyle.alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action:UIAlertAction!) -> Void in
                            self.turn_name.text=alertmessage
                            self.zeroTouch.isEnabled = true
                            self.oneTouch.isEnabled = true
                            self.towTouch.isEnabled = true
                            self.threeTouch.isEnabled = true
                            self.fourTouch.isEnabled = true
                            self.fiveTouch.isEnabled = true
                            self.sixTouch.isEnabled = true
                            self.sevenTouch.isEnabled = true
                            self.eightTouch.isEnabled = true
                            self.nineTouch.isEnabled = true
                            self.delTouch.isEnabled = true
                            self.okTouch.isEnabled=false
                            self.judge_turn=1
                        })
                        alert10.addAction(cancelAction)
                        var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                        while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                            baseview=baseview.presentedViewController!
                        }
                        baseview.self.present(alert10, animated: true, completion: nil)
                    }
                }
                if(self.cpu_turn_decition != nil && self.turn_decition == nil){
                    
                    if(self.ShowBrowser==100){
                    self.dismiss(animated: true, completion: nil)
                    }
                    self.connect.isHidden=true
                    self.returnHome.isHidden=true
                    self.Left1label.isHidden=false
                    self.Left2label.isHidden=false
                    self.Left3label.isHidden=false
                    self.Right1label.isHidden=false
                    self.Right2label.isHidden=false
                    self.Right3label.isHidden=false
                    self.turn.isHidden=false
                    self.turn_name.isHidden=false
                    self.forecast_label1.isHidden=false
                    self.forecast_label2.isHidden=false
                    self.forecast_label3.isHidden=false
                    self.MineTableView.isHidden=false
                    self.CpuTableView.isHidden=false
                    self.zeroTouch.isHidden=false
                    self.oneTouch.isHidden=false
                    self.towTouch.isHidden=false
                    self.threeTouch.isHidden=false
                    self.fourTouch.isHidden=false
                    self.fiveTouch.isHidden=false
                    self.sixTouch.isHidden=false
                    self.sevenTouch.isHidden=false
                    self.eightTouch.isHidden=false
                    self.nineTouch.isHidden=false
                    self.delTouch.isHidden=false
                    self.okTouch.isHidden=false
                    self.cpu_name.isHidden=false
                    self.mine_name.isHidden=false
                    self.zeroTouch.isEnabled = false
                    self.oneTouch.isEnabled = false
                    self.towTouch.isEnabled = false
                    self.threeTouch.isEnabled = false
                    self.fourTouch.isEnabled = false
                    self.fiveTouch.isEnabled = false
                    self.sixTouch.isEnabled = false
                    self.sevenTouch.isEnabled = false
                    self.eightTouch.isEnabled = false
                    self.nineTouch.isEnabled = false
                    self.delTouch.isEnabled = false
                    self.okTouch.isEnabled=false
                    
                    
                    self.turn_decition=UInt8(arc4random_uniform(10))
                    if(self.turn_decition != nil){
                        self.send_turn_decition[0]=self.turn_decition
                    }
                    let sendmine = NSData(bytes:self.send_turn_decition,length:self.send_turn_decition.count*MemoryLayout<UInt8>.size)
                    do {
                        
                        try self.app.session?.send(sendmine as Data,
                                              toPeers: (self.app.session?.connectedPeers)!,
                                              with: MCSessionSendDataMode.unreliable)
                    } catch {
                        print("Error sending data: \(error.localizedDescription)")
                    }
                    if(self.turn_decition < self.cpu_turn_decition){
                        
                        let alerttitle = NSLocalizedString("後攻", comment: "")
                        let alertmessage = NSLocalizedString("相手が数字を設定しています!", comment: "")
                        let alert10: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:UIAlertControllerStyle.alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action:UIAlertAction!) -> Void in
                            self.turn_name.text=alertmessage
                            self.t4=0
                            self.judge_turn=2
                        })
                        alert10.addAction(cancelAction)
                        /*var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                        while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                            baseview=baseview.presentedViewController!
                        }
                        baseview.*/self.present(alert10, animated: true, completion: nil)
                    }else if(self.turn_decition == self.cpu_turn_decition){
                        
                        self.turn_decition=UInt8(arc4random_uniform(10))
                        if(self.turn_decition != nil){
                            self.send_turn_decition[0]=UInt8(self.turn_decition)
                        }
                        
                        let sendmine = NSData(bytes:self.send_turn_decition,length:self.send_turn_decition.count*MemoryLayout<UInt8>.size)
                        do {
                            
                            try self.app.session?.send(sendmine as Data,
                                                       toPeers: (self.app.session?.connectedPeers)!,
                                                       with: MCSessionSendDataMode.unreliable)
                        } catch {
                            print("Error sending data: \(error.localizedDescription)")
                        }
                    }else{
                        let alerttitle = NSLocalizedString("先攻", comment: "")
                        let alertmessage = NSLocalizedString("自分の数字を３つ設定してください", comment: "")
                        let alert10: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:UIAlertControllerStyle.alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action:UIAlertAction!) -> Void in
                            self.turn_name.text=alertmessage
                            self.zeroTouch.isEnabled = true
                            self.oneTouch.isEnabled = true
                            self.towTouch.isEnabled = true
                            self.threeTouch.isEnabled = true
                            self.fourTouch.isEnabled = true
                            self.fiveTouch.isEnabled = true
                            self.sixTouch.isEnabled = true
                            self.sevenTouch.isEnabled = true
                            self.eightTouch.isEnabled = true
                            self.nineTouch.isEnabled = true
                            self.delTouch.isEnabled = true
                            self.okTouch.isEnabled=false
                            self.judge_turn=1
                        })
                        alert10.addAction(cancelAction)
                        /*var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                        while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                            baseview=baseview.presentedViewController!
                        }
                        baseview.*/self.present(alert10, animated: true, completion: nil)
                    }
                }
            }else if(((self.t==0 && self.t2 == 0) && self.t3 == 0) && self.t4 != 100){
                
                self.cpu[0]=enemy_cpu[0]
                self.cpu[1]=enemy_cpu[1]
                self.cpu[2]=enemy_cpu[2]
                /*
                 self.Right1label.text=String(self.cpu[0])
                 self.Right2label.text=String(self.cpu[1])
                 self.Right3label.text=String(self.cpu[2])
                 */
                self.zeroTouch.isEnabled = true
                self.oneTouch.isEnabled = true
                self.towTouch.isEnabled = true
                self.threeTouch.isEnabled = true
                self.fourTouch.isEnabled = true
                self.fiveTouch.isEnabled = true
                self.sixTouch.isEnabled = true
                self.sevenTouch.isEnabled = true
                self.eightTouch.isEnabled = true
                self.nineTouch.isEnabled = true
                self.delTouch.isEnabled = true
                self.t2=1
                self.alertfirst(viewConroller: self)
                
            }else if((self.t==1 && self.t2 ==  0) && self.t3 == 0){
                self.cpu[0]=enemy_cpu[0]
                self.cpu[1]=enemy_cpu[1]
                self.cpu[2]=enemy_cpu[2]
                /*
                 self.Right1label.text=String(self.cpu[0])
                 self.Right2label.text=String(self.cpu[1])
                 self.Right3label.text=String(self.cpu[2])
                 */
                self.zeroTouch.isEnabled = true
                self.oneTouch.isEnabled = true
                self.towTouch.isEnabled = true
                self.threeTouch.isEnabled = true
                self.fourTouch.isEnabled = true
                self.fiveTouch.isEnabled = true
                self.sixTouch.isEnabled = true
                self.sevenTouch.isEnabled = true
                self.eightTouch.isEnabled = true
                self.nineTouch.isEnabled = true
                self.delTouch.isEnabled = true
                self.t3=1
                self.alertfirst2(viewController: self)
            }else{
                self.t2=0
                self.t3=1
                //enable
                self.zeroTouch.isEnabled = false
                self.oneTouch.isEnabled = false
                self.towTouch.isEnabled = false
                self.threeTouch.isEnabled = false
                self.fourTouch.isEnabled = false
                self.fiveTouch.isEnabled = false
                self.sixTouch.isEnabled = false
                self.sevenTouch.isEnabled = false
                self.eightTouch.isEnabled = false
                self.delTouch.isEnabled = false
                self.okTouch.isEnabled=false
                
                self.forecast_cpu[0]=enemy_cpu[0]
                self.forecast_cpu[1]=enemy_cpu[1]
                self.forecast_cpu[2]=enemy_cpu[2]
                self.math(forecast:self.forecast_cpu, math:self.mine, &self.cpu_hit, &self.cpu_blow)
                if(self.judge_turn==1 && self.mine_hit==3){
                    self.ME2(viewController: self)
                }else if(self.judge_turn==1 && self.cpu_hit==3){
                    self.ME3(viewController: self)
                }else{
                    self.ME(viewController: self)
                }
                
                
            }
        }
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, with progress: Progress)  {
        
        // Called when a peer starts sending a file to us
    }
    
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL, withError error: Error?)  {
        // Called when a file has finished transferring from another peer
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream,
                 withName streamName: String, fromPeer peerID: MCPeerID)  {
        // Called when a peer establishes a stream with us
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID,
                 didChange state: MCSessionState)  {
        // Called when a connected peer changes state (for example, goes offline)
        DispatchQueue.main.async {
            
            if(state==MCSessionState.notConnected){
                let alerttitle = NSLocalizedString("接続不可", comment: "")
                let alertmessage = NSLocalizedString("相手との接続が切れました", comment: "")
                let alert: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:UIAlertControllerStyle.alert)
                
                // ② Actionの設定
                // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
                // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
                // OKボタン
                let canceltitle = NSLocalizedString("再接続", comment: "")
                let cancelAction: UIAlertAction = UIAlertAction(title: canceltitle, style:.default,handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action:UIAlertAction!) -> Void in
                    
                    self.app.mine_cell.removeAllObjects()
                    self.app.mine_hit_cell.removeAllObjects()
                    self.app.mine_blow_cell.removeAllObjects()
                    
                    self.app.cpu_cell.removeAllObjects()
                    self.app.cpu_hit_cell.removeAllObjects()
                    self.app.cpu_blow_cell.removeAllObjects()
                    
                    self.MineTableView.reloadData()
                    self.CpuTableView.reloadData()
                    
                    
                    
                    self.connect.isHidden=false
                    self.returnHome.isHidden=false
                    self.Left1label.isHidden=true
                    self.Left2label.isHidden=true
                    self.Left3label.isHidden=true
                    self.Right1label.isHidden=true
                    self.Right2label.isHidden=true
                    self.Right3label.isHidden=true
                    self.turn.isHidden=true
                    self.turn_name.isHidden=true
                    self.forecast_label1.isHidden=true
                    self.forecast_label2.isHidden=true
                    self.forecast_label3.isHidden=true
                    self.MineTableView.isHidden=true
                    self.CpuTableView.isHidden=true
                    self.zeroTouch.isHidden=true
                    self.oneTouch.isHidden=true
                    self.towTouch.isHidden=true
                    self.threeTouch.isHidden=true
                    self.fourTouch.isHidden=true
                    self.fiveTouch.isHidden=true
                    self.sixTouch.isHidden=true
                    self.sevenTouch.isHidden=true
                    self.eightTouch.isHidden=true
                    self.nineTouch.isHidden=true
                    self.delTouch.isHidden=true
                    self.okTouch.isHidden=true
                    self.mine_name.isHidden=true
                    self.cpu_name.isHidden=true
                    
                    
                })
                let actiontitle = NSLocalizedString("ホーム画面", comment: "")
                let Action: UIAlertAction = UIAlertAction(title: actiontitle, style:.default,handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action:UIAlertAction!) -> Void in
                    
                    let View = self.storyboard?.instantiateViewController(withIdentifier: "first") as! ViewController
                    self.app.session = nil
                    self.present(View, animated: true, completion: nil)
                })
                // ③ UIAlertControllerにActionを追加
                alert.addAction(cancelAction)
                alert.addAction(Action)
                
                
                // ④ Alertを表示
                var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                    baseview=baseview.presentedViewController!
                }
                baseview.self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func returnHome(_ sender: Any) {
        self.app.session=nil
    }
    
    
    
}

