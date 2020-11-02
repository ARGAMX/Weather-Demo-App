//
//  UICollectionView+Extensions.swift
//

import Foundation
import IGListKit

extension UICollectionView {
	
	func deselectCells() {
		if let indexPaths = self.indexPathsForSelectedItems {
			indexPaths.forEach({
				self.deselectItem(at: $0, animated: true)
			})
		}
	}
	
	func registerReusableCell<T: UICollectionViewCell>(_: T.Type)  {
		if let nib = T.nib {
			self.register(nib, forCellWithReuseIdentifier: T.reusableIdentifier)
		} else {
			self.register(T.self, forCellWithReuseIdentifier: T.reusableIdentifier)
		}
	}
	
	func dequeueReusableCell<T: UICollectionViewCell>(at indexPath: IndexPath) -> T {
		return self.dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as! T
	}
}


extension ListCollectionContext {
	func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type, for sectionController: ListSectionController, at index: Int) -> T {
		return dequeueReusableCell(withNibName: T.nibName, bundle: nil, for: sectionController, at: index) as! T
	}
	
	func dequeueReusableHeader<T: UICollectionViewCell>(_: T.Type, for sectionController: ListSectionController, at index: Int) -> T {
		return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: sectionController, nibName: T.nibName, bundle: nil, at: index) as! T
	}
	
	func dequeueReusableFooter<T: UICollectionViewCell>(_: T.Type, for sectionController: ListSectionController, at index: Int) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: sectionController, nibName: T.nibName, bundle: nil, at: index) as! T
	}
	
	func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_: T.Type, kind: String, for sectionController: ListSectionController, at index: Int) -> T {
		return dequeueReusableSupplementaryView(ofKind: kind, for: sectionController, nibName: T.nibName, bundle: nil, at: index) as! T
	}
}

