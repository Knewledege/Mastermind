//
//  secondViewController.swift
//  mastermind
//

//  Copyright © 2017年 takahashi kei. All rights reserved.
//

import UIKit
import GoogleMobileAds

class secondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate{
    @IBOutlet weak var admobView: GADBannerView!
    
    let AdMobID = " ca-app-pub-4512223201861912~9267310587"
    let TEST_ID = "ca-app-pub-4512223201861912/3220776980"
    
    let AdMobTest:Bool = true
    
    @IBOutlet weak var mineTableView: UITableView!
    @IBOutlet weak var cpuTableView: UITableView!
    
    //左のtableview
    
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
        
        
        fight_ud.register(defaults: ["fightid":fight])
        win_ud.register(defaults: ["winid":win])
        
        fight=fight_ud.object(forKey: "fightid") as! Double
        win=win_ud.object(forKey: "winid") as! Double
        
        //dataSourceの設定
        mineTableView.dataSource = self
        //delegateの設定
        mineTableView.delegate = self
        
        
        
        //dataSourceの設定
        cpuTableView.dataSource = self
        //delegateの設定
        cpuTableView.delegate = self
        
        //コンピュータの数を生成
        var val:Int = 0
        
        var j1:Int=0
        
        
        var miss:Int = 0
        repeat{
            for q1 in 0..<3 {
                j1=0
                repeat {
                    val = Int(arc4random_uniform(10))
                    for _ in 0..<q1{
                        if val == cpu[j1] {
                            break
                        }
                        j1+=1
                    }
                    
                }while j1 < q1
                cpu[q1] = val;
            }
            
            for i in 0..<3{
                for j in 0..<3{
                    if(i != j){
                        if(cpu[i]==cpu[j]){
                            miss += 1
                        }
                    }
                }
            }
            
        }while miss > 0
        
        
        
        var o :Int=0
        var p :Int=0
        var z :Int=0
        var n :Int=0
        var valu :Int=0
        var k :Int=0
        var g :Int=0
        
        repeat{
            miss=0
        while k<720 {
            g=0
            while g<3 {
                repeat{
                    valu=Int(arc4random_uniform(10))
                    o=0
                    while o<g {
                        if(valu==s[k][o]){
                            break;
                        }
                        o+=1
                    }
                }while(o<g);
                s[k][g]=valu;
                g+=1
            }
            
            
            
            
            if k != 0 {
                p=0
                while p < k {
                    n=0
                    z=0
                    while z<3 {
                        if s[k][z]==s[p][z] {
                            n+=1
                        }else{
                            break
                        }
                        z+=1
                    }
                    
                    if n==3 {
                        g=0
                        while g<3 {
                            repeat{
                                valu=Int(arc4random_uniform(10))
                                o=0
                                while o<g {
                                    if valu==s[k][o]{
                                        break;
                                    }
                                    o+=1
                                }
                            }while o<g
                            s[k][g]=valu
                            g+=1
                        }
                        p = -1
                    }
                    
                    p+=1
                }
            }
            
            k+=1
        }
        
        for k in 0..<720 {
            for i in 0..<3{
                for j in 0..<3{
                    if(i != j){
                        if(s[k][i]==s[k][j]){
                            miss += 1
                        }
                    }
                }
            }
        }
    }while miss > 0

        repeat{
            miss=0
            k=0
        for i in 0..<3{
            for j in 0..<3{
                if(i != j){
                    if(s[k][i]==s[k][j]){
                        miss += 1
                    }
                }
            }
        }
            if(miss==0){
        
                forecast_cpu[0]=s[k][0]
                forecast_cpu[1]=s[k][1]
                forecast_cpu[2]=s[k][2]
            }else{
                k+=1
            }
        }while miss > 0
        //cpuの設定した数字表示
        Right1Label.text="?"
        Right2Label.text="?"
        Right3Label.text="?"
        
