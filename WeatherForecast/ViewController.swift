

import UIKit

class ViewController: UIViewController ,UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var degree: Int!
    var condition : String!
    var imgURL: String!
    var cityname : String!
    var exists : Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let urlRequest  = URLRequest(url : URL(string : "https://api.apixu.com/v1/current.json?key=ac6d37f15df547ff9d992227172104&q=\(searchBar.text!.replacingOccurrences(of: "", with: "%20"))" )!)
        
        let task  = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    if let current = json["current"] as? [String : AnyObject]{
                        if let temp = current["temp_c"] as? Int{
                        self.degree = temp
                        }
                        if let condition = current["condition"] as? [String: AnyObject]{
                           self.condition = condition["text"] as! String
                           let icon = condition["icon"] as! String
                           self.imgURL = "https:\(icon)"
                        }
                    }
                
                    if let location = json["location"] as? [String: AnyObject]{
                        self.cityname = location["name"] as! String
                    }
                    
                    
                    if let error = json["error"] {
                      self.exists = false
                    }
                    
                    DispatchQueue.main.async{
                        if self.exists{
                        self.degreeLbl.isHidden = false
                        self.conditionLbl.isHidden = false
                        self.imageView.isHidden = false
                        self.degreeLbl.text = "\(self.degree.description)°"
                        self.conditionLbl.text = self.condition
                        self.cityLbl.text = self.cityname
                        self.imageView.downloadImage(from:self.imgURL!)
                        } else{
                        self.degreeLbl.isHidden = true
                        self.conditionLbl.isHidden = true
                        self.imageView.isHidden = true
                        self.cityLbl.text = "No matching location found."
                        self.exists = true
                        }
                    }
                } catch let JsonError{
                
                    print(JsonError.localizedDescription)
                }
              }
            
        }
        task.resume()
    }
}

extension UIImageView{

    func downloadImage(from url: String){
    
        let urlRequest = URLRequest(url : URL(string : url)!)
        let task  = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        
            if error == nil {
                DispatchQueue.main.async{
                    self.image = UIImage(data :data!)
                
                }
                
            }
        
        
        }
       task.resume()
    }
    
}













