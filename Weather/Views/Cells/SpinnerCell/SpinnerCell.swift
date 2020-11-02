//
//  SpinnerCell.swift
//

import UIKit
import NVActivityIndicatorView


class SpinnerCell: UICollectionViewCell {
	// MARK: - Private properties
    private(set) lazy var activityIndicatorImageView: NVActivityIndicatorView = {
        let frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        let activityIndicator = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballRotateChase, color: .mtTextColor, padding: nil)
        self.contentView.addSubview(activityIndicator)
        return activityIndicator
    }()
	
	// MARK: - View lifecycle
	override func layoutSubviews() {
		super.layoutSubviews()
		let bounds = contentView.bounds
		activityIndicatorImageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
	}
	
	// MARK: - Public functions
	func animate() {
        activityIndicatorImageView.isHidden = false
        activityIndicatorImageView.startAnimating()
	}
	
	func stopAnimating() {
        activityIndicatorImageView.isHidden = true
        activityIndicatorImageView.stopAnimating()
	}
}

