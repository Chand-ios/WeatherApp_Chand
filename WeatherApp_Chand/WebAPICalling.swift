//
//  WebAPICalling.swift
//  WeatherApp
//
//  Created by Chand on 26/04/23.
//

import Foundation
import UIKit
import Alamofire

class WebAPICalling {
    
    
    static let shared = WebAPICalling()
    var baseURL1 = "http://api.openweathermap.org/"
    
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
    
    func ApiRequest(api: String,method:String,parameters:[String:Any],completion: @escaping(Data?,Any?,Error?)->Void)   {
        
        //        SVProgressHUD.show()
        //        SVProgressHUD.setBackgroundColor(UIColor.white)
        //        SVProgressHUD.setForegroundColor(UIColor.black)
        let color = UIColor.darkGray.withAlphaComponent(0.7)
        // SVProgressHUD.setBackgroundLayerColor(color)
        
        let baseUrl1 = baseURL1
        guard let url = URL(string: baseUrl1 + api) else {
            completion(nil, nil, nil)
            return
        }
        print(parameters)
        var header:HTTPHeaders = [:]
        header["contentType"] = "application/json"
        header["Accept"] = "application/json"
        var apiRequest = URLRequest(url: url)
        var jsonAryEncodedRequest:URLRequest?
        apiRequest.httpMethod = method
        apiRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if method == "POST"
        {
            apiRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
    
        }
        
        AF.request(apiRequest).responseJSON { response in
        
            let code = response.response?.statusCode
            if code == 401{
                self.showAlert(title: "error\(code ?? 0)", msg: "Something went wrong")
            }
            switch(response.result) {
            case .success(_):
                if let data = response.data{
                    completion(data, response.result, response.error)
                }
                break
            case .failure(_):
                completion(nil, nil, response.error)
                let code = response.response?.statusCode
                print("error on service call1", response.error?.localizedDescription as Any)
                self.showAlert(title: "error(\(code ?? 0))", msg: "\(response.error?.localizedDescription as Any)")
                break
            }
        }
    }
}
