//
//  vsthirdViewController.swift
//  mastermind
//

//  Copyright © 2017年 takahashi kei. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import GoogleMobileAds
class vsthirdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MCSessionDelegate,GADBannerViewDelegate{

    
    @IBOutlet weak var admobView: GADBannerView!
    
    let AdMobID = "ca-app-pub-4512223201861912~9267310587"
    let TEST_ID = "ca-app-pub-4512223201861912/3220776980"
    
    let AdMobTest:Bool = true
    
    
    @IBOutlet weak var result_label: UILabel!
    @IBOutlet weak var mine2Tableview: UITableView!
    @IBOutlet weak var cpu2Tableview: UITableView!
    @IBOutlet weak var mine: UILabel!
    @IBOutlet weak var cpu: UILabel!
    
    let app:AppDelegate=(UIApplication.shared.delegate as! AppDelegate)
    
    
    var minenumber:String=" "
    var cpunumber:String=" "
    var turn_decition:UInt8!=nil
    var send_turn_decition:[UInt8] = [0]
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
    
    var SendData:Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.session.delegate = self
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
        
        app.session?.delegate = self
        let label = UILabel.init()
        label.adjustsFontSizeToFitWidth=true
        
       
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
    @IBOutlet weak var returnbutton: UIButton!
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
    
    @IBOutlet weak var oncebutton: UIButton!
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
        app.returntest=100
        if(SendData==100){
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
            let View = self.storyboard?.instantiateViewController(withIdentifier: "vs2") as! vs2ViewController
            View.cpu_turn_decition = nil
        }
    }
   
    
    func session(_ session: MCSession, didReceive data: Data,
                 fromPeer peerID: MCPeerID)  {
        DispatchQueue.main.async {
            var enemy_cpu:[UInt8] = [UInt8](data)
            let View = self.storyboard?.instantiateViewController(withIdentifier: "vs2") as! vs2ViewController
            View.cpu_turn_decition=enemy_cpu[0]
            self.app.returntest=100
            self.SendData = 0
            self.app.mine_cell.removeAllObjects()
            self.app.mine_hit_cell.removeAllObjects()
            self.app.mine_blow_cell.removeAllObjects()
            
            self.app.cpu_cell.removeAllObjects()
            self.app.cpu_hit_cell.removeAllObjects()
            self.app.cpu_blow_cell.removeAllObjects()
            
            self.mine2Tableview.reloadData()
            self.cpu2Tableview.reloadData()
            self.present(View, animated: true, completion: nil)
        }
        
    }
    
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
        
        DispatchQueue.main.async {
            
            if(state==MCSessionState.notConnected){
                
                let alert: UIAlertController = UIAlertController(title: "接続遮断", message: "接続が切れました。", preferredStyle:UIAlertControllerStyle.alert)
                
                // ② Actionの設定
                // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
                // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
                // OKボタン
                let cancelAction: UIAlertAction = UIAlertAction(title: "再接続", style:.default,handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action:UIAlertAction!) -> Void in
                    self.oncebutton.isHidden=true
                    let View = self.storyboard?.instantiateViewController(withIdentifier: "vs2") as! vs2ViewController
                    self.app.returntest=0
                    
                    self.present(View, animated: true, completion: nil)
                    
                })
                let Action: UIAlertAction = UIAlertAction(title: "ホーム画面", style:.default,handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action:UIAlertAction!) -> Void in
                    
                    let View = self.storyboard?.instantiateViewController(withIdentifier: "first") as! ViewController
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
   
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
