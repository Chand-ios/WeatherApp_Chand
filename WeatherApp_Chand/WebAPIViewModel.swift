//
//  WebAPIViewModel.swift
//  WeatherApp
//
//  Created by Chand on 26/04/23.
//

import Foundation
import UIKit
import Alamofire
class APICallingViewModel: UIViewController {
    
    static let shared = APICallingViewModel()
    public static func getWeatherReports(api:String,parameters:[String:Any],completion: @escaping(WeatherModel?)->Void)  {
        
        WebAPICalling.shared.ApiRequest(api: api, method: "GET", parameters: parameters) { (data, val, error) in
            guard let data11 = data else { return }
            do{
                let res = try JSONDecoder().decode(WeatherModel?.self, from: data11)
                completion(res)
                // print("cghvdghcdvhcv",res as Any)
            }catch{
                completion(nil)
                print("Error on parsing")
            }
        }
    }
    public static func getGeoCodeApi(api:String,parameters:[String:Any],completion: @escaping([GeoCodeModel]?)->Void)  {
        
        WebAPICalling.shared.ApiRequest(api: api, method: "GET", parameters: parameters) { (data, val, error) in
            guard let data11 = data else { return }
            do{
                let res = try JSONDecoder().decode([GeoCodeModel]?.self, from: data11)
                completion(res)
                // print("cghvdghcdvhcv",res as Any)
            }catch{
                completion(nil)
                print("Error on parsing")
            }
        }
    }
}
