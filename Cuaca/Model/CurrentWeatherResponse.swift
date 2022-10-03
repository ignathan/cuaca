//
//  CurrentWeatherResponse.swift
//  Cuaca
//
//  Created by Ignatius Nathan on 03/10/2022.
//

import Foundation

struct CurrentWeatherResponse: Codable {
    
    struct Current: Codable {
        
        struct Condition: Codable {
            let text: String
        }
        let currentC, currentF, feelsC, feelsF: Double
        
        let humidity, uv: Int
        
        let condition: Condition
        
        public enum CodingKeys: String, CodingKey {
            case uv, humidity, condition
            case currentC = "temp_c"
            case currentF = "temp_f"
            case feelsC = "feelslike_c"
            case feelsF = "feelslike_f"
        }
    }
    let location: Location
    
    let current: Current
}
