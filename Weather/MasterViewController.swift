//
//  MasterViewController.swift
//  Weather
//
//  Created by Thomas Baltodano on 11/2/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit

//import MapKit
import CoreLocation

class MasterViewController: UITableViewController,CLLocationManagerDelegate {

    var detailViewController: DetailViewController? = nil
    //var objects = [Any]()
    
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    
    let locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D!
    
    var cities = Cities()
    
    var refresher: UIRefreshControl!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refresher = UIRefreshControl()
        self.tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(getCities), for: .valueChanged)
        
        getCities()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateUI() {
        
        print("finished downloading")
        self.tableView.reloadData()
        refresher.endRefreshing()
        //dateLabel.text = weather.date
        //tempLabel.text = "\(weather.temp)"
        //weatherImage.image = UIImage(named: weather.weather)
        
    }
    
    @objc func getCities () {
        //First get current location, then get cities list.
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let object = cities.cityList[indexPath.row]
                //let object = objects[indexPath.row] as! NSDate
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                //controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    
    // MARK: - User Location
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        userLocation = manager.location!.coordinate
        
        print("locations = \(userLocation.latitude) \(userLocation.longitude)")
        
        
        locationManager.stopUpdatingLocation()
        
        print("Started downloading")
        cities.downloadData(latitude: userLocation.latitude,longitude:userLocation.longitude) {
            self.updateUI()
        }
        
    }
    
    
    

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.cityList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! listTableViewCell
        
        if let dict = cities.cityList[indexPath.row] as? JSONStandard {
            
            cell.nameLabel!.text = dict["name"] as? String
            
            let main = dict["main"] as? JSONStandard
            cell.temperatureLabel!.text = main!["temp"]?.stringValue
            
            //cell.myImageView!.image = UIImage(named: "afternoon")!
        }
            
        
        return cell
    }




}

