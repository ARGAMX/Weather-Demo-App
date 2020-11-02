//
//  TypeSwitcherCell.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit


class TypeSwitcherCell: GenericCell<TypeSwitcherCellVM> {
    
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    
    private var viewModel: TypeSwitcherCellVM?
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let viewModel = self.viewModel {
                self.typeSegmentControl.selectedSegmentIndex = viewModel.type
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    // MARK: - Init
    
    override func configureWith(_ viewModel: TypeSwitcherCellVM) {
        self.viewModel = viewModel
        typeSegmentControl.setTitle(Loc.threeDays, forSegmentAt: 0)
        typeSegmentControl.setTitle(Loc.sevenDays, forSegmentAt: 1)
    }
    
    override static func cellSizeWith(_ containerSize: CGSize, _ viewModel: TypeSwitcherCellVM) -> CGSize {
        return CGSize(width: containerSize.width, height: 40.0)
    }
    
    // MARK: - IB Actions
    
    @IBAction func typeSegmentControlValueChanged(_ sender: UISegmentedControl) {
        viewModel?.setType(typeSegmentControl.selectedSegmentIndex)
    }
    
}
