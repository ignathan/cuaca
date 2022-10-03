//
//  NetworkService.swift
//  Cuaca
//
//  Created by Ignatius Nathan on 03/10/2022.
//

import Foundation
import Alamofire

class NetworkService {
    
    static let `default` = NetworkService()
    
    let baseURL = "https://api.weatherapi.com/v1/"
    let apiKey = "346fa87e7ac74727a1a72424222405"
    
    var alamofire = AF
    
    func getCurrentWeather(query: String) async throws -> CurrentWeatherResponse {
        
        let urlString = baseURL + "current.json"
        
        let params = [
            "key": apiKey,
            "q": query
        ]
        let task = alamofire
            .request(URL(string: urlString)!,
                     method: .get,
                     parameters: params)
            .serializingData()
        
        let data = try await task.value
        
        let decoder = JSONDecoder()
        
        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            throw errorResponse.error
        }
        return try decoder.decode(CurrentWeatherResponse.self, from: data)
    }
}

