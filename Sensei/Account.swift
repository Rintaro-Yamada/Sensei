//
//  Account.swift
//  Sensei
//
//  Created by 山田倫太郎 on 2021/06/01.
//

import Foundation
import RealmSwift

class Account: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var date = Date()
    @objc dynamic var start = Date()
    @objc dynamic var finish = Date()
    @objc dynamic var tool: String = ""
    @objc dynamic var money: String = "未納入"
}
