//
//  RegisterVC+PickerDS.swift
//  CheckInApp
//
//  Created by Тимур on 17/01/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

extension RegisterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aircompanies.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let aircompany = aircompanies[row]
        let aircompanyViewCell: AircompanyViewCell
        if let aircompanyView = view as? AircompanyViewCell {
            aircompanyViewCell = aircompanyView
        } else {
            aircompanyViewCell = AircompanyViewCell()
        }
        aircompanyViewCell.nameLabel.text = aircompany.name
        aircompanyViewCell.url = URL(string: aircompany.logoURL)
        return aircompanyViewCell
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        aircompanyPickerView?.removeFromSuperview()
        currentAircompany = aircompanies[row]
    }
}
