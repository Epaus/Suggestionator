//
//  UIElementManager.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 7/28/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit


class UIElementsManager {
    
    static func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    static func createTextField(placeholder: String = "",
                                placeholderColor: UIColor? = nil,
                                backgroundColor: UIColor = .white,
                                borderColor: UIColor = .clear,
                                borderWidth: CGFloat = 0,
                                cornerRadius: CGFloat = 5,
                                borderStyle: UITextField.BorderStyle = .none,
                                keyboardType: UIKeyboardType = .default,
                                contentVerticalAlignment: UIControl.ContentVerticalAlignment = .center,
                                textAlignment: NSTextAlignment = .left,
                                textColor: UIColor = .medicalCityBlue,
                                font: UIFont = .generalTextFont,
                                returnKeyType: UIReturnKeyType = .done,
                                isSecureTextEntry: Bool = false,
                                shadowColor: UIColor = .shadowBlack,
                                shadowRadius: CGFloat = 0,
                                shadowOffset: CGSize = CGSize(width: 0, height: 0),
                                shadowOpacity: Float = 0,
                                masksToBounds: Bool = false) -> UITextField {
        
        let textField = UITextField()
        if let placeholderColor = placeholderColor {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        } else {
            textField.placeholder = placeholder
        }
        textField.backgroundColor = backgroundColor
        textField.layer.borderColor = borderColor.cgColor
        textField.layer.borderWidth = borderWidth
        textField.borderStyle = borderStyle
        textField.layer.cornerRadius = cornerRadius
        textField.keyboardType = keyboardType
        textField.contentVerticalAlignment = contentVerticalAlignment
        textField.textAlignment = textAlignment
        textField.textColor = textColor
        textField.font = font
        textField.returnKeyType = returnKeyType
        textField.isSecureTextEntry = isSecureTextEntry
        textField.layer.masksToBounds = masksToBounds
        //textField.addShadow(shadowColor: shadowColor, shadowRadius: shadowRadius, shadowOffset: shadowOffset, shadowOpacity: shadowOpacity)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }
    
    static func createButton(text: String, font: UIFont = .generalTextFont, titleColor: UIColor = .medicalCityBlue, backgroundColor: UIColor = .clear, borderWidth: CGFloat = 0, borderColor: UIColor = .clear, cornerRadius: CGFloat = 5) -> UIButton {
        
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = font
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor.cgColor
        button.layer.cornerRadius = cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    static func createView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = UIElementSizes.cornerRadius
        //view.backgroundColor = UIColor.veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func createImageView(image: UIImage? = nil, tintColor: UIColor? = nil, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
        
        let imageView: UIImageView
        if let image = image {
            imageView = UIImageView(image: image)
        } else {
            imageView = UIImageView()
        }
        if let tintColor = tintColor {
            imageView.tintColor = tintColor
        }
        imageView.contentMode = contentMode
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    static func createLabel(text: String, font: UIFont = .titleFont, textColor: UIColor = .white, textAlignment: NSTextAlignment = .natural, adjustsFontSizeToFitWidth: Bool = false, numberOfLines: Int = 0) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.text = text
        label.textAlignment = textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        label.numberOfLines = numberOfLines
        // label.adjustsFontForContentSizeCategory = true
        
        return label
    }
    
    static func createTextView(text: String, font: UIFont = .generalTextFont, textColor: UIColor = .medicalCityBlue, textAlignment: NSTextAlignment = .natural, backgroundColor: UIColor = .clear, cornerRadius: CGFloat = 5) -> UITextView {
        
        let textView = UITextView()
        textView.text = text
        textView.font = font
        textView.textColor = textColor
        textView.backgroundColor = backgroundColor
        textView.layer.cornerRadius = cornerRadius
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.textAlignment = textAlignment
        
        return textView
    }
    
 
    
    static func addDoneButtonToTextView(_ textView: UITextView, selector: Selector?) {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: selector)
        
        doneToolbar.items = [flexSpace, doneButton]
        doneToolbar.sizeToFit()
        
        textView.inputAccessoryView = doneToolbar
    }
    
    static func addDoneButtonToTextField(_ textField: UITextField, selector: Selector?) {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: selector)
        
        doneToolbar.items = [flexSpace, doneButton]
        doneToolbar.sizeToFit()
        
