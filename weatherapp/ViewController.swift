//
//  ViewController.swift
//  weatherapp
//
//  Created by Geeksoft llc on 2/3/17.
//  Copyright © 2017 Geeksoft llc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var mysearch: UISearchBar!

    @IBOutlet weak var mycity: UILabel!
   
    @IBOutlet weak var mytemp: UILabel!
    
    @IBOutlet weak var condition: UILabel!
    
    @IBOutlet weak var humidity: UILabel!
   
    @IBOutlet weak var feel: UILabel!
    
    @IBOutlet weak var wind: UILabel!
  
    
    
   
    
    @IBOutlet weak var imageview: UIImageView!
    
    var degree: Int!
    var city: String!
    var citycondition: String!
    var myhumidity: Int!
    var myfeel: Double!
    var myWind: Double!
    var imgurl: String!
    
    
    
    var exists: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mysearch.delegate = self
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
       
let myurl = URLRequest(url: URL(string: "http://api.apixu.com/v1/current.json?key=ba32ad971eda4660a1a224024170302&q=\(mysearch.text!.replacingOccurrences(of: " ", with: "%20"))")!)
        
        print(myurl)
     
       
        let task = URLSession.shared.dataTask(with: myurl) { (data, response, error) in
            
            if error != nil{
                print("error")
            }else {
                if let content = data{
                    do{
                        
            
                    let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                    
                        if let cur = json["location"] as? [String:AnyObject]{
                            if let name = cur["name"] as? String{
                                self.city = name
                                
                                
                                
                            }
                            
                            
                                }
                        if let cur1 = json["current"] as? [String: AnyObject]{
                            if let temp = cur1["temp_c"] as? Int{
                                self.degree = temp
                                
                                let hum = cur1["humidity"] as? Int
                                self.myhumidity = hum
                                
                                let win = cur1["wind_mph"] as? Double
                                self.myWind = win
                                
                                let feeling = cur1["feelslike_c"] as? Double
                                self.myfeel = feeling
                            
                            }
                            if let con = cur1["condition"] as? [String: AnyObject]{
                                self.citycondition = con["text"] as? String
                                let icon = con["icon"] as! String
                                self.imgurl = "http:\(icon)"
                                
                            }
                            
                        
                        }
                        
                        
                        if let _ = json["error"]{
                            self.exists = false
                        }
                        
                        DispatchQueue.main.async {
                            if self.exists{
                               
                                self.mytemp.isHidden = false
                                self.condition.isHidden = false
                                self.feel.isHidden = false
                                self.wind.isHidden = false
                                self.humidity.isHidden = false
                                self.mycity.text = self.city
                                self.mytemp.text = "\(self.degree.description)°"
                                self.condition.text = self.citycondition
                                self.imageview.downloadimage(from: self.imgurl)
                                self.humidity.text = self.myhumidity.description
                                
                                self.feel.text = "\(self.myfeel.description)c"
                                self.wind.text = "\(self.myWind.description)mph"
                                
                                                            }
                            else{
                                self.mytemp.isHidden = true
                                self.condition.isHidden = true
                                self.feel.isHidden = true
                                self.wind.isHidden = true
                                self.humidity.isHidden = true
                                
                                self.mycity.text = "city not found"

                                self.exists = true
                            }
                        }
                        
                }
                
                catch{
                    
                }
            }
        }
        
        
    }
    
      task.resume()
}

}

extension UIImageView {
    func downloadimage(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil{
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
        task.resume()
    }
}




