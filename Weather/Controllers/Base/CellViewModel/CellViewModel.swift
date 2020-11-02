//
//  CellViewModel.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import IGListKit


@objc protocol CellViewModel {
    @objc func sectionController() -> ListSectionController
    @objc optional func didSelectItem(at index: Int)
}
