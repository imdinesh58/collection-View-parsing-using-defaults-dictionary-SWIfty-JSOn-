//
//  ViewController3.swift
//  HouseKeeping
//
//  Created by Apple-1 on 10/01/18.
//  Copyright © 2018 Apple-1. All rights reserved.
//

import UIKit

class ViewController3: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var test:[String] = []
    var test2:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test.removeAll()
        test2.removeAll()
        // Do any additional setup after loading the view.
        getListJSON()
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
                        self.collectionView.reloadData()
                        
                    } catch {
                        // Catch any other errors
                    }
                }
            }
        }
        return nil
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return test.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colle", for: indexPath) as! CollectionViewCell2
        cell.lbl?.text = ""
        cell.img?.image = nil
        cell.lbl?.text = test[indexPath.item]
        let data = self.test2[indexPath.row]
        let url = URL(string: data)
        if let datass = try? Data(contentsOf: url!)
        {
            let imagess: UIImage = UIImage(data: datass)!
            cell.img?.image = imagess
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
