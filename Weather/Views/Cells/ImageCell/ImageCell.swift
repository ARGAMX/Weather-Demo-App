//
//  ImageCell.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import Kingfisher


class ImageCell: GenericCell<ImageCellVM> {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var viewModel: ImageCellVM?
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        configureView()
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Init
    
    override func configureView() {
    }
    
    override func configureWith(_ viewModel: ImageCellVM) {
        self.viewModel = viewModel
        
        if let imageName = viewModel.imageName {
            imageView.image = UIImage(named: imageName)
        }
        if let imageUrl = viewModel.imageUrl {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage( with: URL(string: imageUrl), placeholder: nil)
        }
        imageView.contentMode = viewModel.imageContentMode
    }
    
    override static func cellSizeWith(_ containerSize: CGSize, _ viewModel: ImageCellVM) -> CGSize {
        return CGSize(width: containerSize.width, height: viewModel.height)
    }
    
    // MARK: - IB Actions
    
}
