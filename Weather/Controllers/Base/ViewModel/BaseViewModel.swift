//
//  BaseViewModel.swift
//

import UIKit
import IGListKit
import RxSwift


typealias EmptyClosure = () -> Void
typealias SimpleBlock = () -> Void


class BaseViewModel: NSObject {
    
    private weak var delegate: ViewControllerProtocol?
    
    var updateHandler: EmptyClosure?
    var requestsDisposeBag: DisposeBag = DisposeBag()
    var subscriptionsDisposeBag: DisposeBag = DisposeBag()
    var viewModels = [ListDiffable]()
    var loadingSpinner = SpinnerCellVM()
    var loadingThreads: Int = 0
    var isLoading: Bool {
        (loadingThreads > 0)
    }
    
    // MARK: - Init
    
    init(delegate: ViewControllerProtocol?) {
        self.delegate = delegate
    }
	
    // MARK: - Lifecycle methods
    
    // MARK: - public
    
    // Override me
    func reloadData() {
        
    }
    
    func onError(_ error: Error? = nil) {
    }
    
    func empty(_ color: UIColor = .clear) -> DummyCellVM {
        return DummyCellVM(backgroundColor: color)
    }
    
    static func empty(_ color: UIColor = .clear) -> DummyCellVM {
        return DummyCellVM(backgroundColor: color)
    }
    
    // MARK: - private
    
}
