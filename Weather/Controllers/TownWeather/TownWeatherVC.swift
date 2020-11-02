//
//  TownWeatherVC.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import RxSwift
import IGListKit


class TownWeatherVC: CollectionVC {
        
    var viewModel: TownWeatherVM!
    
    convenience public init(townWeather: TownWeather) {
        self.init()
        viewModel = TownWeatherVM(delegate: self, townWeather: townWeather)
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Init
    
    private func setupUI() {
    }
    
    // MARK: - Configure
    
    override func configureViewModel() {
        super.configureViewModel()
        collectionView.addSubview(refreshControl)
        viewModel.updateHandler = updateHandler()
    }
    
    // MARK: - IB Actions
    
    // MARK: - Actions
    
    @objc override func actionRefresh(_ sender: Any) {
        viewModel.reloadData()
    }
    
    // MARK: - ListAdapterDataSource methods
    
    override func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.viewModels
    }
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if object is TownWeatherHeaderCellVM {
            return (object as! TownWeatherHeaderCellVM).sectionController()
        } else if object is WeatherCellVM {
            return (object as! WeatherCellVM).sectionController()
        } else if object is ForecastCellVM {
            return (object as! ForecastCellVM).sectionController()
        } else if object is TypeSwitcherCellVM {
            return (object as! TypeSwitcherCellVM).sectionController()
        }
        
        return super.listAdapter(listAdapter, sectionControllerFor: object)
    }
    
    // MARK: - Navigation
    
    func showTownList() {
        dismiss()
    }
            
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension TownWeatherVC: TownWeatherVMDelegate {
    func townWeatherVMChangeTown(_ viewModel: TownWeatherVM) {
        showTownList()
    }
}



