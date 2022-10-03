//
//  HomePresenter.swift
//  Cuaca
//
//  Created by Ignatius Nathan on 03/10/2022.
//

class HomePresenter {
    
    let interactor: HomeInteractor
    
    weak var delegate: HomeDelegate?
    
    init(interactor: HomeInteractor) {
        self.interactor = interactor
    }
    
    func requestCurrentWeather(keyword: String) {
        Task {
            await interactor.getCurrentWeather(query: keyword)
        }
        delegate?.displayLoading()
    }
}

// MARK: - HomePresenterDelegate
protocol HomePresenterDelegate: AnyObject {
    
    func present(location: String,
                 currentC: Double,
                 currentF: Double,
                 condition: String,
                 humidity: Int,
                 feelsC: Double,
                 feelsF: Double,
                 uv: Int)
    
    func present(error: Error)
}

extension HomePresenter: HomePresenterDelegate {
    
    func present(location: String,
                 currentC: Double,
                 currentF: Double,
                 condition: String,
                 humidity: Int,
                 feelsC: Double,
                 feelsF: Double,
                 uv: Int) {
        
        let temperature = String(format: "%.1f°C | %.1f°F", currentC, currentF)
        
        let feels = String(format: "%.1f°C | %.1f°F", feelsC, feelsF)
        
        delegate?.display(location: location,
                          temperature: temperature,
                          condition: condition,
                          humidityTitle: "HUMIDITY",
                          humidity: String(humidity),
                          feelsTitle: "FEELS LIKE",
                          feels: feels,
                          uvTitle: "UV INDEX",
                          uv: String(uv))
    }
    
    func present(error: Error) {
        delegate?.display(errorMessage: error.localizedDescription)
    }
}
