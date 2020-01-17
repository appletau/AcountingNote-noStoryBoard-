//
//  Spend.swift
//  Accounting note
//
//  Created by tautau on 2018/8/21.
//  Copyright © 2018年 tautau. All rights reserved.
//

import Foundation
import RealmSwift



class Item:Object{
    @objc dynamic var incomeOrCost:Int = 0
    @objc dynamic var category:String = ""
    @objc dynamic var amount:String = ""
    @objc dynamic var note:String = ""
    @objc dynamic var image:Data = Data()
    let parentDailySpend = LinkingObjects(fromType: DateInfo.self, property: "items")
}
