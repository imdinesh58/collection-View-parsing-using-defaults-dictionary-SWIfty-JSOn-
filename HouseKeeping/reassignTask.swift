//
//  reassignTask.swift
//  HouseKeeping
//
//  Created by Apple-1 on 21/11/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class reassignTask: UIViewController, UITableViewDelegate, UITableViewDataSource  {
        var TASKNAMEID : String = ""
        var ASSIGNED_BY__ : String = ""
        
        @IBOutlet weak var tblreassignTask: UITableView!
        
        var nameArr: [String] = []
        var IDArr: [String] = []
        var UserMobileIDArr: [String] = []
        let data = UserDefaults.standard.object(forKey: "DefaultJSON")
    
        var AdminMobId: String = ""
        override func viewDidLoad() {
            super.viewDidLoad()
            print("Distribute reassignTask window load")
            nameArr.removeAll()
            IDArr.removeAll()
            UserMobileIDArr.removeAll()
            let jsonArray = JSON(data!)
            if ASSIGNED_BY__ == "2" {
                print("Assigned BY ", ASSIGNED_BY__)
                for (_, dict) in jsonArray["JsonWorkers"] {
                    let employeeDetailsArray = dict["employeeDetails"]
                    for (_, dict) in employeeDetailsArray.reversed() {
                        self.nameArr.append(dict["FirstName"].stringValue + dict["LastName"].stringValue)
                        self.IDArr.append(dict["EmployeeID"].stringValue)
                        self.UserMobileIDArr.append(dict["UserMobileID"].stringValue)
                    }
                    self.tblreassignTask?.reloadData()
                }
            } else  if ASSIGNED_BY__ == "1" {
                print("Assigned BY ", ASSIGNED_BY__)
                for (_, dict) in jsonArray["JsonWorkers"] {
                    AdminMobId = dict["UserMobileID"].stringValue
                    print("Admin ", dict["UserMobileID"].stringValue)
                    let employeeDetailsArray = dict["employeeDetails"]
                    for (_, dict) in employeeDetailsArray.reversed() {
                        self.nameArr.append(dict["FirstName"].stringValue + dict["LastName"].stringValue)
                        self.IDArr.append(dict["EmployeeID"].stringValue)
                        self.UserMobileIDArr.append(dict["UserMobileID"].stringValue)
                        print("Employee ", dict["UserMobileID"].stringValue)
                    }
                    print("Admin & employee ", UserMobileIDArr)
                    self.tblreassignTask?.reloadData()
                }
            }
        }
        
        @IBAction func EXIT() {
            self.dismiss(animated: true, completion: nil)
        }
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return IDArr.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "distributeCell", for: indexPath) as! Distribute
            cell.Name?.text = ""
            cell.ID?.text = ""
            cell.UserMobileIDArray?.text = ""
            cell.Name?.text = self.nameArr[indexPath.row]
            cell.ID?.text = self.IDArr[indexPath.row]
            cell.UserMobileIDArray?.text = self.UserMobileIDArr[indexPath.row]
            return cell;
        }
        
        var ArrayStringName : [String] = []
        var ArrayStringID : [String] = []
        var ArrayStringMobileID : [String] = []
        
        var selected = false
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let Cell = tableView.cellForRow(at: indexPath)! as! Distribute
            
            ArrayStringName.append((Cell.Name?.text)!)
            ArrayStringID.append((Cell.ID?.text)!)
            ArrayStringMobileID.append((Cell.UserMobileIDArray?.text)!)
            
            print("CHECk " , ArrayStringMobileID)
            
            Cell.ImageSSS.image = nil
            let check : UIImage = UIImage(named: "check.png")!
            Cell.ImageSSS.image = check
            selected = true
        }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            let Cell = tableView.cellForRow(at: indexPath)! as! Distribute
            
            ArrayStringName.removeLast()
            ArrayStringID.removeLast()
            ArrayStringMobileID.removeLast()
            
            print("Un CHECk " , ArrayStringName)
            
            Cell.ImageSSS.image = nil
            let check : UIImage = UIImage(named: "uncheck.png")!
            Cell.ImageSSS.image = check
            selected = false
        }
        
        @IBAction func DONE() {
            print("clicked Done")
            CompleteCheck()
        }
    
        var dateSigned: String?
        func CompleteCheck() {
            let stringConverter = ArrayStringID.joined(separator: ",")
            let stringConverter2 = ArrayStringName.joined(separator: ",")
            if selected == false {
                let alert = UIAlertController(title: "Alert", message: "Choose Employee !!!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                ///DATE
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                dateSigned = formatter.string(from: date)
                print("dateSigned  " ,dateSigned!)
                let URI = "http://54.68.128.183:8080/HouseKeeping/putvalue/updatetaskdistributionstatus/"
                let URI2 =  URI + TASKNAMEID
                let URI3 = URI2 + "/" + stringConverter
                let URI4 = URI3 + "/" + stringConverter2
                let URI5 = URI4 + "/"
                let URI6 = URI5 + "\(dateSigned!)"
                //print("URI6= " , URI6 )
                
                let escapedAddress = URI6.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                
                 //print("escapedAddress= " , escapedAddress! )
                
                Alamofire.request("\(escapedAddress!)", method: .put, parameters: [:], encoding: URLEncoding.default, headers: [:]).responseJSON {
                    response in
                    switch response.result {
                    case .success(let value):
                        print(" API Success ")
                        print(value)
                        self.NotifyUser()
                        self.switchToLoginScreen()
                        break
                    case .failure(let error):
                        print("PUT API Failure")
                        print(error)
                        break
                    }
                }
            }
        }
        
        let defaultss = UserDefaults.standard
        func NotifyUser() {
            //let stringConverter3 = ArrayStringMobileID.joined(separator: ",")
            
            //print("ArrayStringMobileID Before =  ", ArrayStringMobileID.count)
            if ASSIGNED_BY__ == "1" {
                ArrayStringMobileID.append(AdminMobId)
            }
            
            print("ArrayStringMobileID After = ", ArrayStringMobileID.count)
            
            let namee = self.defaultss.string(forKey: "name")
            let test = "Admin " + namee! + " distributed assigned task"
            let params = [
                "results" : [],
                "notification": [
                    "body": test,
                    "title": "New Distributed Task",
                    "icon" : "appicon",
                    "sound" : "default"
                ],
                "registration_ids" : ArrayStringMobileID
                ] as [String : Any]
            
            print("params  = ",params)
            
            Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    let jsonArray = JSON(value)
                    //print("jsonArray " , value)
                    let status = jsonArray["success"]
                    if status == 0 {
                        print("Notification FAILURE ")
                    } else {
                        print("Notification SUCCESS ")
                    }
                    break
                case .failure(let error):
                    print("Notification API Failure" , error)
                    break
                }
            }
        }
        
        func switchToLoginScreen() {
            self.resetObjects2()
            OperationQueue.main.addOperation {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashBoard") as UIViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        func resetObjects2() {
            objects.removeAll()
            objects2.removeAll()
            objects3.removeAll()
            objects4.removeAll()
            objects5.removeAll()
            objectsrole1.removeAll()
            objectsrole2.removeAll()
            objectsrole3.removeAll()
            objectsrole4.removeAll()
            objectsrole5.removeAll()
            objectsrole6.removeAll()
            objectsrole7.removeAll()
            objects6.removeAll()
            objects8.removeAll()
            objects77.removeAll()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
}
