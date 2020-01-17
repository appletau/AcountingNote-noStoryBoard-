//
//  ViewControllerTwo.swift
//  CreateUIWithoutStoryBoard
//
//  Created by tautau on 2019/3/1.
//  Copyright © 2019年 tautau. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewItemViewController: UIViewController,RealmList{
    
    var realmList:Results<DateInfo>
    var realm = try! Realm()
    var item:Item?
 
    init(item:Item?){
        self.item = item
        realmList = realm.objects(DateInfo.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var segmentControl:UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Cost","Income"])
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()

    
    lazy var formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM,dd"
        return formatter
    }()
    
    lazy var datePicker:UIDatePicker = {
       let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        return datePicker
    }()
    
    lazy var datePickerToolBar:UIToolbar = {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target:self, action: #selector(datePickerCancel))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target:self, action: #selector(datePickerDone))
        let toolBar = UIToolbar(barBtns: [cancelButton,spaceButton,doneButton])
        return toolBar
    }()
    
    lazy var dateTextField:UITextField = {
        let textField = UITextField(frame: .zero, borderColor: UIColor.black.cgColor, borderWidth: 1)
        textField.isUserInteractionEnabled = true
        textField.inputView = datePicker
        textField.inputAccessoryView = datePickerToolBar
        textField.text = formatter.string(from:Date())
        return textField
    }()
    
    lazy var categoryTextField:UITextField = {
        let textField = UITextField(frame: .zero, borderColor: UIColor.black.cgColor, borderWidth: 1)
        return textField
    }()
    
    lazy var amountTextField:UITextField = {
        let textField = UITextField(frame: .zero, borderColor: UIColor.black.cgColor, borderWidth: 1)
        return textField
    }()
    
    lazy var categoryLabel:UILabel = {
        let label = UILabel(frame: .zero, text:"category",fontSize:16)
        return label
    }()
    
    lazy var amountLabel:UILabel = {
        let label = UILabel(frame: .zero, text:"amount",fontSize:16)
        return label
    }()
    
    lazy var saveBarBtn:UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
        return button
    }()
    
    lazy var textView:UITextView = {
        let textView = UITextView(frame: .zero)
        textView.text = "hello,hello,hello,hello"
        textView.textAlignment = .center
        textView.keyboardDismissMode = .interactive
        textView.textColor = .red
        textView.layer.borderColor = UIColor.blue.cgColor
        textView.layer.borderWidth = 1
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        return textView
    }()
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "take-photo-icon")
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var subStackView:UIStackView = {
        let categoryStackView = UIStackView(views:[categoryLabel,categoryTextField] , axis: .horizontal, spacing: 10, distribution: .fill)
        let amountStackView = UIStackView(views:[amountLabel,amountTextField] , axis: .horizontal, spacing: 10, distribution: .fill)
        let stackView = UIStackView(views: [categoryStackView,amountStackView], axis: .vertical, spacing: 40, distribution: .fillEqually)
        NSLayoutConstraint.activate([categoryLabel.widthAnchor.constraint(equalTo: categoryStackView.widthAnchor, multiplier: 1/3),])
        amountLabel.widthAnchor.constraint(equalTo: amountStackView.widthAnchor, multiplier: 1/3).isActive = true
        return stackView
    }()
    lazy  var mainStackView:UIStackView = {
        let stackView = UIStackView(views: [imageView,subStackView], axis: .horizontal, spacing: 10, distribution: .fill)
        imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1/3).isActive = true
        return stackView
    }()
    
    lazy  var mainStackViewTwo:UIStackView = {
        let stackView = UIStackView(views: [segmentControl,dateTextField], axis: .vertical, spacing: 10, distribution: .fillEqually)
        return stackView
    }()
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(textView)
        self.view.addSubview(mainStackView)
        self.view.addSubview(mainStackViewTwo)
        self.edgesForExtendedLayout = .bottom
        NSLayoutConstraint.activate([
            mainStackViewTwo.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2),
            mainStackViewTwo.heightAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 1/4),
            mainStackViewTwo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainStackViewTwo.bottomAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -50),
            mainStackViewTwo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height/8),
            mainStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            mainStackView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            mainStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -20),
            textView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3),
            textView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = saveBarBtn
        self.view.backgroundColor = .white
        categoryTextField.text = item?.category
        amountTextField.text = item?.amount
        textView.text = item?.note
        if let date = item?.parentDailySpend.first{
            dateTextField.text = "\(date.month),\(date.day)"
            segmentControl.selectedSegmentIndex = item!.incomeOrCost
        }
    }
}

extension AddNewItemViewController:UITextViewDelegate{
    func append(item:Item,toDate date:DateInfo){
        switch item.incomeOrCost {
        case 0:
            date.dailyCost += Int(item.amount)!
        default:
            date.dailyIncome += Int(item.amount)!
        }
        date.items.append(item)
    }
    
    func remove(item:Item,fromDate date:DateInfo){
        switch item.incomeOrCost {
        case 0:
            date.dailyCost -= Int(item.amount)!
        default:
            date.dailyIncome -= Int(item.amount)!
        }
        realm.delete(item)
    }
    
    @objc func datePickerCancel(sender:UIBarButtonItem!) {
        self.view.endEditing(true)
    }
    
    @objc func datePickerDone(sender:UIBarButtonItem!){
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func saveAction(sender:UIButton!){
        guard let imageData = imageView.image!.jpegData(compressionQuality: 0.5) else{fatalError("converted to JPEG failed")}
        let dateArray = dateTextField.text?.components(separatedBy: ",")
        let dateList = realmList.filter("month CONTAINS[cd] %@",dateArray![0]).filter("day CONTAINS[cd] %@",dateArray![1])
        let newItem = Item(value:[segmentControl.selectedSegmentIndex,
                                  categoryTextField.text!,
                                  amountTextField.text!,
                                  textView.text!,
                                  imageData] as [Any])
        
        if dateList.isEmpty{
            let newMonthlyInfo = DateInfo(value: [dateArray![0],dateArray![1]])
            self.add(object: newMonthlyInfo)
        }
        
        if let oldItem = item{
            realmModify{remove(item:oldItem, fromDate:oldItem.parentDailySpend.first!)}
        }
        realmModify{append(item: newItem, toDate: dateList.first!)}
        self.navigationController?.popViewController(animated: true)
    }
}

extension UITextField{
    convenience init(frame:CGRect,borderColor:CGColor,borderWidth:CGFloat){
        self.init(frame: frame)
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UILabel{
    convenience init(frame:CGRect,text:String,fontSize:CGFloat){
        self.init(frame:frame)
        self.text = text
        self.font = UIFont.preferredFont(forTextStyle: .footnote)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIToolbar {
    convenience init(barBtns:[UIBarButtonItem]){
        self.init()
        self.barStyle = UIBarStyle.default
        self.isTranslucent = true
        self.tintColor = UIColor.blue
        self.sizeToFit()
        self.setItems(barBtns, animated: false)
        self.isUserInteractionEnabled = true
    }
}

extension RealmList where Self:AddNewItemViewController{
    func realmModify(action:()->()){
        do{
            try self.realm.write {
                action()
            }
        }catch{
            print("modify item error,\(error)")
        }
    }
}