        textField.inputAccessoryView = doneToolbar
    }
    
    static func addTextFieldAccessory(textField: UITextField, accessoryField: UITextField) {
        let toolbar = UIToolbar()
        
        accessoryField.translatesAutoresizingMaskIntoConstraints = true
        //accessoryField.frame = CGRect(x: 0, y: 0, width: UIElementSizes.windowWidth - 90, height: 30)
        accessoryField.rightView?.translatesAutoresizingMaskIntoConstraints = true
        accessoryField.rightView?.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        
        let barButtonItem = UIBarButtonItem(customView: accessoryField)
        
        toolbar.items = [barButtonItem]
        toolbar.sizeToFit()
        
        textField.inputAccessoryView = toolbar
        
        //         let accessoryView = UIView()
        //         accessoryView.backgroundColor = .detailGray
        //         accessoryView.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        //         accessoryView.translatesAutoresizingMaskIntoConstraints = false
        //         textField.inputAccessoryView = accessoryView
        //
        //         accessoryView.addSubviews(innerTextField)
        //         NSLayoutConstraint.activate([
        //             innerTextField.trailingAnchor.constraint(equalTo: accessoryView.trailingAnchor, constant: -8),
        //             innerTextField.heightAnchor.constraint(equalToConstant: 30),
        //             innerTextField.centerYAnchor.constraint(equalTo: accessoryView.centerYAnchor),
        //             innerTextField.leadingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: 8)
        //         ])
    }
    
    static func addRightButton(to textField: UITextField, button: UIButton, buttonSelector: Selector, rightPadding: CGFloat) {
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightPadding)
        textField.rightView = button
        textField.rightViewMode = .always
    }
    
    static func createStackView(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 16) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    static func createTableView(cellClassesAndIDs: [String: AnyClass], style: UITableView.Style = .plain) -> UITableView {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: style)
        for (id, cellClass) in cellClassesAndIDs {
            tableView.register(cellClass, forCellReuseIdentifier: id)
        }
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    static func createTableView(cellClass: AnyClass, reuseID: String, style: UITableView.Style = .plain) -> UITableView {
        return UIElementsManager.createTableView(cellClassesAndIDs: [reuseID: cellClass], style: style)
    }
    
    
    static func createColoredImage(color: UIColor = .medicalCityBlue, size: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            color.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    static func createSearchBar(placeholder: String = "Search") -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = placeholder
        return searchBar
    }
    
    static func createAlertController(title: String, message: String) -> UIAlertController {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    static func createUIDatePicker(datePickerMode: UIDatePicker.Mode, borderWidth: CGFloat, borderColor: UIColor, tintColor: UIColor, textColor: UIColor) -> UIDatePicker {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = datePickerMode
        datePicker.layer.borderWidth = borderWidth
        datePicker.layer.borderColor = borderColor.cgColor
        datePicker.tintColor = tintColor
        datePicker.setValue(textColor, forKey: "textColor")
        datePicker.datePickerMode = .time
        //       let startDate = Date()
        //        datePicker.maximumDate = startDate
        //        datePicker.minimumDate = startDate.addingTimeInterval(-oneDay)
        
        return datePicker
        
    }
    
    static func createUISwitch() -> UISwitch {
        let mySwitch = UISwitch()
        mySwitch.isOn = true
        return mySwitch
    }
    
    static func createUIPickerView(borderWidth: CGFloat, borderColor: UIColor, tintColor: UIColor, textColor: UIColor) -> UIPickerView {
        
        let pickerView = UIPickerView()
        pickerView.layer.borderWidth = borderWidth
        pickerView.layer.borderColor = borderColor.cgColor
        pickerView.tintColor = tintColor
        pickerView.setValue(textColor, forKey: "textColor")
        
        return pickerView
        
    }
    
    static func createUIStackView(width: CGFloat, height: CGFloat, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, spacing: CGFloat ) -> UIStackView {
        let sView = UIStackView()
        sView.frame = CGRect(x: 0, y:0, width: width, height: height)
        sView.axis = axis
        sView.distribution =  .equalSpacing
        sView.alignment = alignment //UIStackView.Alignment.center
        sView.spacing = spacing
        return sView
    }
}

