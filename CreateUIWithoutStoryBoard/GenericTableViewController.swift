//
//  GenericTableViewController.swift
//  CreateUIWithoutStoryBoard
//
//  Created by tautau on 2019/3/21.
//  Copyright © 2019年 tautau. All rights reserved.
//

import UIKit
import RealmSwift

protocol RealmList {
    associatedtype modelType:Object
    var realm:Realm{get set}
    var realmList:Results<modelType>{get set}
    func delete(object:Object)->()
    func add(object:Object)->()
}

class GenericTableViewController<T:Object,Cell:UITableViewCell>: UITableViewController,RealmList{
    
    var realm = try! Realm()
    var realmList: Results<T>
    var cellSetting:(T,Cell)->Void
    var clickCellAction:(T)->Void
    var realmListChangeNotification:NotificationToken?
    
    var incomeLabel:UILabel = {
        let label = UILabel(frame: .zero, text:"income:",fontSize:20)
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    var costLabel:UILabel = {
        let label = UILabel(frame: .zero, text:"cost:",fontSize:20)
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    var balanceLabel:UILabel = {
        let label = UILabel(frame: .zero, text:"total:",fontSize:20)
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    lazy var tableHeaderView:UIView = {
        let stackView = UIStackView(views: [incomeLabel,costLabel,balanceLabel], axis: .horizontal, spacing: 10, distribution: .fillProportionally)
        let view = UIView(frame:.zero)
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setTableHeaderView(headerView:tableHeaderView)
    }
    
    init(items:Results<T>,cellSetting:@escaping(T,Cell)->Void,clickCellAction:@escaping(T)->Void){
        realmList = items
        self.cellSetting = cellSetting
        self.clickCellAction = clickCellAction
        super.init(style: .plain)
        self.tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
        self.caculateAccount(tableItemType: T.self.className())
        realmListChangeNotification = realmList.observe({ (changes) in
            self.updateUI(changes: changes)
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let item = realmList[indexPath.row]
        cellSetting(item,cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "delete") { action, index in
            self.delete(object:self.realmList[index.row])
        }
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = realmList[indexPath.row]
        clickCellAction(item)
    }
}

extension GenericTableViewController{
    func updateUI(changes:RealmCollectionChange<Results<T>>){
        switch changes{
        case .initial(_):
            break
        case let .update(_,deletion,insertions,modifications):
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },with: .automatic)
            self.tableView.deleteRows(at: deletion.map { IndexPath(row: $0, section: 0) }, with: .automatic)
            self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) },with: .automatic)
            self.tableView.endUpdates()
            self.caculateAccount(tableItemType: T.self.className())
        case .error(let error):
            print(error)
        }
    }
    func caculateAccount(tableItemType:String){
        var totalCost = 0,totalIncome = 0
        
        switch tableItemType {
        case "DateInfo":
            guard  let monthInfo = realmList as? Results<DateInfo> else {return}
            for i in 0..<monthInfo.count{
                totalCost += monthInfo[i].dailyCost
                totalIncome += monthInfo[i].dailyIncome
            }
        default:
            guard let itemsInfo = realmList.first as? Item else {return}
            totalCost = (itemsInfo.parentDailySpend.first?.dailyCost)!
            totalIncome = (itemsInfo.parentDailySpend.first?.dailyIncome)!
        }
        
        incomeLabel.text? = "income:\(totalIncome)"
        costLabel.text? = "cost:\(totalCost)"
        balanceLabel.text? = "total:\(totalIncome - totalCost)"
    }
    
}

extension UITableView {
    func setTableHeaderView(headerView: UIView) {
        self.tableHeaderView = headerView
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1/4).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerView.layoutIfNeeded()
    }
}

extension RealmList {
    func delete(object:Object)->(){
        do{
            try realm.write {
                realm.delete(object)
            }
        }catch{
            print("delete date failed,\(error)")
        }
    }
    func add(object:Object)->(){
        do{
            try self.realm.write {
                realm.add(object)
            }
        }catch{
            print("Add date error,\(error)")
        }
    }
}

