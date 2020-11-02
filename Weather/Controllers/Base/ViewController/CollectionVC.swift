//
//  CollectionVC.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import IGListKit


class CollectionVC: CollectionListAdapterVC {
        
    let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(actionRefresh(_:)), for: .valueChanged)
        return control
    }()
    
    private var isBottomInsetAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        configureCollectionView()
        configureTopAndBottomViewOffsets()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {} else {adapter.reloadData(completion: nil)}
    }
    
    func configureViewModel() {

    }
    
    func updateHandler() -> () -> () {
        return { [weak self] () -> () in guard let welf = self else { return }
            welf.adapter.performUpdates(animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                welf.collectionView.reloadData()
            }
            welf.refreshControl.endRefreshing()
        }
    }
    
    override func configureCollectionView() {
        super.configureCollectionView()
        collectionView?.keyboardDismissMode = .onDrag
        collectionView?.alwaysBounceVertical = true
    }
    
    @available(iOS 11.0, *)
    func configureLargeTitleDisplayForIos11() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTopAndBottomViewOffsets() {
        if #available(iOS 13.0, *) {} else {
            // fixed iOS Insets in XIBs
            edgesForExtendedLayout = []
            tabBarController?.tabBar.isTranslucent = false
            navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    func disableAutomaticalAdjustment() {
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    func configureNavigationBarColors() {
        if let navBar = navigationController?.navigationBar {
            navBar.setValue(false, forKey: "hidesShadow")
            navBar.isTranslucent = true
            navBar.barTintColor = .white
        }
    }
    
    @objc func reloadData(_ sender: Any) {
        
    }

}
