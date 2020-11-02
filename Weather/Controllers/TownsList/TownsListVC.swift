//
//  TownsListVC.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import RxSwift
import IGListKit


class TownsListVC: CollectionVC {
        
    lazy var viewModel: TownsListVM = {
        return TownsListVM(delegate: self)
    }()
    
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
        
        if object is TownListItemCellVM {
            return (object as! TownListItemCellVM).sectionController()
        }
        
        return super.listAdapter(listAdapter, sectionControllerFor: object)
    }
    
    // MARK: - Navigation
    
    func showTown(townWeather: TownWeather) {
        let viewController = TownWeatherVC(townWeather: townWeather)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
            
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension TownsListVC: TownsListVMDelegate {
    func townsListVMTownSelected(_ viewModel: TownsListVM, townWeather: TownWeather) {
        showTown(townWeather: townWeather)
    }
}



