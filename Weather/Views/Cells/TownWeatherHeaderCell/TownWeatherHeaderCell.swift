//
//  TownWeatherHeaderCell.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit


class TownWeatherHeaderCell: GenericCell<TownWeatherHeaderCellVM> {
        
    static let mainTextLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 28.0)
    static let additionalTextLabelFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var additionalTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func configureView() {
        mainTextLabel.font = Self.mainTextLabelFont
        mainTextLabel.textColor = .mtTextColor
        additionalTextLabel.font = Self.additionalTextLabelFont
        additionalTextLabel.textColor = .mtAdditionalTextColor
    }
    
    override func configureWith(_ viewModel: TownWeatherHeaderCellVM) {
        mainTextLabel.text = viewModel.townName
        additionalTextLabel.text = viewModel.date
    }
    
    // MARK: - Cell size
    
    override class func cellSizeWith(_ containerSize: CGSize, _ viewModel: TownWeatherHeaderCellVM) -> CGSize {
        return CGSize(width: containerSize.width, height: 64.0)
    }
    
}
