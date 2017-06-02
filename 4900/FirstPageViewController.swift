//
//  FirstPageViewController.swift
//  4900
//
//  Created by leo  luo on 2017-05-19.
//  Copyright © 2017 leo  luo. All rights reserved.
//

import UIKit

var name: String = ""
var groupname: String = ""
var date: String = ""
var reason: String = ""
var story: String = ""
var datevalidation: String = "valid"

class FirstPageViewController: UIViewController, SaveDataProtocol {

    let datePicker = UIDatePicker()
    
    @IBOutlet weak var nametext: UITextField!
    @IBOutlet weak var groupnametext: UITextField!
    @IBOutlet weak var datePickerTxt: UITextField!
    @IBOutlet weak var reasontext: UITextField!
    @IBOutlet weak var storytext: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let bgColor = UIColor(
//            red:0.77,
//            green:0.77,
//            blue:0.76,
//            alpha: 1.0)
//        view.backgroundColor = bgColor
        //self.view.backgroundColor = UIColor(white: 0.9 , alpha: 1)
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "1/2"
        
        
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FirstPageViewController.cancel))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white

//        let rightBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(getter: FirstPageViewController.next))
//        self.navigationItem.rightBarButtonItem = rightBarButton
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        
        createDatePicker()
        storytext.layer.borderColor = UIColor.lightGray.cgColor;
        storytext.layer.borderWidth = 0.5
    }

    func cancel() {
        self.tabBarController?.selectedIndex = 0
    }
    
    
    
    
    //datePicker
    func createDatePicker(){
        
        //format for picker
        datePicker.datePickerMode = .date

        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        datePickerTxt.inputAccessoryView = toolbar
        
        //assigning data picker to text field
        datePickerTxt.inputView = datePicker
        
    }
    
    
    //done function in datapicker toolbar
    func donePressed(){
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        datePickerTxt.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        //date validation
        //get activity date
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            //get current day
            let today = Date()
            let calendar = Calendar.current
            let todaycomponents = calendar.dateComponents([.year, .month, .day], from: today)
            
            let cyear =  todaycomponents.year
            let cmonth = todaycomponents.month
            let cday = todaycomponents.day
            
            if year>cyear! || (year==cyear! && month>cmonth!) || (year==cyear! && month>cmonth! && day>cday!) {
                datevalidation = "invalid"
            }else{
                datevalidation = "valid"
            }
            
        }
        
        
    }
    
    func saveData(){
        name = nametext.text!
        groupname = groupnametext.text!
        date = datePickerTxt.text!
        reason = reasontext.text!
        story = storytext.text!
        //print("...\(name)...\(groupname)...\(date)...\(reason)...\(story)...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