        zeroTouch.isEnabled = false
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
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alerttitle = NSLocalizedString("はじめ", comment: "")
        let alertmessage = NSLocalizedString("自分の数字を３つ設定してください", comment: "")
        let alert: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let canceltitle = NSLocalizedString("スタート", comment: "")
        let cancelAction: UIAlertAction = UIAlertAction(title: canceltitle, style:.default,handler:{
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
            let messages = NSLocalizedString("自分の数字を３つ設定してください", comment: "")
            self.turn_name.text=messages
            
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        
        // ④ Alertを表示
        var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
            baseview=baseview.presentedViewController!
        }
        baseview.present(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
    
    //比較対象格納
    var cpu = [Int](repeating: 0, count: 3)
    var mine = [Int](repeating:0,count:3)
    
    var forecast_mine = [Int](repeating:0,count:3)
    var forecast_cpu = [Int](repeating:0,count:3)
    
    
    //プレイヤーのHITとBLOW
    var mine_hit:Int = 0
    var mine_blow:Int = 0
    
    
    //CPUのHITとBLOW
    var cpu_hit:Int = 0
    var cpu_blow:Int = 0
    
    
    var s = [[Int]](repeating: [Int](repeating: 0, count: 3),
                    count: 720)
    var v = [[Int]](repeating: [Int](repeating: 0, count: 3),
                    count: 720)
    
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
    
    
    
    @IBAction func zeroTouch(_ sender: UIButton) {
        if(t==0){
            
            if(i==0){
                Left1Label.text = "0"
            }
            if(i==1){
                Left2Label.text = "0"
            }
            if(i==2){
                Left3Label.text = "0"
            }
            mine[i]=0
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
        
        if(t==0){
            if(i==0){
                Left1Label.text = "1"
            }
            if(i==1){
                Left2Label.text = "1"
            }
            if(i==2){
                Left3Label.text = "1"
            }
            mine[i]=1
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
        if(t==0){
            if(i==0){
                Left1Label.text = "2"
            }
            if(i==1){
                Left2Label.text = "2"
            }
            if(i==2){
                Left3Label.text = "2"
            }
            mine[i]=2
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
        if(t==0){
            if(i==0){
                Left1Label.text = "3"
            }
            if(i==1){
                Left2Label.text = "3"
            }
            if(i==2){
                Left3Label.text = "3"
            }
            mine[i]=3
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
        if(t==0){
            if(i==0){
                Left1Label.text = "4"
            }
            if(i==1){
                Left2Label.text = "4"
            }
            if(i==2){
                Left3Label.text = "4"
            }
            mine[i]=4
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
        if(t==0){
            if(i==0){
                Left1Label.text = "5"
            }
            if(i==1){
                Left2Label.text = "5"
            }
            if(i==2){
                Left3Label.text = "5"
            }
            mine[i]=5
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
        if(t==0){
            
            if(i==0){
                Left1Label.text = "6"
            }
            if(i==1){
                Left2Label.text = "6"
            }
            if(i==2){
                Left3Label.text = "6"
            }
            mine[i]=6
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
        if(t==0){
            if(i==0){
                Left1Label.text = "7"
            }
            if(i==1){
                Left2Label.text = "7"
            }
            if(i==2){
                Left3Label.text = "7"
            }
            mine[i]=7
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
        if(t==0){
            if(i==0){
                Left1Label.text = "8"
            }
            if(i==1){
                Left2Label.text = "8"
            }
            if(i==2){
                Left3Label.text = "8"
            }
            mine[i]=8
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
        if(t==0){
            if(i==0){
                Left1Label.text = "9"
            }
            if(i==1){
                Left2Label.text = "9"
            }
            if(i==2){
                Left3Label.text = "9"
            }
            mine[i]=9
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
        if(t==0){
            Left1Label.text = "?"
            Left2Label.text = "?"
            Left3Label.text = "?"
            
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
    
    
    
    
    
    func reset(_ v:inout[[Int]],_ s:inout[[Int]]) -> Void
    {
        
        
        
        for k_reset in 0..<720 {
            for i_reset in 0..<3 {
                s[k_reset][i_reset]=v[k_reset][i_reset]
                v[k_reset][i_reset]=0
            }
        }
        
    }
    
    func E0B0(_ no:inout[Int] ,_ v:inout[[Int]] ,_ s:inout[[Int]])
    {
        
        var w=0
        var z=0
        var a=0
        var b=0
        var c=0
        var k=0
        var i0=0
        
        a=no[0]
        b=no[1]
        c=no[2]
        
        while k<720 {
            if((s[k][0]==a && s[k][1]==b) && s[k][2]==c){
                w+=1
            }
            for i0 in 0..<3{
                if((s[k][i0]==a || s[k][i0]==b) || s[k][i0]==c){
                    w+=1
                }
            }
            if(w==0){
                i0=0
                while i0<3 {
                    v[z][i0]=s[k][i0]
                    i0+=1
                }
                z+=1
            }
            w=0
            k+=1
        }
        i0=0
        while i0<3{
            no[i0]=v[0][i0]
            i0+=1
        }
        var miss:Int=0
        repeat{
            miss=0
            k=0
            i0=0
            for i in 0..<3{
                for j in 0..<3{
                    if(i != j){
                        if(no[i] == no[j]){
                            miss += 1
                        }
                    }
                }
            }
            k+=1
            if(miss != 0){
                while i0<3{
                    no[i0]=v[k][i0]
                    i0+=1
                }
            }
        }while miss > 0
        reset(&v,&s)
    }
    
    
    func E0B1(q:Int,_ no:inout[Int] ,_ v:inout[[Int]] ,_ s:inout[[Int]])
    {
        
        
        var w=0
        var z=0
        var p=0
        var a=0
        var b=0
        var c=0
        var k=0
        var i1=0
        
        a=no[0];
        b=no[1];
        c=no[2];
        
        repeat{
            p=Int(arc4random_uniform(10))
        }while a==p || b==p
        
        while k<720 {
            w=0;
            if((s[k][0]==a && s[k][1]==b) && s[k][2]==c){
                w+=5;
            }
            if((s[k][0]==a || s[k][1]==b) || s[k][2]==c){
                w=5;
            }else{
                if(s[k][1]==a || s[k][2]==a){
                    w+=1;
                }
                if(s[k][0]==b || s[k][2]==b){
                    w+=1;
                }
                if(s[k][0]==c || s[k][1]==c){
                    w+=1;
                }
            }
            if(w==1){
                i1=0
                while i1<3 {
                    v[z][i1]=s[k][i1];
                    i1+=1
                }
                z+=1;
            }
            k+=1
        }
        
        if(q==0){
            no[0]=b;
            no[1]=a;
            no[2]=p;
            
        }else{
            i1=0
            while i1<3 {
                no[i1]=v[0][i1]
                i1+=1
            }
        }
        var miss:Int=0
        repeat{
            miss=0
            k=0
            i1=0
            for i in 0..<3{
                for j in 0..<3{
                    if(i != j){
                        if(no[i] == no[j]){
                            miss += 1
                        }
                    }
                }
            }
            k+=1
            if(miss != 0){
                while i1<3{
                    no[i1]=v[k][i1]
                    i1+=1
                }
            }
        }while miss > 0
        reset(&v,&s)
    }
    
    func E0B2(_ no:inout[Int] ,_ v:inout[[Int]] ,_ s:inout[[Int]])
    {
        
        
        var w=0
        var z=0
        var a=0
        var b=0
        var c=0
        var k=0
        var i2=0
        
        a=no[0];
        b=no[1];
        c=no[2];
        
        while k<720 {
            w=0;
            if((s[k][0]==a && s[k][1]==b) && s[k][2]==c){
                w+=5;
            }
            if((s[k][0]==a || s[k][1]==b) || s[k][2]==c){
                w+=5;
            }else{
                if(s[k][1]==a || s[k][2]==a){
                    w+=1;
                }
                if(s[k][0]==b || s[k][2]==b){
                    w+=1;
                }
                if(s[k][0]==c || s[k][1]==c){
                    w+=1;
                }
            }
            if(w==2){
                i2=0
                while i2<3{
                    v[z][i2]=s[k][i2]
                    i2+=1
                }
                z+=1;
            }
            w=0;
            k+=1
        }
        i2=0
        while i2<3 {
            no[i2]=v[0][i2]
            i2+=1
        }
        var miss:Int=0
        repeat{
            miss=0
            k=0
            i2=0
            for i in 0..<3{
                for j in 0..<3{
                    if(i != j){
                        if(no[i] == no[j]){
                            miss += 1
                        }
                    }
                }
            }
            k+=1
            if(miss != 0){
                while i2<3{
                    no[i2]=v[k][i2]
                    i2+=1
                }
            }
        }while miss > 0
        reset(&v,&s)
    }
    
    
    func E0B3(_ no:inout[Int] ,_ v:inout[[Int]] ,_ s:inout[[Int]])
    {
        
        var w=0
        var z=0
        var a=0
        var b=0
        var c=0
        var k=0
        var i3=0
        
        a=no[0];
        b=no[1];
        c=no[2];
        
        while k<720 {
            w=0;
            if((s[k][0]==a && s[k][1]==b) && s[k][2]==c){
                w+=5;
            }
            if((s[k][0]==a || s[k][1]==b) || s[k][2]==c){
                w+=1;
            }else{
                if(s[k][1]==a || s[k][2]==a){
                    w+=1;
                }
                if(s[k][0]==b || s[k][2]==b){
                    w+=1;
                }
                if(s[k][0]==c || s[k][1]==c){
                    w+=1;
                }
                if(w==3){
                    i3=0
                    while i3<3 {
                        v[z][i3]=s[k][i3]
                        i3+=1
                    }
                    z+=1;
                }
                w=0;
            }
            i3=0
            while i3<3 {
                no[i3]=v[0][i3]
                i3+=1
            }
            k+=1
        }
        var miss:Int=0
        repeat{
            miss=0
            k=0
            i3=0
            for i in 0..<3{
                for j in 0..<3{
                    if(i != j){
                        if(no[i] == no[j]){
                            miss += 1
                        }
                    }
                }
            }
            k+=1
            if(miss != 0){
                while i3<3{
                    no[i3]=v[k][i3]
                    i3+=1
                }
            }
        }while miss > 0
        reset(&v,&s)
        
    }
    
    
    func E1B0(_ no:inout[Int] ,_ v:inout[[Int]] ,_ s:inout[[Int]])
    {
        
        var w=0
        var z=0
        var a=0
        var b=0
        var c=0
        var i4=0
        var k=0
        
        a=no[0];
        b=no[1];
        c=no[2];
        
        while k<720 {
            w=0;
            if((s[k][0]==a && s[k][1]==b) && s[k][2]==c){
                w+=5;
            }
            if(s[k][0]==a){
                if( (s[k][1] != b && s[k][2] != b) && (s[k][1] != c && s[k][2] != c) ){
                    w+=1;
                }
            }
            else if(s[k][1]==b){
                if( (s[k][0] != a && s[k][2] != a) && (s[k][0] != c && s[k][2] != c) ){
                    w+=1;
                }
            }
            else if(s[k][2]==c){
                if( (s[k][0] != a && s[k][1] != a) && (s[k][0] != b && s[k][1] != b) ){
                    w+=1;
                }
            }
            
            if(w==1){
                i4=0
                while i4<3 {
                    v[z][i4]=s[k][i4]
                    i4+=1
                }
                z+=1;
            }
            
            k+=1
        }
        
        
        for i4 in 0..<3 {
            no[i4]=v[0][i4];
        }
        var miss:Int=0
        repeat{
            miss=0
            k=0
            i4=0
            for i in 0..<3{
                for j in 0..<3{
                    if(i != j){
                        if(no[i] == no[j]){
                            miss += 1
                        }
                    }
                }
            }
            k+=1
            if(miss != 0){
                while i4<3{
                    no[i4]=v[k][i4]
                    i4+=1
                }
            }
        }while miss > 0
        reset(&v,&s)
        
    }
    
    func E1B1(_ no:inout[Int] ,_ v:inout[[Int]] ,_ s:inout[[Int]])
    {
        
        var w=0
        var z=0
        var a=0
        var b=0
        var c=0
        var i5=0
        var k=0
        
        
        a=no[0];
        b=no[1];
        c=no[2];
        
        while k<720  {
            w=0;
            if((s[k][0]==a && s[k][1]==b) && s[k][2]==c){
                w+=5;
            }
            if(s[k][0]==a){
                if( (s[k][1] != b && s[k][2]==b) && (s[k][1] != c && s[k][2] != c) ){
                    w+=1;
                }else if( (s[k][1] != b && s[k][2] != b) && (s[k][1]==c && s[k][2] != c) ){
                    w+=1;
                }else{
                    w=0;
                }
            }
                
            else if(s[k][1]==b){
                if( (s[k][0] != a && s[k][2]==a) && (s[k][0] != c && s[k][2] != c) ){
                    w+=1;
                }else if( (s[k][0] != a && s[k][2] != a) && (s[k][0]==c && s[k][2] != c) ){
                    w+=1;
                }else{
                    w=0;
                }
            }
                
                
            else if(s[k][2]==c){
                if( (s[k][0] != a && s[k][1]==a) && (s[k][0] != b && s[k][1] != b) ){
                    w+=1;
                }else if( (s[k][0] != a && s[k][1] != a) && (s[k][0]==b && s[k][1] != b) ){
                    w+=1;
                }else{
                    w=0;
                }
            }
            
            
            if(w==1){
                i5=0
                while i5<3 {
                    v[z][i5]=s[k][i5]
                    i5+=1
                }
                z+=1;
            }
            k+=1
        }
        
        i5=0
        while i5<3 {
            no[i5]=v[0][i5]
            i5+=1
        }
        var miss:Int=0
        repeat{
            miss=0
            k=0
            i5=0
            for i in 0..<3{
                for j in 0..<3{
                    if(i != j){
                        if(no[i] == no[j]){
                            miss += 1
                        }
                    }
                }
            }
            k+=1
            if(miss != 0){
                while i5<3{
                    no[i5]=v[k][i5]
                    i5+=1
                }
            }
        }while miss > 0
        reset(&v,&s)
        
    }
    
    
    func E1B2(_ no:inout[Int] ,_ v:inout[[Int]] ,_ s:inout[[Int]])
    {
        
        var w=0
        var z=0
        var a=0
        var b=0
        var c=0
        var k=0
        var i6=0
        
        a=no[0];
        b=no[1];
        c=no[2];
        
        while k<720  {
            w=0;
            if((s[k][0]==a && s[k][1]==b) && s[k][2]==c){
                w+=5;
            }
            
            if(s[k][0]==a){
                if( (s[k][1] != b && s[k][2]==b) && (s[k][1]==c && s[k][2] != c) ){
                    w+=1;
                }
            }
                
            else if(s[k][1]==b){
                if( (s[k][0] != a && s[k][2]==a) && (s[k][0]==c && s[k][2] != c) ){
                    w+=1;
                }
            }
                
                
            else if(s[k][2]==c){
                if( (s[k][0] != a && s[k][1]==a) && (s[k][0]==b && s[k][1] != b) ){
                    w+=1;
                }
            }
            else{
                w=0;
            }
            
            
            if(w==1){
                i6=0
                while i6<3 {
                    v[z][i6]=s[k][i6]
                    i6+=1
                }
                z+=1;
            }
            k+=1
        }
        
        i6=0
        while i6<3 {
            no[i6]=v[0][i6]
            i6+=1
        }
        var miss:Int=0
        repeat{
            miss=0
            k=0
            i6=0
            for i in 0..<3{
                for j in 0..<3{
                    if(i != j){
                        if(no[i] == no[j]){
                            miss += 1
                        }
                    }
                }
            }
            k+=1
            if(miss != 0){
                while i6<3{
                    no[i6]=v[k][i6]
                    i6+=1
                }
            }
        }while miss > 0
        reset(&v,&s)
        
    }
    
    func E2B0(_ no:inout[Int] ,_ v:inout[[Int]] ,_ s:inout[[Int]])
    {
        
        
        var w=0
        var z=0
        var a=0
        var b=0
        var c=0
        var k=0
        var i7=0
        
        a=no[0];
        b=no[1];
        c=no[2];
        
        while k<720  {
            w=0;
            if((s[k][0]==a && s[k][1]==b) && s[k][2]==c){
                w+=5;
            }
            
            if(s[k][0]==a){
                if(s[k][1]==b) && (s[k][2] != c){
                    w+=1;
                }
                if(s[k][1] != b && s[k][2]==c){
                    w+=1;
                }
            }
                
            else if(s[k][1]==b){
                if(s[k][0]==a && s[k][2] != c){
                    w+=1;
                }
                if(s[k][0] != a && s[k][2]==c){
                    w+=1;
                }
            }
                
                
            else if(s[k][2]==c){
                if(s[k][0]==a && s[k][1] != b){
                    w+=1;
                }
                if(s[k][0] != a && s[k][1]==b){
                    w+=1;
                }
            }
                
            else{
                w=0;
            }
            
            
            if(w==1){
                i7=0
                while i7<3 {
                    v[z][i7]=s[k][i7]
                    i7+=1
                }
                z+=1;
            }
            k+=1
        }
        i7=0
        while i7<3 {
            no[i7]=v[0][i7]
            i7+=1
        }
        
        var miss:Int=0
        repeat{
            miss=0
            k=0
            i7=0
            for i in 0..<3{
                for j in 0..<3{
                    if(i != j){
                        if(no[i] == no[j]){
                            miss += 1
                        }
                    }
                }
            }
            k+=1
            if(miss != 0){
                while i7<3{
                    no[i7]=v[k][i7]
                    i7+=1
                }
            }
        }while miss > 0
        
        reset(&v,&s)
    }
    
    
    
    
    
    
    
    //比較
    func mine_math(forecast:[Int],math:[Int],_ hit:inout Int,_ blow:inout Int){
        
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
        mineTableView.reloadData()
        
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
        cpuTableView.reloadData()
        
        forecast_label1.text = "?"
        forecast_label2.text = "?"
        forecast_label3.text = "?"
    }
    
    
    
    
    func forecastcpu(){
        if(cpu_hit==0 && cpu_blow==0){  E0B0(&forecast_cpu,&v,&s)  }
        if(cpu_hit==0 && cpu_blow==1){  E0B1(q:t,&forecast_cpu,&v,&s)  }
        if(cpu_hit==0 && cpu_blow==2){  E0B2(&forecast_cpu,&v,&s)  }
        if(cpu_hit==0 && cpu_blow==3){  E0B3(&forecast_cpu,&v,&s)  }
        if(cpu_hit==1 && cpu_blow==0){  E1B0(&forecast_cpu,&v,&s)  }
        if(cpu_hit==1 && cpu_blow==1){  E1B1(&forecast_cpu,&v,&s)  }
        if(cpu_hit==1 && cpu_blow==2){  E1B2(&forecast_cpu,&v,&s)  }
        if(cpu_hit==2 && cpu_blow==0){  E2B0(&forecast_cpu,&v,&s)  }
    }
    
    
    
    func judge2(){
        if(mine_hit == 3){
            if(cpu_hit == 3){
                
                //cpuの設定した数字表示
                Right1Label.text=String(cpu[0])
                Right2Label.text=String(cpu[1])
                Right3Label.text=String(cpu[2])
                fight=fight+0.0
                fight_ud.set(fight, forKey: "fightid")
                fight_ud.synchronize()
                fight=fight_ud.object(forKey: "fightid") as! Double
                
                win=win+0.0
                win_ud.set(win, forKey: "winid")
                win_ud.synchronize()
                win=win_ud.object(forKey: "winid") as! Double
                
                app.fight_label=((win/fight)*Double(100))
                
                
                fight_label_ud.set(app.fight_label, forKey: "fight_labelid")
                fight_label_ud.synchronize()
                app.fight_label=fight_label_ud.object(forKey: "fight_labelid") as! Double
                
                // ① UIAlertControllerクラスのインスタンスを生成
                let alerttitle = NSLocalizedString("引き分け・・・・", comment: "")
                let alertmessage = NSLocalizedString("惜しかったです。", comment: "")
                let alert3: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
                
                // ② Actionの設定
                let canceltitle = NSLocalizedString("OK", comment: "")
                let cancelAction: UIAlertAction = UIAlertAction(title: canceltitle, style:.default,handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action:UIAlertAction!) -> Void in
                    
                    self.app.result = 2
                    
                    //third画面遷移
                    let storyboard: UIStoryboard = self.storyboard!
                    let nextView = storyboard.instantiateViewController(withIdentifier: "third") as! thirdViewController
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
            if(cpu_hit != 3){
                //cpuの設定した数字表示
                Right1Label.text=String(cpu[0])
                Right2Label.text=String(cpu[1])
                Right3Label.text=String(cpu[2])
                fight=fight+1.0
                fight_ud.set(fight, forKey: "fightid")
                fight_ud.synchronize()
                fight=fight_ud.object(forKey: "fightid") as! Double
                
                win=win+1.0
                win_ud.set(win, forKey: "winid")
                win_ud.synchronize()
                win=win_ud.object(forKey: "winid") as! Double
                //値受け渡し
                app.fight_label=((win/fight)*Double(100))
                
                
                fight_label_ud.set(app.fight_label, forKey: "fight_labelid")
                fight_label_ud.synchronize()
                app.fight_label=fight_label_ud.object(forKey: "fight_labelid") as! Double
                
                
                // ① UIAlertControllerクラスのインスタンスを生成
                let alerttitle = NSLocalizedString("勝利!!!!!!!!", comment: "")
                let alertmessage = NSLocalizedString("CPUはあなたの数を当てられませんでした", comment: "")
                let alert4: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
                
                // ② Actionの設定
                let canceltitle = NSLocalizedString("OK", comment: "")
                let cancelAction: UIAlertAction = UIAlertAction(title: canceltitle, style:.default,handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action:UIAlertAction!) -> Void in
                    
                    self.app.result = 3
                    
                    //third画面遷移
                    let storyboard: UIStoryboard = self.storyboard!
                    let nextView = storyboard.instantiateViewController(withIdentifier: "third") as! thirdViewController
                    nextView.minenumber=String(self.mine[0])+String(self.mine[1])+String(self.mine[2])
                    nextView.cpunumber=String(self.cpu[0])+String(self.cpu[1])+String(self.cpu[2])
                    self.present(nextView, animated: true, completion: nil)
                    
                })
                
                // ③ UIAlertControllerにActionを追加
                alert4.addAction(cancelAction)
                
                // ④ Alertを表示
                var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                    baseview=baseview.presentedViewController!
                }
                baseview.present(alert4, animated: true, completion: nil)
                
                
            }
        }else{
            if(cpu_hit == 3){
                //cpuの設定した数字表示
                Right1Label.text=String(cpu[0])
                Right2Label.text=String(cpu[1])
                Right3Label.text=String(cpu[2])
                fight=fight+1.0
                fight_ud.set(fight, forKey: "fightid")
                fight_ud.synchronize()
                fight=fight_ud.object(forKey: "fightid") as! Double
                
                //値受け渡し
                app.fight_label=((win/fight)*Double(100))
                
                fight_label_ud.set(app.fight_label, forKey: "fight_labelid")
                fight_label_ud.synchronize()
                app.fight_label=fight_label_ud.object(forKey: "fight_labelid") as! Double
                
                // ① UIAlertControllerクラスのインスタンスを生成
                let alerttitle = NSLocalizedString("負け。。。", comment: "")
                let alertmessage = NSLocalizedString("CPUはあなたの数字を当てました", comment: "")
                let alert2: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
                
                // ② Actionの設定
                // OKボタン
                let canceltitle = NSLocalizedString("OK", comment: "")
                let cancelAction: UIAlertAction = UIAlertAction(title: canceltitle, style:.default,handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action:UIAlertAction!) -> Void in
                    
                    self.app.result = 1
                    
                    //third画面遷移
                    let storyboard: UIStoryboard = self.storyboard!
                    let nextView = storyboard.instantiateViewController(withIdentifier: "third") as! thirdViewController
                    nextView.minenumber=String(self.mine[0])+String(self.mine[1])+String(self.mine[2])
                    nextView.cpunumber=String(self.cpu[0])+String(self.cpu[1])+String(self.cpu[2])
                    self.present(nextView, animated: true, completion: nil)
                    
                })
                
                // ③ UIAlertControllerにActionを追加
                alert2.addAction(cancelAction)
                
                // ④ Alertを表示
                var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                    baseview=baseview.presentedViewController!
                }
                baseview.present(alert2, animated: true, completion: nil)
                
            }
        }
    }
    
    
    @IBAction func OKTouch(_ sender: UIButton) {
        
        if(t==0){
            
            // ① UIAlertControllerクラスのインスタンスを生成
            // タイトル, メッセージ, Alertのスタイルを指定する
            // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
            let alerttitle = NSLocalizedString("スタート", comment: "")
            let alertmessage = NSLocalizedString("相手の数字を予想してください!", comment: "")
            let alert: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:.alert)
            
            // ② Actionの設定
            // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
            // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
            // OKボタン
            let canceltitle = NSLocalizedString("OK", comment: "")
            let cancelAction: UIAlertAction = UIAlertAction(title: canceltitle
, style:.default,handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action:UIAlertAction!) -> Void in
                
                
                self.i=0
                //比較回数更新
                self.t+=1
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
            baseview.present(alert, animated: true, completion: nil)
        }else{
            if(mine_hit != 3){
                //mine_match開始
                mine_math(forecast:forecast_mine,math:cpu,&mine_hit,&mine_blow)
                // ① UIAlertControllerクラスのインスタンスを生成
                let yosou = NSLocalizedString("自分の予想", comment: "")
                let alert5: UIAlertController = UIAlertController(title: yosou+"  "+String(forecast_mine[0])+String(forecast_mine[1])+String(forecast_mine[2]), message:String(mine_hit)+" "+"HIT"+" "+String(mine_blow)+" "+"BLOW", preferredStyle:.alert)
                // ② Actionの設定
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action:UIAlertAction!) -> Void in
                    //cpu_mutch開始
                    self.mine_math(forecast:self.forecast_cpu,math:self.mine,&self.cpu_hit,&self.cpu_blow)
                    // ① UIAlertControllerクラスのインスタンスを生成
                    let yosou = NSLocalizedString("CPUの予想", comment: "")
                    
                    let alert1: UIAlertController = UIAlertController(title: yosou+"  "+String(self.forecast_cpu[0])+String(self.forecast_cpu[1])+String(self.forecast_cpu[2]), message:String(self.cpu_hit)+" "+"HIT"+" "+String(self.cpu_blow)+" "+"BLOW", preferredStyle:.alert)
                    // ② Actionの設定
                    let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style:.default,handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action:UIAlertAction!) -> Void in
                        
                        self.judge2()
                    })
                    // ③ UIAlertControllerにActionを追加
                    alert1.addAction(cancelAction)
                    // ④ Alertを表示
                    var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                    while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                        baseview=baseview.presentedViewController!
                    }
                    baseview.present(alert1, animated: true, completion: nil)
                    self.make_cpu_cells()
                    self.forecastcpu()
                })
                // ③ UIAlertControllerにActionを追加
                alert5.addAction(cancelAction)
                // ④ Alertを表示
                var baseview:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                while(baseview.presentedViewController != nil && !baseview.presentedViewController!.isBeingDismissed){
                    baseview=baseview.presentedViewController!
                }
                baseview.present(alert5, animated: true, completion: nil)
                make_mine_cells()
                
            }
            let messages = NSLocalizedString("ヒントを参考に予想してください！", comment: "")
            self.turn_name.text=messages
            
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
            delTouch.isEnabled = true
            okTouch.isEnabled=false
            
            
            i=0
            //比較回数更新
            t+=1
        }
        if(mine_hit != 3){
            mine_hit=0
            mine_blow=0
        }
        if(cpu_hit != 3){
            cpu_hit=0
            cpu_blow=0
        }
    }
    
    
    
    //左のラベル
    @IBOutlet weak var Left1Label: UILabel!
    @IBOutlet weak var Left2Label: UILabel!
    @IBOutlet weak var Left3Label: UILabel!
    
    //右のラベル
    @IBOutlet weak var Right1Label: UILabel!
    @IBOutlet weak var Right2Label: UILabel!
    @IBOutlet weak var Right3Label: UILabel!
    //自分の予想ラベル
    @IBOutlet weak var forecast_label1: UILabel!
    @IBOutlet weak var forecast_label2: UILabel!
    @IBOutlet weak var forecast_label3: UILabel!
    
    
    @IBOutlet weak var turn_name: UILabel!
    
    
}
