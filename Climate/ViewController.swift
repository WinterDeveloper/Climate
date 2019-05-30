//
//  ViewController.swift
//  Climate
//
//  Created by Siyu Zhang on 5/29/19.
//  Copyright © 2019 Siyu Zhang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, WeatherProtocol {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    let locationManager = CLLocationManager()
    let weatherData = WeatherDataModel()

    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    

    @IBAction func switchPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "goToSecondScreen", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //declare view controller as the delegate of the second view controller
        if segue.identifier == "goToSecondScreen" {
            
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.secondDelegate = self
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(parameters : params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Cannot obtain location!!!"
    }
    
    func getWeatherData(parameters : [String : String]) {
        
        Alamofire.request(WEATHER_URL, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                
                
                print(weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateWeatherData(json: JSON) {
        
        weatherData.temperature = Int(json["main"]["temp"].doubleValue - 273.15)
        weatherData.city = json["name"].stringValue
        weatherData.condition = json["weather"][0]["id"].intValue
        weatherData.weatherIconName = weatherData.updateWeatherIcon(condition: weatherData.condition)
        
        tempLabel.text = String(weatherData.temperature) + "°"
        cityLabel.text = weatherData.city
        imageView.image = UIImage(named: weatherData.weatherIconName)
        
    }
    
    func userEnterACityName(cityName : String) {
        
        print(cityName)
        
        let paramDict = ["q" : cityName,
                        "appid" : APP_ID]
        
        getWeatherData(parameters: paramDict)
        
    }
}

