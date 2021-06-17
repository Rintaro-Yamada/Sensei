//
//  MoneyViewController.swift
//  Sensei
//
//  Created by 山田倫太郎 on 2021/06/02.
//

import UIKit
import RealmSwift

class MoneyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    
    let realm = try! Realm()
    let accounts = try! Realm().objects(Account.self)
    //let nextaccounts = try! Realm().objects(Address.self).filter("age < 20").sorted(byKeyPath: "kana")
    var notificationToken: NotificationToken?
    var row:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        notificationToken = accounts.observe{[weak self] _ in
            self?.tableView.reloadData()}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! MoneyTableViewCell
        cell.nameLabel.text = accounts[indexPath.row].name
        cell.moneyLabel.text = accounts[indexPath.row].money
        if cell.moneyLabel.text == "納入済み"{
            cell.moneyLabel.textColor = UIColor.blue
        }
        else{
            cell.moneyLabel.textColor = UIColor.red
        }
        return cell
    }
    
    // テーブルビューの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! MoneyTableViewCell
        row = indexPath.row
        print("\(indexPath.row)番目の行が選択されました。")
        if accounts[row].money == "納入済み"{
            try! realm.write{
                accounts[row].money = "未納入"
            }
            cell.moneyLabel.textColor = UIColor.red
        }
        else{
            try! realm.write{
                accounts[row].money = "納入済み"
            }
            cell.moneyLabel.textColor = UIColor.blue
        }
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }
}

