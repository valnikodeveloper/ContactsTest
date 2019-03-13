//
//  CellViewForDetails.swift
//  ContactsTest
//  Here is separatate cell
//  which is responsible for one field from
//  InDetailTableVC
//  Created by Valeriy on 25/11/2018.
//  Copyright © 2018-2019 Valeriy Nikolaev. All rights reserved.

import UIKit

class CellViewForDetails: UITableViewCell,UITextFieldDelegate {
  
    @IBOutlet weak var textFieldDetails: UITextField!
    var contactsInDetailWP:ContactInDetailWrapper!
    var index:Int! = 0
    weak var contactDelegate:UpdCViewDelegTextF?
    //Description label which is close to field.
    @IBOutlet weak var decriptionLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldDetails.delegate = self
    }
    
    //MARK: Delegate methods
    
    //When keyboard appears for text typing
    //1.Set right button as 'Done'.
    //2.Disable all the rows except this one
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        contactDelegate?.setRightButtonState(valueOfState:2)
        contactDelegate?.disableAllRowsExcept(rowIndex: index)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        //Index is to understand which row is active and which
        //field should be updated in contactInDetail
        switch index {
            case 0:
                contactsInDetailWP.contactInDetail.contactID = textFieldDetails.text!
                break
            case 1:
                contactsInDetailWP.contactInDetail.firstName = textFieldDetails.text!
                break
            case 2:
                contactsInDetailWP.contactInDetail.lastName = textFieldDetails.text!
                break
            case 3:
                contactsInDetailWP.contactInDetail.phoneNumber = textFieldDetails.text!
                break
            case 4:
                contactsInDetailWP.contactInDetail.streetAddress1 =  textFieldDetails.text!
                break
            case 5:
                contactsInDetailWP.contactInDetail.streetAddress2 =  textFieldDetails.text!
                break
            case 6:
                contactsInDetailWP.contactInDetail.city = textFieldDetails.text!
                break
            case 7:
                contactsInDetailWP.contactInDetail.state =  textFieldDetails.text!
                break
            case 8:
                contactsInDetailWP.contactInDetail.zipCode =  textFieldDetails.text!
                break
            default:
                contactsInDetailWP.contactInDetail.contactID = "error"
        }
        contactDelegate?.enableAllRows(alreadyEnabledRow: index)
        
        return true
    }
    //MARK: End of delegate methods
    
}

protocol UpdCViewDelegTextF:class {
    func enableAllRows(alreadyEnabledRow:Int)
    func disableAllRowsExcept(rowIndex:Int)
    func setRightButtonState(valueOfState:Int)
}
