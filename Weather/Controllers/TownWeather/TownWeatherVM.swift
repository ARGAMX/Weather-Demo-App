//
//  TownWeatherVM.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import RxSwift
import IGListKit
import RealmSwift


protocol TownWeatherVMDelegate: ViewControllerCommonProtocol { 
    func townWeatherVMChangeTown(_ viewModel: TownWeatherVM)
}


class TownWeatherVM: BaseViewModel {
    
    weak var delegate: TownWeatherVMDelegate?
    private var townWeather: TownWeather!
    private var forecast: Forecast?
    private lazy var typeSwitcher: TypeSwitcherCellVM = TypeSwitcherCellVM(delegate: self)
    
    // MARK: - public
    
    public init(delegate: TownWeatherVMDelegate, townWeather: TownWeather) {
        super.init(delegate: delegate)
        self.delegate = delegate
        self.townWeather = townWeather
        
        reloadData()
    }
    
    override func reloadData() {
        getForecast()
        prepareViewModels()
    }
    
    // MARK: - private
    
    private func prepareViewModels() {
        
        viewModels = []
        
        viewModels.append( SpacerCellVM(height: 20.0) )
        viewModels.append( TownWeatherHeaderCellVM(delegate: self, dateableTown: townWeather) )
        viewModels.append( ImageCellVM(delegate: nil, imageUrl: townWeather.iconUrl, height: 160.0) )
        viewModels.append( WeatherCellVM(delegate: nil, weatherableTown: townWeather) )
        viewModels.append( SpacerCellVM(height: 20.0) )
        
        if let forecast = self.forecast {
            viewModels.append( typeSwitcher )
            viewModels.append( SpacerCellVM(height: 20.0) )
            for (index, forecastWeather) in Array(forecast.daily).enumerated() {
                if (index < forecastItemsCount()) {
                    viewModels.append( ForecastCellVM(delegate: nil, forecastWeatherable: forecastWeather, index: index) )
                }
            }
        }
        viewModels.append( SpacerCellVM(height: 20.0) )
        isLoading ? viewModels.append( loadingSpinner ) : ()
                        
        updateHandler?()
    }
    
    private func forecastItemsCount() -> Int {
        return typeSwitcher.type == 0 ? 3 : 7
    }
    
    // MARK: - actions
    
    private func getForecast() {
        let forecast = getForecastFromDB()
        if let forecast = forecast {
            self.forecast = forecast
            prepareViewModels()
        }
        if let lat = townWeather.coord?.lat, let lon = townWeather.coord?.lon {
            getForecastFromServer(lat: lat, lon: lon)
        }
    }
    
    private func setForecast(_ forecast: Forecast) {
        self.forecast = forecast
        saveForecastWeather(forecast)
    }
    
    // MARK: - DB
    
    private func getForecastFromDB() -> Forecast? {
        let realmDB = RealmManager.shared.defaultRealm
        let forecast: Forecast? = realmDB.object(ofType: Forecast.self, forPrimaryKey: townWeather.id)
        return forecast
    }
    
    private func saveForecastWeather(_ forecast: Forecast) {
        let realmDB = RealmManager.shared.defaultRealm
        self.forecast?.townID = townWeather.id
        try! realmDB.write { () -> Void in
            realmDB.add(forecast, update: .modified)
        }
    }
    
    // MARK: - Network
    
    private func getForecastFromServer(lat: Double, lon: Double) {
        let onNext: ((Forecast) -> Void) = { [weak self] response in guard let welf = self else { return }
            let forecast: Forecast = response
            welf.setForecast(forecast)
        }
        
        let onError: ((Error) -> Void) = { [weak self] error in guard let welf = self else { return }
            welf.delegate?.showStatusBarError(error)
            welf.onError(error)
        }
        
        requestsDisposeBag = DisposeBag()
        loadingThreads += 1
        TownWeather.getForecastWeather(lat: lat, lon: lon)
            .subscribe(onNext: onNext,
                       onError: onError,
                       onDisposed: onDisposed()).disposed(by: self.requestsDisposeBag)
    }
    
    private func onDisposed() -> (() -> Void) {
        let onDisposed: (() -> Void) = { [weak self] in guard let welf = self else { return }
            welf.loadingThreads -= 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                welf.prepareViewModels()
            }
        }
        return onDisposed
    }
    
    // MARK: - private
        
}


extension TownWeatherVM: TownWeatherHeaderCellVMDelegate {
    func townWeatherHeaderCellVMPressed(_ viewModel: TownWeatherHeaderCellVM) {
        delegate?.townWeatherVMChangeTown(self)
    }
}

extension TownWeatherVM: TypeSwitcherCellVMDelegate {
    func typeSwitcherCellTypeChanged(type: Int) {
        prepareViewModels()
    }
}
