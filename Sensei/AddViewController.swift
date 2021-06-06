//
//  AddViewController.swift
//  Sensei
//
//  Created by 山田倫太郎 on 2021/06/01.
//
import UIKit
import Eureka
import RealmSwift
class AddViewController: FormViewController {
    var accountname: String = ""
    var accountphone: String = ""
    var accountdate = Date()
    var accountstart = Date()
    var accountfinish = Date()
    var accounttool: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ここよくわからん！！！
        let formatter = DateFormatter()
        let now = ""
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        let date = formatter.date(from: now)
        
        form +++ Section("生徒情報")
            <<< TextRow(){ row in
                row.title = "名前"
                row.placeholder = "山田 太郎"
            }.onChange() { row in
                // 選択された時刻を表示
                self.accountname = row.value != nil ? row.value! : ""
            }
            <<< PhoneRow(){
                $0.title = "電話番号"
                $0.placeholder = "XXX-XXXX-XXXX"
            }.onChange() { row in
                // 選択された時刻を表示
                
                self.accountphone = row.value != nil ? row.value! : ""
                
            }
            
            +++ Section("レッスン日情報")
            <<< DateRow(){
                $0.title = "レッスン日"
                $0.value = date
            }.onChange() { row in
                // 選択された時刻を表示
                print(row.value!)
                self.accountdate = row.value!
            }
            <<< TimeRow("開始") {
                $0.title = "開始"
            }.onChange() { row in
                // 選択された時刻を表示
                print(row.value!)
                self.accountstart = row.value!
            }
            <<< TimeRow("終了") {
                $0.title = "終了"
            }.onChange() { row in
                // 選択された時刻を表示
                print(row.value!)
                self.accountfinish = row.value!
            }
            +++ Section("オンラインレッスン時のツール")
            <<< SegmentedRow<String>() {
                $0.selectorTitle = "Tool"
                $0.options = ["LINE","ZOOM","Facetime","Google duo"]
                $0.value = "LINE"    // initially selected
            }.onChange() { row in
                // 選択された時刻を表示
                self.accounttool = row.value!
            }
    }
    let realm = try! Realm()
    @IBAction func addAccount() {
        let newAccount = Account()
        newAccount.name = accountname
        newAccount.phone = accountphone
        newAccount.date = accountdate
        newAccount.start = accountstart
        newAccount.finish = accountfinish
        newAccount.tool = accounttool
        if accounttool == "ZOOM"{
            newAccount.money = "納入済み"
        }
        
        try! realm.write {
            realm.add(newAccount)
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
