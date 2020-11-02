//
//  TownListItemCell.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import Kingfisher


class TownListItemCell: GenericCell<TownListItemCellVM> {
        
    static let mainTextLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 28.0)
    static let additionalTextLabelFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var additionalTextLabel: UILabel!
    @IBOutlet weak var rightTextLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var iconBackView: UIView!
    @IBOutlet var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func configureView() {
        mainTextLabel.font = Self.mainTextLabelFont
        mainTextLabel.textColor = .mtGrayLightColor08
        additionalTextLabel.font = Self.additionalTextLabelFont
        additionalTextLabel.textColor = .mtGrayLightColor08
        rightTextLabel.font = Self.mainTextLabelFont
        rightTextLabel.textColor = .mtGrayLightColor08
        backView.backgroundColor = .mtTextColor
        iconBackView.backgroundColor = .mtAdditionalTextColor
        backView.layer.cornerRadius = 8.0
        backView.clipsToBounds = true
        iconBackView.layer.cornerRadius = iconBackView.frame.width / 2
        iconBackView.clipsToBounds = true
    }
    
    override func configureWith(_ viewModel: TownListItemCellVM) {
        mainTextLabel.text = viewModel.townName
        additionalTextLabel.text = viewModel.place
        rightTextLabel.text = viewModel.temperature
        if let iconUrl = viewModel.iconUrl {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage( with: iconUrl, placeholder: nil)
        }
    }
    
    // MARK: - Cell size
    
    override class func cellSizeWith(_ containerSize: CGSize, _ viewModel: TownListItemCellVM) -> CGSize {
        return CGSize(width: containerSize.width, height: 84.0)
    }
    
}
