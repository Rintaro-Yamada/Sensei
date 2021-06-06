//
//  EditViewController.swift
//  Sensei
//
//  Created by 山田倫太郎 on 2021/06/02.
//

import UIKit
import RealmSwift
import Eureka

class EditViewController: FormViewController {
    let accounts = try! Realm().objects(Account.self)
    var accountname: String = ""
    var accountphone: String = ""
    var accountdate = Date()
    var accountstart = Date()
    var accountfinish = Date()
    var accounttool: String = ""
    var ROW:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // ここよくわからん！！！
        let formatter = DateFormatter()
        //let now = ""
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        //let date = formatter.date(from: now)
        print(ROW)
        
        form +++ Section("生徒情報")
            <<< TextRow(){ row in
                row.title = "名前"
                row.placeholder = "山田 太郎"
                row.value = accounts[ROW].name
            }.onChange() { row in
                // 選択された時刻を表示
                self.accountname = row.value!
            }
            <<< PhoneRow(){
                $0.title = "電話番号"
                $0.placeholder = "XXX-XXXX-XXXX"
                $0.value = accounts[ROW].phone
            }.onChange() { row in
                // 選択された時刻を表示
                if row.value! != "" {
                    self.accountphone = row.value!
                }
            }
            
            +++ Section("レッスン日情報")
            <<< DateRow(){
                $0.title = "レッスン日"
                $0.value = accounts[ROW].date
            }.onChange() { row in
                // 選択された時刻を表示
                print(row.value!)
                self.accountdate = row.value!
            }
            <<< TimeRow("開始") {
                $0.title = "開始"
                $0.value = accounts[ROW].start
            }.onChange() { row in
                // 選択された時刻を表示
                print(row.value!)
                self.accountstart = row.value!
            }
            <<< TimeRow("終了") {
                $0.title = "終了"
                $0.value = accounts[ROW].finish
            }.onChange() { row in
                // 選択された時刻を表示
                print(row.value!)
                self.accountfinish = row.value!
            }
            +++ Section("オンラインレッスン時のツール")
            <<< SegmentedRow<String>() {
                $0.selectorTitle = "Tool"
                $0.options = ["LINE","ZOOM","Facetime","Google duo"]
                $0.value = accounts[ROW].tool
            }.onChange() { row in
                // 選択された時刻を表示
                self.accounttool = row.value!
            }
    }
}
