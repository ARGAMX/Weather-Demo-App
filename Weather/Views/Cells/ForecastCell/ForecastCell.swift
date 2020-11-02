//
//  ForecastCell.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import Kingfisher


class ForecastCell: GenericCell<ForecastCellVM> {
        
    static let mainTextLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 14.0)
    static let additionalTextLabelFont: UIFont = UIFont.systemFont(ofSize: 11.0)
    
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var additionalTextLabel: UILabel!
    @IBOutlet weak var detailsOneTextLabel: UILabel!
    @IBOutlet weak var detailsTwoTextLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var iconBackView: UIView!
    @IBOutlet var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func configureView() {
        mainTextLabel.font = Self.mainTextLabelFont
        mainTextLabel.textColor = .mtTextColor
        additionalTextLabel.font = Self.additionalTextLabelFont
        additionalTextLabel.textColor = .mtAdditionalTextColor
        detailsOneTextLabel.font = Self.mainTextLabelFont
        detailsOneTextLabel.textColor = .mtTextColor
        detailsTwoTextLabel.font = Self.mainTextLabelFont
        detailsTwoTextLabel.textColor = .mtAdditionalTextColor
    }
    
    override func configureWith(_ viewModel: ForecastCellVM) {
        mainTextLabel.text = viewModel.weekDay
        additionalTextLabel.text = viewModel.date
        detailsOneTextLabel.text = viewModel.tempDay
        detailsTwoTextLabel.text = viewModel.tempNight
        if let iconUrl = viewModel.iconUrl {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage( with: iconUrl, placeholder: nil)
        }
    }
    
    // MARK: - Cell size
    
    override class func cellSizeWith(_ containerSize: CGSize, _ viewModel: ForecastCellVM) -> CGSize {
        return CGSize(width: containerSize.width, height: 54.0)
    }
    
}
