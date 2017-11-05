//
//  MasterViewController.swift
//  Weather
//
//  Created by Thomas Baltodano on 11/2/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit

import Alamofire

import CoreLocation

class MasterViewController: UITableViewController,CLLocationManagerDelegate {

    @IBOutlet var dateLabel: UILabel!
    
    var detailViewController: DetailViewController? = nil
    
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
        
        self.dateLabel.text = ""
        
        getCities()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    //    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
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
        
    }
    
    @objc func getCities () {
        //First get current location, then get cities list.
        
        if (NetworkReachabilityManager()!.isReachable) {
        
            // Ask for Authorization from the User.
            self.locationManager.requestAlwaysAuthorization()
        
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
        
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        }
        else { // Cant connect to internet
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            appDelegate.showNoConnection()
            
            refresher.endRefreshing()
        }
    }
    

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                tableView.deselectRow(at: indexPath, animated: true)
                
                let dict = cities.cityList[indexPath.row] as? JSONStandard
                let weather = dict!["weather"] as? [JSONStandard]
                let firstWeather = weather![0]
                
                let mainWeather = firstWeather["main"] as! String
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.mainImage = getImage(condition: mainWeather)
                controller.detailItem = dict
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    
    // MARK: - User Location
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = manager.location!.coordinate
        
        print("locations = \(userLocation.latitude) \(userLocation.longitude)")
        
        
        locationManager.stopUpdatingLocation()
        
        print("Started downloading")
        cities.downloadData(latitude: userLocation.latitude,longitude:userLocation.longitude) {
            self.updateUI()
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            dateFormatter.dateStyle = .medium
            
            let timeString = "Last update: \(dateFormatter.string(from: Date() as Date))"
            
            self.dateLabel.text = String(timeString)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        let alert = UIAlertController(title: "Alert", message: "Please enable location services for this app to obtain current weather data.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: nil))
        
        if presentedViewController == nil {
            self.present(alert, animated: true, completion: updateUI)
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
            //cell.temperatureLabel!.text = main!["temp"]?.stringValue
            cell.temperatureLabel!.text = "Temp: \(Int(round(main!["temp"]! as! Double)))º"
            
            let weather = dict["weather"] as? [JSONStandard]
            let firstWeather = weather![0]
            
            let mainWeather = firstWeather["main"] as! String
            
            cell.myImageView!.image = UIImage(named: getImage(condition: mainWeather))!
        }
        
        return cell
    }
    
    
    func getImage(condition: String) -> String {
        
        var imageToShow: String
        switch condition {
        case "Rain":
            imageToShow = "rainy"
        case "Thunderstorm":
            imageToShow = "rainy"
        case "Drizzle":
            imageToShow = "sun-rainy"
        case "Snow":
            imageToShow = "rainy"
        case "Atmosphere":
            imageToShow = "windy"
        case "Clear":
            imageToShow = "sunny"
        case "Clouds":
            imageToShow = "sun-cloudy"
        case "Extreme":
            imageToShow = "windy-rainy"
        case "Additional":
            imageToShow = "windy-rainy"
        default:
            imageToShow = "sun-cloudy"
        }
        return imageToShow
        
    }




}

