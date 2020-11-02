//
//  SpinnerCellVM.swift
//

import Foundation
import IGListKit


class SpinnerCellVM {
	private var unique = UUID().uuidString
}

// MARK: - IGListDiffable
extension SpinnerCellVM: ListDiffable {
	func diffIdentifier() -> NSObjectProtocol {
		return unique as NSString
	}
	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		if let object = object as? SpinnerCellVM {
			return object.unique == self.unique
		} else {
			return false
		}
	}
}
