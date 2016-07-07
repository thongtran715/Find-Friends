//
//  AddViewController.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/6/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var topicTextField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBAction func datePickerTapped(sender: AnyObject) {
        DatePickerDialog().show("Schedule the Meeting", doneButtonTitle: "Save", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            (date) -> Void in
            self.dateLabel.text = "\(date.convertToString())"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize.height = 1000
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn (textField: UITextField)->Bool
    {
        topicTextField.resignFirstResponder()
        return true
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
