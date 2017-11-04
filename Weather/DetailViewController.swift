//
//  DetailViewController.swift
//  Weather
//
//  Created by Thomas Baltodano on 11/2/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
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

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
    /*
    
     {
     clouds =             {
         all = 75;
         };
     coord =             {
         lat = "55.0944";
         lon = "37.03";
         };
     dt = 1509741000;
     id = 529315;
     main =             {
         humidity = 66;
         pressure = 1009;
         temp = "273.15";
         "temp_max" = "273.15";
         "temp_min" = "273.15";
         };
     name = Marinki;
     rain = "<null>";
     snow = "<null>";
     sys =             {
         country = "";
         };
     weather =         (
         {
             description = "light shower snow";
             icon = 13n;
             id = 620;
             main = Snow;
         }
     );
     wind =             {
         deg = 270;
         speed = 3;
     };
     }
    
    
*/

}

