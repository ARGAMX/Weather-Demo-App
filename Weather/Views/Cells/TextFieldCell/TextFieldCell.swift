//
//  TextFieldCell.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit


class TextFieldCell: GenericCell<TextFieldCellVM> {

    @IBOutlet var textField: UITextField!
    @IBOutlet var addButton: UIButton!
    
    private var viewModel: TextFieldCellVM?
    
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
        addButton.setTitleColor(.mtTextColor)
        textField.tintColor = .mtTextColor
    }
    
    override func configureWith(_ viewModel: TextFieldCellVM) {
        self.viewModel = viewModel
        
        textField.placeholder = viewModel.placeholderText
        addButton.setTitle(viewModel.addButtonTitle)
        
        textField.delegate = self
    }
    
    // MARK: - Cell size
        
    override static func cellSizeWith(_ containerSize: CGSize, _ viewModel: TextFieldCellVM) -> CGSize {        
        return CGSize(width: containerSize.width, height: viewModel.height)
    }
    // MARK: - IB Actions
    
    @IBAction func textFieldTextChanged(_ sender: Any) {
        viewModel?.textChanged(text: textField.text)
    }
            
    @IBAction func addButtonPressed(_ sender: Any) {
        viewModel?.buttonPressed(text: textField.text)
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel?.textFieldShouldInput(text: textField.text ?? "", string: string, range: range) ?? true
    }
}
