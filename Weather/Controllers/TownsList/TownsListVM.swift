//
//  TownsListVM.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import RxSwift
import IGListKit
import RealmSwift


protocol TownsListVMDelegate: ViewControllerCommonProtocol {
    func townsListVMTownSelected(_ viewModel: TownsListVM, townWeather: TownWeather)
}


class TownsListVM: BaseViewModel {
    
    weak var delegate: TownsListVMDelegate?
    private var weatherArray: [TownWeather] = []
    private lazy var addTownCellVM = TextFieldCellVM(delegate: self, placeholderText: Loc.addTownInvite, height: 50.0)
    private lazy var userTowns: [Town] = getTownsFromDB()
        
    // MARK: - public
    
    public init(delegate: TownsListVMDelegate) {
        super.init(delegate: delegate)
        self.delegate = delegate
        
        reloadData()
    }
    
    override func reloadData() {
        getTownsWeather()
        prepareViewModels()
    }
    
    // MARK: - private
    
    private func prepareViewModels() {
        viewModels = []
            
        viewModels.append( SpacerCellVM(height: 40.0) )
        if weatherArray.isEmpty {
            for (index, town) in allTowns().enumerated() {
                viewModels.append( TownListItemCellVM(delegate: self, temperaturableTown: town, index: index) )
                viewModels.append( SpacerCellVM(height: 10.0) )
            }
        }
        else {
            for (index, townWeather) in weatherArray.enumerated() {
                viewModels.append( TownListItemCellVM(delegate: self, temperaturableTown: townWeather, index: index) )
                viewModels.append( SpacerCellVM(height: 10.0) )
            }
        }
        viewModels.append( addTownCellVM )
        viewModels.append( SpacerCellVM(height: 10.0) )
        isLoading ? viewModels.append( SpacerCellVM(height: 10.0) ) : ()
        isLoading ? viewModels.append( loadingSpinner ) : ()
        viewModels.append( SpacerCellVM(height: 40.0) )
                        
        updateHandler?()
    }
    
    private func defaultTowns() -> [Town] {
        return [
            Town(id: 524901, name: "Moscow"),
            Town(id: 625144, name: "Minsk"),
        ]
    }
    
    private func allTowns() -> [Town] {
        return defaultTowns() + userTowns
    }
    
    // MARK: - actions
    
    private func getTownsWeather() {
        let weatherArray = getTownsWeatherFromDB()
        if (weatherArray.count > 0) {
            self.weatherArray = weatherArray
            prepareViewModels()
        }
        getTownsWeatherFromServer(towns: allTowns())
    }
    
    private func setWeather(_ weather: [TownWeather]) {
        weatherArray = weather
        saveTownsWeatherToDB(weather)
    }
    
    private func addTown(WithName name: String) {
        addTownIfExist(townName: name)
    }
    
    private func saveTown(_ townWeather: TownWeather) {
        let isThisTownAlreadyInList = allTowns().filter{ $0.id == townWeather.id }.count > 0
        if (!isThisTownAlreadyInList) {
            let town = townWeather
            let newTown = Town(id: town.id, name: town.name)
            saveTownToDB(newTown)
            userTowns.append(newTown)
            getTownsWeatherFromServer(towns: allTowns())
            delegate?.showStatusBarSuccess(Loc.townAdded)
        }
        else {
            delegate?.showStatusBarError(Loc.townAlreadyInList)
        }
    }
    
    // MARK: - DB
    
    private func getTownsWeatherFromDB() -> [TownWeather] {
        let realmDB = RealmManager.shared.defaultRealm
        let weatherResults: Results<TownWeather> = realmDB.objects(TownWeather.self)
        let weatherArray: [TownWeather] = Array(weatherResults)
        return weatherArray
    }
    
    private func getTownsFromDB() -> [Town] {
        let realmDB = RealmManager.shared.defaultRealm
        let townsResults: Results<Town> = realmDB.objects(Town.self)
        let townsArray: [Town] = Array(townsResults)
        return townsArray
    }
    
    private func saveTownsWeatherToDB(_ weather: [TownWeather]) {
        let realmDB = RealmManager.shared.defaultRealm
        try! realmDB.write { () -> Void in
            realmDB.add(weather, update: .modified)
        }
    }
    
    private func saveTownToDB(_ town: Town) {
        let realmDB = RealmManager.shared.defaultRealm
        try! realmDB.write { () -> Void in
            realmDB.add(town, update: .modified)
        }
    }
    
    // MARK: - Network
    
    private func getTownsWeatherFromServer(towns: [Town]) {
        let onNext: (([TownWeather]) -> Void) = { [weak self] response in guard let welf = self else { return }
            let weather: [TownWeather] = response
            welf.setWeather(weather)
        }
        
        let onError: ((Error) -> Void) = { [weak self] error in guard let welf = self else { return }
            welf.delegate?.showStatusBarError(error)
            welf.onError(error)
        }
        
        requestsDisposeBag = DisposeBag()
        loadingThreads += 1
        TownWeather.getCurrentWeather(towns: towns)
            .subscribe(onNext: onNext,
                       onError: onError,
                       onDisposed: onDisposed()).disposed(by: self.requestsDisposeBag)
    }
    
    private func addTownIfExist(townName: String) {
        let onNext: ((TownWeather) -> Void) = { [weak self] response in guard let welf = self else { return }
            let townWeather: TownWeather = response
            welf.saveTown(townWeather)
        }
        
        let onError: ((Error) -> Void) = { [weak self] error in guard let welf = self else { return }
            welf.delegate?.showStatusBarError(error)
            welf.onError(error)
        }
        
        requestsDisposeBag = DisposeBag()
        loadingThreads += 1
        TownWeather.isTownExist(townName: townName)
            .subscribe(onNext: onNext,
                       onError: onError,
                       onDisposed: onDisposed()).disposed(by: self.requestsDisposeBag)
    }
    
    private func onDisposed() -> (() -> Void) {
        let onDisposed: (() -> Void) = { [weak self] in guard let welf = self else { return }
            welf.loadingThreads -= 1
            welf.prepareViewModels()
        }
        return onDisposed
    }
    
    // MARK: - private
        
}

extension TownsListVM: TownListItemCellVMDelegate {
    func townListItemCellVMPressed(_ viewModel: TownListItemCellVM, index: Int) {
        if (weatherArray.count > index) {
            delegate?.townsListVMTownSelected(self, townWeather: weatherArray[index])
        }
    }    
}

extension TownsListVM: TextFieldCellVMDelegate {
    func textFieldCellVMTextDidChange(text: String?) {
    }
    
    func textFieldCellVMButtonDidPressed(text: String?) {
        if let text = text, text.count > 0 {
            addTown(WithName: text)
        }
    }
}


