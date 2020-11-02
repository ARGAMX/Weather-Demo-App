//
//  CollectionListAdapterVC.swift
//

import UIKit
import IGListKit

class CollectionListAdapterVC: BaseVC, ListAdapterDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    func configureCollectionView() {
        adapter.collectionView = self.collectionView
        adapter.dataSource = self
    }

    //MARK: - ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [ListDiffable]()
    }
    
    // should be overriden
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {

        if object is DummyCellVM {
            return (object as! DummyCellVM).sectionController()
        } else if object is SpacerCellVM {
            return (object as! SpacerCellVM).sectionController()
        } else if object is ImageCellVM {
            return (object as! ImageCellVM).sectionController()
        } else if object is TextFieldCellVM {
            return (object as! TextFieldCellVM).sectionController()
        } else if object is SpinnerCellVM {
            return SpinnerCellSC()
        }
        
        _$fail(reason: "CollectionView listAdapter error. object is unknown to controller")
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
	
}
