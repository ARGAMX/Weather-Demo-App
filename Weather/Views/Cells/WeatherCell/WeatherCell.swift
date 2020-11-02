//
//  WeatherCell.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit


class WeatherCell: GenericCell<WeatherCellVM> {
        
    static let mainTextLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 42.0)
    static let additionalTextLabelFont: UIFont = UIFont.systemFont(ofSize: 16.0)
    static let detailslTextLabelFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var additionalTextLabel: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func configureView() {
        mainTextLabel.font = Self.mainTextLabelFont
        additionalTextLabel.font = Self.additionalTextLabelFont
        mainTextLabel.textColor = .mtTextColor
        additionalTextLabel.textColor = .mtAdditionalTextColor
        
        for button: UIButton in [leftButton, centerButton, rightButton] {
            button.titleLabel!.font = Self.detailslTextLabelFont
            button.setTitleColor(.mtAdditionalTextColor)
            button.tintColor = .mtAdditionalTextColor
            button.makeSpaceBetweenIconAndText(insetAmount: 4.0)
        }
        
        leftButton.setImage(UIImage(named: "wind"))
        centerButton.setImage(UIImage(named: "pressure"))
        rightButton.setImage(UIImage(named: "humidity"))
                
        isUserInteractionEnabled = false
    }
    
    override func configureWith(_ viewModel: WeatherCellVM) {
        mainTextLabel.text = viewModel.temperature
        additionalTextLabel.text = viewModel.feelsLike
        
        leftButton.setTitle(viewModel.wind)
        centerButton.setTitle(viewModel.pressure)
        rightButton.setTitle(viewModel.humidity)
    }
    
    // MARK: - Cell size
    
    override class func cellSizeWith(_ containerSize: CGSize, _ viewModel: WeatherCellVM) -> CGSize {
        return CGSize(width: containerSize.width, height: 104.0)
    }
    
}
