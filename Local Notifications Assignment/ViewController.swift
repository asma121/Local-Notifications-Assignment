//
//  ViewController.swift
//  Local Notifications Assignment
//
//  Created by admin on 19/12/2021.
//

import UIKit

class ViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {

   
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSetLabel: UILabel!
    @IBOutlet weak var workUntilLabel: UILabel!
    
    @IBOutlet weak var timeHistoryLabel: UILabel!
    let times = [ "5","10", "20", "30"]
    var minutes = 0.0
    var pickerTitle = ""
    var timeHistory = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timePicker.delegate = self
        timePicker.dataSource = self
    }

    @IBAction func startTimerButtonPressed(_ sender: UIButton) {
        minutes = Double(times[timePicker.selectedRow(inComponent: 0)])! * 60
        pickerTitle = times[timePicker.selectedRow(inComponent: 0)]
        showLocalNotvication(minutes: minutes)
        totalTimeLabel.text = "Total Time : \(pickerTitle)"
        timeLabel.text = "0 hours , \(pickerTitle) min "
        timeSetLabel.text = "\(pickerTitle) minutes timer set"
        
        let t = Date(timeIntervalSinceNow: minutes).formatted()
        workUntilLabel.text = "Work Until : \(t)"
        
        let cTime = Date().formatted()
        let arr = [cTime , t]
        timeHistory.append(arr)
       // print(timeHistory)
    }
    
    @IBAction func newDayButtonPressed(_ sender: UIButton) {
        totalTimeLabel.text = "Total Time : 0 "
        timeLabel.text = ""
        timeSetLabel.text = ""
        workUntilLabel.text = ""
        timeHistoryLabel.text = ""
        timeHistory.removeAll()
    }
    
    @IBAction func detailsButtonPressed(_ sender: Any) {
        var text = ""
        
        for i in 0...timeHistory.count-1 {
            text += " \(timeHistory[i][0]) - \(timeHistory[i][1]) \n "
        }
        
        timeHistoryLabel.text = text
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        showAlret()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return times[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        NSAttributedString(string: times[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
    }
    
    func showLocalNotvication(minutes : Double){
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Time Fineshed", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: " Set NEW Timer ", arguments: nil)
        content.sound = UNNotificationSound.default
        
        let currentDate = Date(timeIntervalSinceNow: minutes)
        let dateComponent = Calendar.current.dateComponents([.year , .month , .day , .hour , .minute , .second ], from: currentDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent , repeats: false)
        let request = UNNotificationRequest(identifier: "CountDown Timer", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.add(request) { (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func showAlret(){
        minutes = 0.0
        let alertVc = UIAlertController.init(title: nil, message: "cancel current timer ? ", preferredStyle: .alert)
        alertVc.addAction(UIAlertAction.init(title: "back", style: .cancel, handler: nil))
        alertVc.addAction(UIAlertAction.init(title: "cancel", style: .default, handler:{ [self] action in
            self.showLocalNotvication(minutes: self.minutes)
            timeSetLabel.text = "\(self.pickerTitle) Minutes Timer Cancelled "
        }))
        self.present(alertVc, animated: true, completion: nil)
    }
    
}

extension ViewController : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //showAlret()
        completionHandler(UNNotificationPresentationOptions.sound)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("")
    }
    
}

