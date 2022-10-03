//
//  HomeInteractor.swift
//  Cuaca
//
//  Created by Ignatius Nathan on 03/10/2022.
//

class HomeInteractor {
    
    var networkService = NetworkService.default
    
    weak var delegate: HomePresenterDelegate?
    
    @MainActor
    func getCurrentWeather(query: String) async {
        
        do {
            let response = try await networkService.getCurrentWeather(query: query)
            
            delegate?.present(location: response.location.name,
                              currentC: response.current.currentC,
                              currentF: response.current.currentF,
                              condition: response.current.condition.text,
                              humidity: response.current.humidity,
                              feelsC: response.current.feelsC,
                              feelsF: response.current.feelsF,
                              uv: response.current.uv)
        } catch {
            delegate?.present(error: error)
        }
    }
}
