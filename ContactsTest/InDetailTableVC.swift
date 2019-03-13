//
//  InDetailTableVC.swift
//  ContactsTest
//  Here is Class of table which is responsible
//  for detailed description of contact
//  Created by Valeriy on 25/11/2018.
//  Copyright © 2018-2019 Valeriy Nikolaev. All rights reserved.


import UIKit

//Need to have a wrapper for struct
//To use ContactInDetail by reference In CellViewForDetails
class ContactInDetailWrapper {
    var contactInDetail =  ContactInDetail()
}

class InDetailTableVC: UITableViewController,UpdCViewDelegTextF {
    
    //To have ability use this view controller to send messages to model
    var contactsModel: ContactsModel!
    
    //A contact which we recive from ContactListVC
    let contactInDetailWP = ContactInDetailWrapper()
    weak var delegateViewUpdate:UpdateContactViewDelegate?
    
    //States = 0 - New , 1 - Save , 2 - Done
    var rightButtonState = 0
    var rightButtonPrevState = 0
    
    //Function with three states Done,Save,New
    //Done - when text field first responder is active
    //Save - when text field first responder is not active so it's possible to save data
    //New - when adding to contacts happens after tap
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        
        switch rightButtonState {
            //New - add new contact
            case 0:
                contactsModel.saveToStorage(contactInDetailToStore: contactInDetailWP.contactInDetail)
                delegateViewUpdate?.addNewContact(contactNewInDetail: contactInDetailWP.contactInDetail)
                navigationController?.popViewController(animated: true)
                break
            //Save - edit
            case 1:
                delegateViewUpdate?.contactEditing(contactEditInDetail: contactInDetailWP.contactInDetail)
                break
            //Done - close keyboard
            default:
                setRightButtonState(valueOfState: rightButtonPrevState)
                view.endEditing(true)
        }
    }
    
    //MARK:Delegate methods section
    
    //Here is set of right button state happens
    func setRightButtonState(valueOfState:Int) {
        //Save previous state
        rightButtonPrevState = rightButtonState
        
        switch valueOfState {
            //Add New
            case 0:
                rightButtonState = 0
                self.navigationItem.rightBarButtonItem?.title = "New"
                self.navigationItem.rightBarButtonItem?.tintColor = .red
                break
            //Save - edit
            case 1:
                rightButtonState = 1
                self.navigationItem.rightBarButtonItem?.title = "Save"
                self.navigationItem.rightBarButtonItem?.tintColor = .orange
                break
            //2 - default - close keyboard
            default:
                rightButtonState = 2
                self.navigationItem.rightBarButtonItem?.title = "Done"
                self.navigationItem.rightBarButtonItem?.tintColor = .black
        }
        
    }
    
    //All rows are enabled here except already enabled
    func enableAllRows(alreadyEnabledRow: Int) {
        
        for i in 0 ..< tableView.numberOfRows(inSection: 0) {
            
            if alreadyEnabledRow == i {
                continue
            }
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? CellViewForDetails
            cell?.isUserInteractionEnabled = true
            cell?.backgroundColor = UIColor(white: 1, alpha: 1)
            cell?.textFieldDetails.backgroundColor = UIColor(white: 1, alpha: 1)
        }
    }
    
    //Disable all rows are happened here except one
    func disableAllRowsExcept(rowIndex: Int) {

        for i in 0 ..< tableView.numberOfRows(inSection: 0) {

            if i == rowIndex {
                continue
            }
            
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? CellViewForDetails
            cell?.isUserInteractionEnabled = false
            cell?.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            cell?.textFieldDetails.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        }
        
    }
    //MARK: End delegate methods
    
    //Hide keyboard when it is in in real editing
    @objc func closeKeyboard() {
        if rightButtonState == 2 {
            view.endEditing(true)
            setRightButtonState(valueOfState:rightButtonPrevState)
        }
    }
    
    //Function for adding action when users tap outside
    func keyboardPreSetting () {
        //Add action when users tap outside
        let outsideTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InDetailTableVC.closeKeyboard))
        view.addGestureRecognizer(outsideTap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardPreSetting()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetailId", for: indexPath) as! CellViewForDetails

        cell.index = indexPath.row
        cell.contactDelegate = self
        cell.contactsInDetailWP = contactInDetailWP
    
        //Update cell depends on number
        switch indexPath.row {
            case 0:
                cell.decriptionLabel!.text = "contactID:"
                cell.textFieldDetails.placeholder = "Enter contactID"
                cell.textFieldDetails.text = contactInDetailWP.contactInDetail.contactID
                break
            case 1:
                cell.decriptionLabel!.text = "First Name:"
                cell.textFieldDetails.placeholder = "Enter First Name"
                cell.textFieldDetails.text = contactInDetailWP.contactInDetail.firstName
                break
            case 2:
                cell.decriptionLabel!.text = "Last Name:"
                cell.textFieldDetails.placeholder = "Enter Last Name"
                cell.textFieldDetails.text = contactInDetailWP.contactInDetail.lastName
                break
            case 3:
                cell.decriptionLabel!.text = "Phone Number:"
                cell.textFieldDetails.placeholder = "Enter Phone Number"
                cell.textFieldDetails.text = contactInDetailWP.contactInDetail.phoneNumber
                cell.textFieldDetails.keyboardType = .phonePad
                
                break
            case 4:
                cell.decriptionLabel!.text = "Street Address1:"
                cell.textFieldDetails.placeholder = "Enter Street Address1"
                cell.textFieldDetails.text = contactInDetailWP.contactInDetail.streetAddress1
                break
            case 5:
                cell.decriptionLabel!.text = "Street Address2:"
                cell.textFieldDetails.placeholder = "Enter  Street Address2"
                cell.textFieldDetails.text = contactInDetailWP.contactInDetail.streetAddress2
                break
            case 6:
                cell.decriptionLabel!.text = "City:"
                cell.textFieldDetails.placeholder = "Enter City"
                cell.textFieldDetails.text = contactInDetailWP.contactInDetail.city
                break
            case 7:
                cell.decriptionLabel!.text = "State:"
                cell.textFieldDetails.placeholder = "Enter State"
                cell.textFieldDetails.text = contactInDetailWP.contactInDetail.state
                break
            case 8:
                cell.decriptionLabel!.text = "Zip Code:"
                cell.textFieldDetails.placeholder = "Enter Zip Code"
                cell.textFieldDetails.text = contactInDetailWP.contactInDetail.zipCode
                tableView.tableFooterView = UIView(frame: CGRect.zero)
                break
            default:
                cell.textFieldDetails.placeholder = "Unknown text field"
         }
        return cell
    }
}

protocol UpdateContactViewDelegate:class {
    func contactEditing(contactEditInDetail:ContactInDetail)
    func addNewContact(contactNewInDetail:ContactInDetail)
}

