//
//  ViewController.swift
//  WeatherApp_Chand
//
//  Created by Chand on 26/04/23.
//

import UIKit
import CoreLocation
class ViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var searchButonUI: UIButton!
    @IBOutlet weak var weatherIconIamge: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var windyLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var search: UITextField!
    var weatherDetails : WeatherModel?
    var weatherTime : String =  ""
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        let city = UserDefaults.standard.value(forKey: "city") as? String
        if city != "" && city != nil
        {
            GeoCode(city: city!)
        }
        else
        {
            currentLocation()
        }
        
        updateUI()
    }


    //MARK: - Get Current Location
    func currentLocation()
    {
        if (CLLocationManager.locationServicesEnabled())
                {
                    locationManager = CLLocationManager()
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.requestAlwaysAuthorization()
                    locationManager.startUpdatingLocation()
                }
    }
    //MARK: - location delegate methods
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       let userLocation :CLLocation = locations[0] as CLLocation

       print("user latitude = \(userLocation.coordinate.latitude)")
       print("user longitude = \(userLocation.coordinate.longitude)")


       let geocoder = CLGeocoder()
       geocoder.reverseGeocodeLocation(userLocation) { [self] (placemarks, error) in
           if (error != nil){
               print("error in reverseGeocode")
           }
           let placemark = placemarks! as [CLPlacemark]
           if placemark.count>0{
               let placemark = placemarks![0]
               print(placemark.locality!)
               print(placemark.administrativeArea!)
               print(placemark.country!)

              let city =  convertEnglishCharacter(txt: "\(placemark.locality!)")
               self.GeoCode(city: city)
           }
       }

   }
    //MARK: - Alerts

    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        if let topController = UIApplication.shared.windows[0].rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - UI UPDate

    func updateUI()
    {
        //Seach textfield UI
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: search.frame.height - 1, width: search.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        search.borderStyle = UITextField.BorderStyle.none
        search.layer.addSublayer(bottomLine)
        search.attributedPlaceholder = NSAttributedString(
            string: "City Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
        )
    }
    //MARK: - Tapped Search Button
    @IBAction func searcPressed(_ sender: Any){
        
        var city = ""
        
        if search.text == ""
        {
            self.showAlert(title: "", msg: "Please enter city name")
            search.text = ""
            return
            
        }else
        {
            if let searching =  search.text
            {
                city =  convertEnglishCharacter(txt: searching)
            }
            GeoCode(city: city)
        }
        
        search.endEditing(true)
    }
    //MARK: - Convert english character for url
    func convertEnglishCharacter(txt : String) -> String
    {
        //Convert english character for url
        //Example: city = zürich -> zurich
        //city name = New York City -> new%20york
        let nonSpace = txt.replacingOccurrences(of: " ", with: "%20")
        let justEnglishString = nonSpace.folding(options: .diacriticInsensitive, locale: nil)
        
        return justEnglishString.lowercased()
        
    }
    
    //MARK: - Weather Details Api Calling
    func getWeatherList(city:String){
        let parameters:[String:Any] = [:]
        APICallingViewModel.getWeatherReports(api: "data/2.5/weather?q=\(city)&APPID=58afad3e954e97622f89ba59f06e6e98", parameters: parameters) { [self] (responce) in
            print("response",responce as Any)
            if responce != nil{
                DispatchQueue.main.async { [self] in
                    weatherDetails = responce
                    sendToDataView(weatherInfo: weatherDetails!)
                }
            
                
            }
            
        }
    }
    //MARK: - Geo Code Api Calling
    func GeoCode(city:String){
        let parameters:[String:Any] = [:]
        APICallingViewModel.getGeoCodeApi(api: "geo/1.0/direct?q=\(city)&APPID=58afad3e954e97622f89ba59f06e6e98", parameters: parameters) { [self] (responce) in
            print("response",responce as Any)
            if responce != nil{
                DispatchQueue.main.async { [self] in
                    if responce!.count > 0
                    {
                        let country = responce?[0].country
                        if country == "US"
                        {
                            
                            getWeatherList(city: convertEnglishCharacter(txt: city))
                        }
                        else
                        {
                            self.showAlert(title: "", msg: "Please enter city name with in US Country")

                        }
                    }
                    
                }
                
            }
            
        }
    }
    //MARK: - Weather Details UI Updation

    func sendToDataView(weatherInfo : WeatherModel) {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        DispatchQueue.main.async {
            
            let timezone = "\(weatherInfo.timezone ?? 0)"
            dateFormatter.timeZone = TimeZone(identifier: timezone)
            dateFormatter.dateFormat = "MMM d, EEE, hh:mm a"
            dateFormatter.locale = Locale(identifier: "en")
            self.weatherTime = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "HH"
            let stringHour = dateFormatter.string(from: date)
            let hour = Int(stringHour)!
            
            switch hour {
            case 5...18:
                self.backgroundImage.image = UIImage(named:"Daytime")
            case 18...24:
                self.backgroundImage.image = UIImage(named: "NightDay")
            default:
                self.backgroundImage.image = UIImage(named:"NightDay")
            }
            
            self.cityNameLabel.text = weatherInfo.name ?? ""
            if let CityName =  weatherInfo.name
            {
                UserDefaults.standard.set(CityName, forKey: "city")
            }
        self.weatherTempLabel.text = "\(weatherInfo.main?.temp ?? 0)°"
        self.weatherDesc.text = weatherInfo.weather?[0].description ?? ""
            self.sunsetLabel.text = "\(weatherInfo.sys?.sunrise ?? 0)"
        self.windyLabel.text = String(format: "%0.2f", weatherInfo.wind?.speed ?? 0) + "m/s"
            self.cloudLabel.text = "\(weatherInfo.clouds?.all ?? 0) %"
            self.dateLabel.text = self.weatherTime
            self.weatherIconIamge.image = UIImage(systemName: (weatherInfo.weather?[0].getIcon()) ?? "")
            
        }
    }

    
}
extension ViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search.endEditing(true)
        print(search.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if search.text != ""
        {
            return true
        }
        else
        {
            search.placeholder = "Enter the city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        search.text = ""
    }
    
}
