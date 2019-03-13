//
//  ContactsListVC.swift
//  ContactsTest
//
//  Created by Valeriy on 25/11/2018.
//  Copyright © 2018-2019 Valeriy Nikolaev. All rights reserved.

import UIKit

class ContactsListVC: UITableViewController,CoreUpdaterDelegate,UpdateContactViewDelegate {
    
    //to remember which cell is under edit
    private var selectedCellForEdit:Int = 0
    //current data for this table
    private var contactsInDetail: [ContactInDetail] = []
    private var contactsModel: ContactsModel = ContactsModel()
    // Initialized when come frome first table to edit
    
    //may be initilized only in this class
    private var indexIdToEdit:Int?

    //When 'Clean All' is tapped
    @IBAction func cleanAll(_ sender: Any) {
        contactsModel.resetAllRecords()
    }
    
    //When 'Import' is tapped
    @IBAction func importData(_ sender: Any) {
        contactsModel.importDataFromJson()
    }
    
    //When 'Remove' is tapped
    @IBAction func remove(_ sender: Any) {
        if tableView.isEditing  == false {
            tableView.setEditing(true, animated: true)
            //Change 'Remove' to done to finish removing
            navigationItem.leftBarButtonItem!.title = "Done"
        }else {
            tableView.setEditing(false, animated: true)
            navigationItem.leftBarButtonItem!.title = "Remove"
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contactsInDetail.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
            //updating model part after deleting from row
            contactsModel.removeRecord(anIndexAsId: indexPath.row)
        }
        
    }
    
    //MARK: Delegate methods START
    func resetAllViewModel() {
        contactsInDetail.removeAll()
    }
    
    func updateRows() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //From table view controller edit action
    func contactEditing(contactEditInDetail: ContactInDetail) {
        contactsInDetail[selectedCellForEdit] = contactEditInDetail
        contactsModel.update(contactInDetailToUpdate: contactEditInDetail, anIndexAsId: indexIdToEdit!)
        tableView.reloadRows(at: [IndexPath(row: selectedCellForEdit, section: 0)], with: .automatic)
    }
    
    func addNewContact(contactNewInDetail:ContactInDetail) {
        tableView.beginUpdates()
        contactsInDetail.append(contactNewInDetail)
        tableView.insertRows(at: [IndexPath(row: contactsInDetail.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    //MARK: Delegate methods END
    
    //When tableview cell is choosen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellForEdit = indexPath.row
        
        //Initializaiing of InDetailTableVC
        let detailedContact = storyboard?.instantiateViewController(withIdentifier: "contactTVDetailId") as! InDetailTableVC
        detailedContact.contactInDetailWP.contactInDetail = contactsInDetail[indexPath.row]
        detailedContact.contactsModel = contactsModel
        detailedContact.delegateViewUpdate = self
        indexIdToEdit = indexPath.row
        detailedContact.setRightButtonState(valueOfState:1)
        navigationController?.pushViewController(detailedContact, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //When add button is tapped
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let aContactVC  = segue.destination as? InDetailTableVC {
            aContactVC.delegateViewUpdate = self
            aContactVC.setRightButtonState(valueOfState:0)
            aContactVC.contactsModel = contactsModel
            aContactVC.contactInDetailWP.contactInDetail = ContactInDetail()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsModel.delegateActions = self
        contactsModel.sendDataFromStorageToView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsInDetail.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellViewListId", for: indexPath)
        cell.textLabel?.text =  contactsInDetail[indexPath.row].firstName +
                                " " + contactsInDetail[indexPath.row].lastName
        cell.detailTextLabel?.text = "phone: " + contactsInDetail[indexPath.row].phoneNumber
        
        return cell
    }
 
}
