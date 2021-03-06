
import UIKit
import Alamofire
import SwiftyJSON
import Foundation

/*var objects: [getAssignedTasks] = []
var objects2: [getWorkers] = []
var objects3: [getEmployeeDetailsHousekeeping] = []
var objects4: [getEmployeeDetailsCarParking] = []
var objects5: [getEmployeeDetailsMaintenance] = []
var objectsrole1: [getEmployeeDetailsPlumber] = []
var objectsrole2: [getEmployeeDetailsCarpenter] = []
var objectsrole3: [getEmployeeDetailsElectrician] = []
var objectsrole4: [getEmployeeDetailsDriver] = []
var objectsrole5: [getEmployeeDetailsCleaner] = []
var objectsrole6: [getEmployeeDetailsWasher] = []
var objectsrole7: [getEmployeeDetailsArranger] = []
var objects6: [getFloorDetails] = []
var objects77: [getWorkTypeDetails] = [] */

class tblAssignTasksAll: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
	@IBOutlet weak var tblAssignTasks: UITableView!
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("View controller ALL loaded")
		self.tblAssignTasks?.delegate = self
		self.tblAssignTasks?.dataSource = self
		//if objects.isEmpty == true || objects2.isEmpty == true || objects3.isEmpty == true || objects4.isEmpty == true || objects5.isEmpty == true || objects6.isEmpty == true || objects77.isEmpty == true {
		objects.removeAll()
		objects2.removeAll()
		objects3.removeAll()
		objects4.removeAll()
		objects5.removeAll()
		objects6.removeAll()
		objects77.removeAll()
		objectsrole1.removeAll()
		objectsrole2.removeAll()
		objectsrole3.removeAll()
		objectsrole6.removeAll()
		objectsrole4.removeAll()
		objectsrole5.removeAll()
		objectsrole7.removeAll()
		//print("if objects.isEmpty == at viewdidload  All ", objects.isEmpty)
		getListJSON()
		GETFloorDetails()
		//} else {
		//	getAssignTasks_All()
		//}
		if #available(iOS 10.0, *) {
			let refreshControl = UIRefreshControl()
			let title = NSLocalizedString("Refreshing", comment: "")
			refreshControl.attributedTitle = NSAttributedString(string: title)
			refreshControl.addTarget(self,
			                         action: #selector(refreshAOptionsw(sender:)),
			                         for: .valueChanged)
			self.tblAssignTasks.refreshControl = refreshControl
		}
	}
	
	@objc private func refreshAOptionsw(sender: UIRefreshControl) {
		objects.removeAll()
		objects2.removeAll()
		objects3.removeAll()
		objects4.removeAll()
		objects5.removeAll()
		objects6.removeAll()
		objects77.removeAll()
		objectsrole1.removeAll()
		objectsrole2.removeAll()
		objectsrole3.removeAll()
		objectsrole6.removeAll()
		objectsrole4.removeAll()
		objectsrole5.removeAll()
		objectsrole7.removeAll()
		//if objects.isEmpty == true {
			//SwiftSpinner.show("Retrieving data from server please wait")
			let branchID = defaults.string(forKey: "branchID")
			let employeeStatusID = defaults.string(forKey: "employeeStatusID")
			let employeeIDLogin = defaults.string(forKey: "employeeIDLogin")
			let ApiUrl = HKURL + "/getjson/assignedtask&workers/" + employeeIDLogin! + "/" + employeeStatusID! + "/" + branchID!
			//let APiUrl = "http://www.mobile.chembiantech.com:8080/HouseKeeping/getjson/assignedtask&workers/81/1/1"
			let req = NSMutableURLRequest(url: NSURL(string: ApiUrl)! as URL)
			req.httpMethod = "GET"
			let task = URLSession.shared.dataTask(with: req as URLRequest) {
				data, response, error in
				// Check for error
				if error != nil {
					print("error=\(error)")
					//SwiftSpinner.hide()
					return
				}
				if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
					print("StatusCode is === \(httpStatus.statusCode)")
					OperationQueue.main.addOperation{
						let alert = UIAlertController(title: "Alert", message: "Server Error... failed to load assigned tasks", preferredStyle: UIAlertControllerStyle.alert)
						alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
						self.present(alert, animated: true, completion: nil)
					}
					//SwiftSpinner.hide()
				}
				
				if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
					let responseString = String(data: data!, encoding: String.Encoding.utf8)
					//print("API call done with ResponseString = \(responseString)")
					print("StatusCode is === \(httpStatus.statusCode)")
					//print("ResponseString = success status " +     responseString!)
					_ = self.convertStringToDictionary(text: responseString!)
					sender.endRefreshing()
				}
				
			}  //close task
			task.resume()
			GETFloorDetails()
		//}
	}
	
	func resetObjects() {
		objects.removeAll()
		objects2.removeAll()
		objects3.removeAll()
		objects4.removeAll()
		objects5.removeAll()
		objects6.removeAll()
		objects77.removeAll()
		objectsrole1.removeAll()
		objectsrole2.removeAll()
		objectsrole3.removeAll()
		objectsrole6.removeAll()
		objectsrole4.removeAll()
		objectsrole5.removeAll()
		objectsrole7.removeAll()
	}

	func getListJSON(){
		objects.removeAll()
		objects2.removeAll()
		objects3.removeAll()
		objects4.removeAll()
		objects5.removeAll()
		objects6.removeAll()
		objects77.removeAll()
		objectsrole1.removeAll()
		objectsrole2.removeAll()
		objectsrole3.removeAll()
		objectsrole6.removeAll()
		objectsrole4.removeAll()
		objectsrole5.removeAll()
		objectsrole7.removeAll()
		 autoreleasepool {
		//SwiftSpinner.show("Retrieving data from server please wait")
		let branchID = defaults.string(forKey: "branchID")
		let employeeStatusID = defaults.string(forKey: "employeeStatusID")
		let employeeIDLogin = defaults.string(forKey: "employeeIDLogin")
		let ApiUrl = HKURL + "/getjson/assignedtask&workers/" + employeeIDLogin! + "/" + employeeStatusID! + "/" + branchID!
		print("branchID  " + branchID! +  "  employeeIDLogin  " + employeeIDLogin!)
		print(" employeeStatusID " + employeeStatusID!)
		let req = NSMutableURLRequest(url: NSURL(string: ApiUrl)! as URL)
		req.httpMethod = "GET"
		let task = URLSession.shared.dataTask(with: req as URLRequest) {
			data, response, error in
			// Check for error
			if error != nil {
				print("error=\(error)")
				//SwiftSpinner.hide()
				return
			}
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
				print("StatusCode is === \(httpStatus.statusCode)")
				OperationQueue.main.addOperation{
					let alert = UIAlertController(title: "Alert", message: "Server Error... failed to load assigned tasks", preferredStyle: UIAlertControllerStyle.alert)
					alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
					self.present(alert, animated: true, completion: nil)
				}
				//SwiftSpinner.hide()
			}
			
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
				let responseString = String(data: data!, encoding: String.Encoding.utf8)
				//print("API call done with ResponseString = \(responseString)")
				print("StatusCode is === \(httpStatus.statusCode)")
				//print("ResponseString = success status " +     responseString!)
				_ = self.convertStringToDictionary(text: responseString!)
			}
			
		}  //close task
		task.resume()
		}
	}
	
	func convertStringToDictionary(text: String) -> [String:AnyObject]? {
		DispatchQueue.main.async(){
			autoreleasepool {
				if let data = text.data(using: String.Encoding.utf8) {
					do {
						let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
						let jsonArray = JSON(jsonObj)
						UserDefaults.standard.set(jsonObj, forKey: "DefaultJSON")
						print("%%%%%% Property set All %%%%%")
						//SwiftSpinner.hide()
						
						for (_, dict) in jsonArray["JsonAssignedTasks"] { //(key or index, element)
							let dateString = dict["dateAssigned"].stringValue
							let dateFormatter = DateFormatter()
							dateFormatter.dateFormat = "yyyy-MM-dd HH:mm.ss.SSS"
							let dateObj = dateFormatter.date(from: dateString)
							dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
							
							let thisObject = getAssignedTasks(assignedTaskID: dict["assignedTaskID"].intValue, taskStatusID: dict["taskStatusID"].stringValue, description: dict["description"].stringValue,dateAssigned: dateFormatter.string(from: dateObj!),location: dict["location"].stringValue,assignedBY: dict["assignedBY"].stringValue,employeeId: dict["employeeId"].stringValue,priorities : dict["priorities"].stringValue,floorNumber : dict["floorNumber"].stringValue,employeeName: dict["employeeName"].stringValue,imageCount : dict["imageCount"].stringValue,checkListIds : dict["checkListIds"].stringValue,taskListId : dict["taskListId"].stringValue,assignedByName : dict["assignedByName"].stringValue,assignedByRole : dict["assignedByRole"].stringValue,isDistributsed : dict["isDistributsed"].stringValue,duration : dict["duration"].stringValue)
							objects.append(thisObject)
						}
						for (_, dict2) in jsonArray["JsonWorkers"] { //(key or index, element)
							let thisObj = getWorkers(employeeLevelID: dict2["employeeLevelID"].stringValue,levelName: dict2["levelName"].stringValue)
							objects2.append(thisObj)
							
							let employeeDetailsArray = dict2["employeeDetails"]
							///Housekeeping
							if dict2["levelName"].stringValue == "Housekeeping" {
								for (_, dict3) in employeeDetailsArray {
									let thisObj2 = getEmployeeDetailsHousekeeping(FirstName: dict3["FirstName"].stringValue,LastName: dict3["LastName"].stringValue,UserMobileID: dict3["UserMobileID"].stringValue,EmployeeID: dict3["EmployeeID"].stringValue,completed: dict3["workDetails"][0].stringValue,onprogress: dict3["workDetails"][1].stringValue,pending: dict3["workDetails"][2].stringValue,dnd: dict3["workDetails"][3].stringValue,Phone : dict3["Phone"].stringValue,Email : dict3["Email"].stringValue, Address : dict3["Address"].stringValue)
									objects3.append(thisObj2)
								}
							}
							///Car Parking
							if dict2["levelName"].stringValue == "Car Parking" {
								for (_, dict4) in employeeDetailsArray {
									let thisObject4 = getEmployeeDetailsCarParking(FirstName: dict4["FirstName"].stringValue,LastName: dict4["LastName"].stringValue,UserMobileID: dict4["UserMobileID"].stringValue,EmployeeID: dict4["EmployeeID"].stringValue,completed: dict4["workDetails"][0].stringValue,onprogress: dict4["workDetails"][1].stringValue,pending: dict4["workDetails"][2].stringValue,dnd: dict4["workDetails"][3].stringValue,Phone : dict4["Phone"].stringValue,Email : dict4["Email"].stringValue, Address : dict4["Address"].stringValue)
									objects4.append(thisObject4)
								}
							}
							///Maintanence
							if dict2["levelName"].stringValue == "Maintanence" {
								for (_, dict5) in employeeDetailsArray {
									let thisObj5 = getEmployeeDetailsMaintenance(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
									objects5.append(thisObj5)
								}
							}
							/////\/\/\
							///Maintanence
							if dict2["levelName"].stringValue == "Plumber" {
								for (_, dict5) in employeeDetailsArray {
									let thisObj5 = getEmployeeDetailsPlumber(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
									objectsrole1.append(thisObj5)
								}
							}
							///Maintanence
							if dict2["levelName"].stringValue == "Carpenter" {
								for (_, dict5) in employeeDetailsArray {
									let thisObj5 = getEmployeeDetailsCarpenter(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
									objectsrole2.append(thisObj5)
								}
							}
							///Maintanence
							if dict2["levelName"].stringValue == "Electrician" {
								for (_, dict5) in employeeDetailsArray {
									let thisObj5 = getEmployeeDetailsElectrician(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
									objectsrole3.append(thisObj5)
								}
							}
							///Maintanence
							if dict2["levelName"].stringValue == "Driver" {
								for (_, dict5) in employeeDetailsArray {
									let thisObj5 = getEmployeeDetailsDriver(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
									objectsrole4.append(thisObj5)
								}
							}
							///Maintanence
							if dict2["levelName"].stringValue == "Cleaner" {
								for (_, dict5) in employeeDetailsArray {
									let thisObj5 = getEmployeeDetailsCleaner(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
									objectsrole5.append(thisObj5)
								}
							}
							///Maintanence
							if dict2["levelName"].stringValue == "Washer" {
								for (_, dict5) in employeeDetailsArray {
									let thisObj5 = getEmployeeDetailsWasher(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
									objectsrole6.append(thisObj5)
								}
							}
							///Maintanence
							if dict2["levelName"].stringValue == "Arranger" {
								for (_, dict5) in employeeDetailsArray {
									let thisObj5 = getEmployeeDetailsArranger(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
									objectsrole7.append(thisObj5)
								}
							}
						}
						self.getAssignTasks_All()
						//SwiftSpinner.hide()
					} catch {
						// Catch any other errors
					}
				}
			}
		}
		return nil
	}
	
	func GETFloorDetails() {
		if let branchID = defaults.string(forKey: "branchID") {
			let req = NSMutableURLRequest(url: NSURL(string: HKURL+"/getjson/floordetails/" + branchID)! as URL)
			req.httpMethod = "GET"
			let task = URLSession.shared.dataTask(with: req as URLRequest) {
				data, response, error in
				// Check for error
				if error != nil {
					print("error=\(error)")
					return
				}
				if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
					print("StatusCode is === \(httpStatus.statusCode)")
					OperationQueue.main.addOperation{
						let alert = UIAlertController(title: "Alert", message: "Server Error... failed to load assigned tasks", preferredStyle: UIAlertControllerStyle.alert)
						alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
						self.present(alert, animated: true, completion: nil)
					}
				}
				if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
					let responseString = String(data: data!, encoding: String.Encoding.utf8)
					//print("ResponseString = \(responseString)")
					//print("ResponseString = success status " +     responseString!)
					_ = self.convertStringToDictionary2(text: responseString!)
				}
			}  //close task
			task.resume()
		}
	}
	
	func convertStringToDictionary2(text: String) -> [String:AnyObject]? {
		DispatchQueue.main.async(){
			if let data = text.data(using: String.Encoding.utf8) {
				do {
					let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
					let jsonArray = JSON(jsonObj)
					for (_, dict3) in jsonArray["floorDetails"] {
						let thisObj2 = getFloorDetails(FloorID: dict3["FloorID"].stringValue,FloorName: dict3["FloorName"].stringValue,AreaDetail: dict3["AreaDetail"].stringValue,AreaDetailID: dict3["AreaDetailID"].stringValue,AreaTypeID: dict3["AreaTypeID"].stringValue)
						objects6.append(thisObj2)
					}
					for (_, dict4) in jsonArray["taskListDetails"] {
						let thisObj3 = getWorkTypeDetails(taskListId: dict4["taskListId"].stringValue,taskListName: dict4["taskListName"].stringValue)
						objects77.append(thisObj3)
					}
				} catch {
					// Catch any other errors
				}
			}
		}
		return nil
	}
	
	var locationArr:[String] = []
	var locationArr2:[String] = []
	var descriptionArr:[String] = []
	var dateAssignedArr:[String] = []
	var taskStatusArr:[String] = []
	var EmpArr:[String] = []
	var taskListIdArr:[String] = []
	var priorityArr:[String] = []
	var checkListIdArr:[String] = []
	var AssignedByArr:[String] = []
	var AssignedByRoleIdArr:[String] = []
	var AssignedTaskIdArr:[String] = []
	var isDistributedArr:[String] = []
	
	//TableView
	func getAssignTasks_All() {
		locationArr.removeAll()
		locationArr2.removeAll()
		descriptionArr.removeAll()
		dateAssignedArr.removeAll()
		AssignedTaskIdArr.removeAll()
		taskStatusArr.removeAll()
		checkListIdArr.removeAll()
		taskListIdArr.removeAll()
		AssignedByArr.removeAll()
		isDistributedArr.removeAll()
		AssignedByRoleIdArr.removeAll()
		priorityArr.removeAll()
		EmpArr.removeAll()
		if AssignedTaskIdArr.count == 0 {
			for object in objects.reversed() {
				var status = ""
				if object.taskStatusID == "3" {
					status = "Pending"
					self.taskStatusArr.append(status)
					self.descriptionArr.append(object.description)
					self.dateAssignedArr.append(object.dateAssigned)
					self.locationArr.append(object.location)
					self.locationArr2.append(object.floorNumber)
					self.EmpArr.append(object.employeeName)
					self.taskListIdArr.append(object.taskListId)
					self.checkListIdArr.append(object.checkListIds)
					self.priorityArr.append(object.priorities)
					self.AssignedByArr.append(object.assignedByName)
					self.AssignedTaskIdArr.append(String(object.assignedTaskID))
					self.isDistributedArr.append(object.isDistributsed)
					self.AssignedByRoleIdArr.append(object.assignedByRole)
					self.tblAssignTasks?.reloadData()
				}
			}
		}
		
		print("After All" ,AssignedTaskIdArr.count)
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//let Up = String(taskStatusArr.count)
		//let defaults = UserDefaults.standard
		//defaults.set(Up, forKey: "RefreshLbl")
		//NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshLbl"), object: nil)
		return taskStatusArr.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tblAssignTasks.dequeueReusableCell(withIdentifier: "tasksAll", for: indexPath) as! AllTasksCell
		cell.checkListId?.text = ""
		cell.lbl1?.text = ""
		cell.lbl2?.text = ""
		cell.lbl3?.text = ""
		cell.lbl4?.text = ""
		cell.lbl5?.text = ""
		cell.lbl6?.text = ""
		cell.AssignedByRoleId?.text = ""
		cell.assignedBy?.text = ""
		cell.comments?.text = ""
		cell.taskId?.text = ""
		cell.prio?.text = ""
		cell.AssignedTaskId?.text = ""
		cell.isDistributed?.text = ""
		cell.lbl2?.text = "Assigned To: "  + self.EmpArr[indexPath.row]
		let strArr = self.descriptionArr[indexPath.row].components(separatedBy: "^")
		cell.lbl3?.text = strArr[0]
		cell.comments?.text = strArr[1]
		let loc1 = self.locationArr[indexPath.row]
		let loc2 =  " , " + self.locationArr2[indexPath.row]
		cell.lbl4?.text = loc1 + loc2
		cell.lbl5?.text = self.dateAssignedArr[indexPath.row]
		cell.lbl5?.textColor = UIColor.black
		cell.lbl6?.text = "Priority: " + self.priorityArr[indexPath.row]
		cell.lbl6?.layer.cornerRadius = 1.0
		cell.lbl6?.layer.masksToBounds = true
		cell.lbl6?.layer.borderWidth = 1
		cell.lbl6?.backgroundColor = UIColor.white
		cell.lbl6?.textColor = UIColor(red:246.0/255.0, green: 147/255.0, blue:9/255.0, alpha: 1.0)
		let myColor : UIColor = UIColor(red:246.0/255.0, green: 147/255.0, blue:9/255.0, alpha: 1.0)
		cell.lbl6?.layer.borderColor = myColor.cgColor
		cell.lbl6?.numberOfLines = 0
		
		cell.checkListId?.text = self.taskListIdArr[indexPath.row]
		cell.prio?.text = self.priorityArr[indexPath.row]
		cell.taskId?.text = self.checkListIdArr[indexPath.row]
		
		cell.assignedBy?.text = "Assigned by: " + self.AssignedByArr[indexPath.row]
		cell.AssignedTaskId?.text = self.AssignedTaskIdArr[indexPath.row]
		cell.isDistributed?.text = self.isDistributedArr[indexPath.row]
		cell.AssignedByRoleId?.text = self.AssignedByRoleIdArr[indexPath.row]
		
		return cell;
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let Cell = tableView.cellForRow(at: indexPath)! as! AllTasksCell
		let send = Cell.lbl2?.text
		let send2 = Cell.lbl3?.text
		let send3 = Cell.lbl4?.text
		let send4 = Cell.comments?.text
		let send5 = Cell.checkListId?.text
		let send6 = Cell.prio?.text
		let send7 = Cell.taskId?.text
		let send8 = Cell.AssignedTaskId?.text
		let send9 = Cell.isDistributed?.text
		let send10 = Cell.AssignedByRoleId?.text
		
		self.ViewTaskDescription(pendingText : send! , pendingText2 : send2! , pendingText3 : send3! , pendingText4 : send4! , pendingText5 : send5! , pendingText6 : send6! , pendingText7 : send7!, pendingText8 : send8!, pendingText9 : send9!, pendingText10 : send10!)
	}
	
	var sendPendingStr:String = ""
	var sendPendingStr2:String = ""
	var sendPendingStr3:String = ""
	var sendPendingStr4:String = "none"
	var sendPendingStr5:String = ""
	var sendPendingStr6:String = ""
	var sendPendingStr7:String = ""
	var sendPendingStr8:String = ""
	var sendPendingStr9:String = ""
	var sendPendingStr10:String = ""
	
	func ViewTaskDescription(pendingText: String, pendingText2: String, pendingText3: String, pendingText4: String ,pendingText5: String, pendingText6: String, pendingText7: String,  pendingText8: String, pendingText9: String,pendingText10: String) {
		let assignedByRole : String?
		assignedByRole = defaults.string(forKey: "employeeStatusID")
		if assignedByRole! == "1" {
			OperationQueue.main.addOperation {
				let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
				let vicCont2 = mainStoryboard.instantiateViewController(withIdentifier: "viewTaskView") as! viewTaskViewController
				self.sendPendingStr = pendingText
				self.sendPendingStr2 = pendingText2
				self.sendPendingStr3 = pendingText3
				self.sendPendingStr4 = pendingText4
				self.sendPendingStr5 = pendingText5
				self.sendPendingStr6 = pendingText6
				self.sendPendingStr8 = pendingText8
				
				vicCont2.employee2 = self.sendPendingStr
				vicCont2.task2 = self.sendPendingStr2
				vicCont2.location22 = self.sendPendingStr3
				vicCont2.comments2 = self.sendPendingStr4
				vicCont2.checklist2 = self.sendPendingStr5
				vicCont2.priority2 = self.sendPendingStr6
				self.present(vicCont2, animated: true, completion: nil)
			}
		
		} else{
			OperationQueue.main.addOperation {
				let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
				let vicCont2 = mainStoryboard.instantiateViewController(withIdentifier: "viewAdminTask") as! viewAdminTask
				self.sendPendingStr = pendingText
				self.sendPendingStr2 = pendingText2
				self.sendPendingStr3 = pendingText3
				self.sendPendingStr4 = pendingText4
				self.sendPendingStr5 = pendingText5
				self.sendPendingStr6 = pendingText6
				self.sendPendingStr8 = pendingText8
				self.sendPendingStr9 = pendingText9
				self.sendPendingStr10 = pendingText10
				
				vicCont2.employee2 = self.sendPendingStr
				vicCont2.task2 = self.sendPendingStr2
				vicCont2.location22 = self.sendPendingStr3
				vicCont2.comments2 = self.sendPendingStr4
				vicCont2.checklist2 = self.sendPendingStr5
				vicCont2.priority2 = self.sendPendingStr6
				vicCont2.TASKID = self.sendPendingStr8
				vicCont2.IsDistributed = self.sendPendingStr9
				vicCont2.AssignedBYRoleID = self.sendPendingStr10
				vicCont2.ASSIGNED_BY = assignedByRole!
				self.present(vicCont2, animated: true, completion: nil)
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

