//
//  ViewController2.swift
//  HouseKeeping
//
//  Created by Apple-1 on 09/01/18.
//  Copyright © 2018 Apple-1. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController2: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tblView: UITableView!
    
    var test:[String] = []
    var test2:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        test.removeAll()
        test2.removeAll()
        getListJSON()
        // Do any additional setup after loading the view.
    }
    

func getListJSON(){
    autoreleasepool {
        let ApiUrl = "http://temp1.pickzy.com/interview_pickzy/interview.json"
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
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                print("StatusCode is === \(httpStatus.statusCode)")
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
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]  // main thing as! [String:AnyObject]
                    /*let jsonArray = JSON(jsonObj)
                    let Arrays = jsonArray["Item"]["Content"].array
                    for key in Arrays! {
                        let testd = key["Name"].stringValue
                        let testd2 = key["URL"].stringValue
                        print(testd , testd2)
                        self.test.append(testd)
                        self.test2.append(testd2)
                    }
                    self.tblView.reloadData()*/
                    
                    let Arrays = jsonObj["Item"]?["Content"] as! [Dictionary <String,AnyObject>]
                    for key in Arrays {
                        let testd = key["Name"] as! String
                        let testd2 = key["URL"] as! String
                        print(testd , testd2)
                        self.test.append(testd)
                        self.test2.append(testd2)
                    }
                    self.tblView.reloadData()

                } catch {
                    // Catch any other errors
                }
            }
        }
    }
    return nil
}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celll", for: indexPath) as! TableViewCell2
        cell.lbl?.text = ""
        cell.lbl.text = self.test[indexPath.row]
        
        let data = self.test2[indexPath.row]
        
        //print("text 2 ", data)
        
        cell.img?.image = nil
        
        let url = URL(string: data)
        if let datass = try? Data(contentsOf: url!)
        {
            let imagess: UIImage = UIImage(data: datass)!
            cell.img.image = imagess
        }
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
