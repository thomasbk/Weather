//
//  DetailViewController.swift
//  Weather
//
//  Created by Thomas Baltodano on 11/2/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    typealias JSONStandard = Dictionary<String, AnyObject>
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var medTempLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var atmTempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!

    func configureView() {
        
        // Update the user interface for the detail item.
        if let detail = detailItem {
            
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
            
            self.title = detailItem!["name"] as? String
            
            if let main = detailItem!["main"] as? JSONStandard {
            
                minTempLabel.text = "\(String(describing: main["temp_min"]!))º"
                medTempLabel.text = "\(Int(round(main["temp"]! as! Double)))º"
                maxTempLabel.text = "\(String(describing: main["temp_max"]!))º"
                atmTempLabel.text = "\(String(describing: main["pressure"]!))"
                humidityLabel.text = "\(String(describing: main["humidity"]!))%"
                
                currentTempLabel.text = "\(Int(round(main["temp"]! as! Double)))º"
            }
            
            let wind = detailItem!["wind"] as? JSONStandard
            windLabel.text = "\(wind!["speed"]!)"
            
            let weather = detailItem!["weather"] as? [JSONStandard]
            let firstWeather = weather![0]
            detailDescriptionLabel.text = firstWeather["description"] as? String
            weatherImageView.image = UIImage(named: mainImage)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
            
        configureView()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var mainImage: String = ""
    var detailItem: JSONStandard? {
        didSet {
            // Update the view.
            //configureView()
        }
    }
    

}

