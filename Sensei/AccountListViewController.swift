//
//  AccountListViewController.swift
//  Sensei
//
//  Created by 山田倫太郎 on 2021/06/02.
//

import UIKit
import RealmSwift

class AccountListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let realm = try! Realm()
    let accounts = try! Realm().objects(Account.self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AccountListTableViewCell
        cell.nameLabel.text = accounts[indexPath.row].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目の行が選択されました。")
        row = indexPath.row
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 別の画面に遷移
        performSegue(withIdentifier: "toNextViewController", sender: nil)
    }
    
    // 画面遷移する際に呼ばれるコード
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextViewController" {
            let nextVC = segue.destination as! EditViewController
            // 値を渡す
            nextVC.ROW = row
        }
    }
}

