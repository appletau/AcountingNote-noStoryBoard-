//
//  ViewController.swift
//  CreateUIWithoutStoryBoard
//
//  Created by tautau on 2019/3/1.
//  Copyright © 2019年 tautau. All rights reserved.
//

import UIKit
import RealmSwift

class HomePageViewController: UIViewController {
    
    let realm = try! Realm()
    var dateList:Results<DateInfo>?
    var itemList:Results<Item>?
    
    var selectedMonth:String?{didSet{
        dateList = realm.objects(DateInfo.self).filter("month CONTAINS[cd] %@",selectedMonth!)}}
    var selectedDate :DateInfo?{didSet{
        itemList = selectedDate?.items.sorted(byKeyPath: "category", ascending: true)}}
    
    lazy var rightBarBtn:UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        return button
    }()
    
    lazy var monthButtons:UIStackView = {
        let row1 = createStackView(witnButtonTitles:["Jan","Feb","Mar"])
        let row2 = createStackView(witnButtonTitles:["Apr","May","Jun"])
        let row3 = createStackView(witnButtonTitles:["Jul","Aug","Sep"])
        let row4 = createStackView(witnButtonTitles:["Oct","Nov","Dec"])
        let stackView = UIStackView(views: [row1,row2,row3,row4], axis: .vertical, spacing: 10, distribution: .fillEqually)
        return stackView
    }()
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(monthButtons)
        
        NSLayoutConstraint.activate([monthButtons.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3),
                                     monthButtons.heightAnchor.constraint(equalTo: monthButtons.widthAnchor, multiplier: 1),
                                     monthButtons.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     monthButtons.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "hello"
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
    }
}

extension HomePageViewController{
    
    func createStackView(witnButtonTitles titles:[String])->UIStackView
    {
        var buttons=Array<UIButton>()
        for title in titles{
            let button = UIButton(title: title)
            button.addTarget(self, action: #selector(dateButtonPressed) , for: .touchUpInside)
            buttons.append(button)
        }
        let stackView = UIStackView(views: buttons, axis: .horizontal, spacing: 20, distribution: .fillEqually)
        return stackView
    }
    
    @objc func addButtonPressed(sender:UIButton!){
        let viewController = AddNewItemViewController(item:nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func dateButtonPressed(sender:UIButton!){
        selectedMonth = sender.titleLabel?.text
        let dateCellSetting:(DateInfo,UITableViewCell)->Void = {$1.textLabel?.text = $0.day}
        let itemCellSetting:(Item,UITableViewCell)->Void = {$1.textLabel?.text = $0.category}
        
        let dateTableVC = GenericTableViewController(items: dateList!,cellSetting:dateCellSetting){
            self.selectedDate = $0
            let itemTableVC = GenericTableViewController(items:self.itemList!,cellSetting:itemCellSetting){
                let viewController = AddNewItemViewController(item: $0)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
            self.navigationController?.pushViewController(itemTableVC, animated: true)
        }
        
        self.navigationController?.pushViewController(dateTableVC, animated: true)
    }
}

extension UIButton {
    convenience init(title:String){
        self.init(frame: .zero)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIStackView{
    convenience init(views:[UIView],axis:NSLayoutConstraint.Axis,spacing:CGFloat,distribution:UIStackView.Distribution){
        self.init(arrangedSubviews: views)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = .fill
    }
}



