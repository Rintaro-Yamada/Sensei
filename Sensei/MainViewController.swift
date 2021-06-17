//
//  MainViewController.swift
//  Sensei
//
//  Created by 山田倫太郎 on 2021/06/09.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nextName: UILabel!
    @IBOutlet var nextDate: UILabel!
    @IBOutlet var nextTime: UILabel!
    @IBOutlet var nextTool: UILabel!
    
    let realm = try! Realm()
    let date = Date()
    let calendar = Calendar.current
    var notificationToken: NotificationToken?
    var row:Int = 0
    var accounts = [Account]()
    var nextaccounts = Account()
    lazy var start_day = calendar.startOfDay(for: date)
    lazy var end_day = Calendar.current.date(byAdding: .day, value: 1, to: start_day)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        //accounts = try! Realm().objects(Account.self).filter()
        
        
//        notificationToken = accounts.observe{[weak self] _ in
//            self?.tableView.reloadData()}
    }
    func dateFormat(date: Date) -> String {
         let f = DateFormatter()
         f.dateStyle = .long
         f.timeStyle = .none
         return f.string(from: date)
    }
    func timeFormat(date: Date) -> String {
         let f = DateFormatter()
         f.dateStyle = .none
         f.timeStyle = .short
         return f.string(from: date)
    }
    func changeFormat(str:String) -> String {
        let dateFormatter = DateFormatter()

        // step 1
        dateFormatter.dateFormat = "HH:mm" // input format
        let date = dateFormatter.date(from: str)!

        // step 2
        dateFormatter.dateFormat = "hh:mm a" // output format
        let string = dateFormatter.string(from: date)
        return string
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        accounts = Array(try! Realm().objects(Account.self)).filter{ $0.date >= start_day && $0.date <= end_day }.sorted(by: {timeFormat(date: $0.start) < timeFormat(date: $1.start)})
        //let components = Calendar.current.dateComponents(in: TimeZone.current, from: nextdate.date)
        
        //let days = DateComponents(calendar: Calendar.current, year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute).date
        if accounts.isEmpty {}
        else{
            nextaccounts = Array(try! Realm().objects(Account.self)).filter{dateFormat(date: $0.date) >= dateFormat(date: Date()) && timeFormat(date: $0.start) >= timeFormat(date: Date()) }.sorted(by: {timeFormat(date: $0.start) < timeFormat(date: $1.start)}).first!
            let df = DateFormatter()
            
            df.dateFormat = "MM月　dd日"
            
            nextName.text = nextaccounts.name
            nextDate.text = df.string(from: nextaccounts.date)
            
            df.dateFormat = "HH:mm"
            nextTime.text = "\(df.string(from : nextaccounts.start)) 〜 \(df.string(from : nextaccounts.finish))"
            nextTool.text = nextaccounts.tool
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let accounts = accounts.filter("date >= %@ AND date <= %@", start_day, end_day)
        //print(acc.count)
        print(accounts.count)
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let accounts = accounts.filter("date >= %@ AND date <= %@", start_day, end_day)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! MainTableViewCell
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        //if df.string(from: accounts[indexPath.row].date) == df.string(from: Date()){
            df.dateFormat = "HH:mm"
            cell.nameLabel.text = accounts[indexPath.row].name
            cell.time.text = df.string(from: accounts[indexPath.row].start) + " 〜 " + df.string(from: accounts[indexPath.row].finish)
        //}
        
        return cell
    }
    
    // テーブルビューの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! MainTableViewCell
        row = indexPath.row
        print("\(indexPath.row)番目の行が選択されました。")
        
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }

}

