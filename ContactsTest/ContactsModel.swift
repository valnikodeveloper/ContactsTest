//
//  ContactsModel.swift
//  ContactsTest
//  Model class whish is repsonsible for handle:
//  1. Requesting data from JSON
//  2. Operation with CoreData (data model)
//
//  Created by Valeriy on 25/11/2018.
//  Copyright © 2018 Valeriy Nikolaev. All rights reserved.
//Model

import UIKit
import CoreData

//Define structure for ContactInDetail
struct ContactInDetail {
    var contactID: String = "Unknown"
    var firstName: String = "Unknown"
    var lastName: String = "Unknown"
    var phoneNumber: String = ""
    var streetAddress1: String = ""
    var streetAddress2: String = ""
    var city: String = ""
    var state: String = ""
    var zipCode: String = ""
}

class ContactsModel {
    
    private var contactsDictionary:[[String: Any]]?
    var delegateActions:CoreUpdaterDelegate?
    
    //MARK: Only deletes from storage
    private  func purgeOfStorage() {
        
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an unexpected error")
        }
    }
    
    //Clean All records
    func resetAllRecords() {
        purgeOfStorage()
        delegateActions?.resetAllViewModel()
        delegateActions?.updateRows()
    }
    
    //MARK:Retrieve values when index is Match and if value if different replace values and save
    //contactInDetailToUpdate - current model of chosen row
    //anIndexAsId - index of chosen row
    func update(contactInDetailToUpdate:ContactInDetail,anIndexAsId:Int) {
        
        //Refer to appDelegate container for this class
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {return}
        
        //in case if the list too big
        appDelegate.persistentContainer.performBackgroundTask{ managedContext in
            // creating a context for already initialized appDelegate container
            
            let fetchedReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsEntity")
            
            //Find edited field by Index from table of Contacts
            //and save new data there
            var currentIndex = 0
            
            var isMatched = false
            do {
                let contactsModels = try managedContext.fetch(fetchedReq)
                
                for contact in contactsModels as! [NSManagedObject] {
                    //Here is viewModel is filling model -> view
                    
                    if anIndexAsId == currentIndex {
                        
                        //Update only if it's not match
                        if contact.value(forKey: "contactID") as! String != contactInDetailToUpdate.contactID {
                            contact.setValue(contactInDetailToUpdate.contactID, forKey: "contactID")
                            isMatched = true
                        }
                        
                        if contact.value(forKey: "firstName") as! String != contactInDetailToUpdate.firstName {
                            contact.setValue(contactInDetailToUpdate.firstName, forKey: "firstName")
                            isMatched = true
                        }
                        
                        if contact.value(forKey: "lastName") as! String != contactInDetailToUpdate.lastName {
                            contact.setValue(contactInDetailToUpdate.lastName, forKey: "lastName")
                            isMatched = true
                        }
                        
                        if contact.value(forKey: "phoneNumber") as! String != contactInDetailToUpdate.phoneNumber {
                            contact.setValue(contactInDetailToUpdate.phoneNumber, forKey: "phoneNumber")
                            isMatched = true
                        }
                        
                        if contact.value(forKey: "state") as! String != contactInDetailToUpdate.state {
                            contact.setValue(contactInDetailToUpdate.state, forKey: "state")
                            isMatched = true
                        }
                        
                        if contact.value(forKey: "city") as! String != contactInDetailToUpdate.city {
                            contact.setValue(contactInDetailToUpdate.city, forKey: "city")
                            isMatched = true
                        }
                        
                        if contact.value(forKey: "streetAddress1") as! String != contactInDetailToUpdate.streetAddress1 {
                            contact.setValue(contactInDetailToUpdate.streetAddress1, forKey: "streetAddress1")
                            isMatched = true
                        }
                        
                        if contact.value(forKey: "streetAddress2") as! String != contactInDetailToUpdate.streetAddress2 {
                            contact.setValue(contactInDetailToUpdate.streetAddress2, forKey: "streetAddress2")
                            isMatched = true
                        }
                        
                        if contact.value(forKey: "zipCode") as! String != contactInDetailToUpdate.zipCode {
                            contact.setValue(contactInDetailToUpdate.zipCode, forKey: "zipCode")
                            isMatched = true
                        }
                    }
                    if isMatched {
                        try managedContext.save()
                        return
                    }
                    currentIndex += 1
                }

            } catch let error as NSError {
                print("Unexpected error:Could not fetch data. \(error), \(error.userInfo)")
            }
        }
    }
    
    //Remove a record
    func removeRecord(anIndexAsId:Int) {
        
        //Refer to appDelegate container for this class
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {return}
        
        // creating a context for already initialized appDelegate container
        
        //in case if the list too big
        appDelegate.persistentContainer.performBackgroundTask {managedContext in
            
            let fetchedReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsEntity")
            
            //Find edited field by Index from table of Contacts
            //and save new data there
            var currentIndex = 0
            
            do {
                let contactsModels = try managedContext.fetch(fetchedReq)
                for contact in contactsModels as! [NSManagedObject] {
                    if anIndexAsId == currentIndex {
                        managedContext.delete(contact)
                        do {
                            try managedContext.save()
                        }catch{
                            print("couldn't save all the data")
                        }
                        return
                    }
                //Here is viewModel is filling model -> view
                currentIndex += 1
                }
            } catch let error as NSError {
                print("Unexpected error:Could not fetch data. \(error), \(error.userInfo)")
            }
        }
    }

    //Save to storage (data model)
    func saveToStorage(contactInDetailToStore:ContactInDetail) {
        //Refer to appDelegate container for this class
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {return}
        // creating a context for already initialized appDelegate container
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let newEntotyObj =
            NSEntityDescription.insertNewObject(forEntityName: "ContactsEntity", into: managedContext)
            newEntotyObj.setValue(contactInDetailToStore.contactID, forKeyPath: "contactID")
            newEntotyObj.setValue(contactInDetailToStore.firstName, forKeyPath: "firstName")
            newEntotyObj.setValue(contactInDetailToStore.lastName, forKeyPath: "lastName")
            newEntotyObj.setValue(contactInDetailToStore.phoneNumber, forKeyPath: "phoneNumber")
            newEntotyObj.setValue(contactInDetailToStore.streetAddress1, forKeyPath: "streetAddress1")
            newEntotyObj.setValue(contactInDetailToStore.streetAddress2, forKeyPath: "streetAddress2")
            newEntotyObj.setValue(contactInDetailToStore.city, forKeyPath: "city")
            newEntotyObj.setValue(contactInDetailToStore.state, forKeyPath: "state")
            newEntotyObj.setValue(contactInDetailToStore.zipCode, forKeyPath: "zipCode")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Fatal: data is failed to save. \(error), \(error.userInfo)")
        }
    }
    
    //Import data from JSON and store it in data model
    func importDataFromJson() {
        var contactInDetail: ContactInDetail = ContactInDetail()
        let pathToJson = Bundle.main.path(forResource: "contacts", ofType: "json")
        if pathToJson == nil {
            print("Couldn't find json file bye bye!")
            return
        }
        //in case of lots of records
        DispatchQueue.main.async {
            do {
                let dataReceived = try Data(contentsOf: URL(fileURLWithPath: pathToJson!), options: [])
                let jsonDic = try! JSONSerialization.jsonObject(with: dataReceived, options: []) as? [String: Any]
                self.contactsDictionary = jsonDic?["people"] as? [[String: Any]]
                
                for contactInDetailData in self.contactsDictionary! {
                    contactInDetail.contactID = contactInDetailData["contactID"] as! String
                    contactInDetail.firstName = contactInDetailData["firstName"] as! String
                    contactInDetail.lastName = contactInDetailData["lastName"] as! String
                    contactInDetail.phoneNumber = contactInDetailData["phoneNumber"] as! String
                    contactInDetail.streetAddress1 = contactInDetailData["streetAddress1"] as! String
                    contactInDetail.streetAddress2 = contactInDetailData["streetAddress2"] as! String
                    contactInDetail.city = contactInDetailData["city"] as! String
                    contactInDetail.state = contactInDetailData["state"] as! String
                    contactInDetail.zipCode = contactInDetailData["zipCode"] as! String
                    self.delegateActions?.addNewContact(contactNewInDetail: contactInDetail)
                    self.saveToStorage(contactInDetailToStore:contactInDetail)
                }
            } catch {
                print("Fatal: failed to parse JSON. \(error), \(String(describing: error._userInfo))")
            }
        }
    }
    
    //Clean data of Array for table view
    func removeAllViewsRecords() {
        delegateActions?.resetAllViewModel()
    }
    
    //MARK:Load data from storage
    //Fetch data from storage (data model) and send it to view (Load data from storage happens here)
    func sendDataFromStorageToView() {
        
            //in case of lots of records
            //Refer to appDelegate container for this class
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {return}
            
            // creating a context for already initialized appDelegate container
            
            appDelegate.persistentContainer.performBackgroundTask{ managedContext in
            
                let fetchRequest =
                    NSFetchRequest<NSManagedObject>(entityName: "ContactsEntity")
                do {
                    
                    let contactsModels = try managedContext.fetch(fetchRequest)
                    
                    for contact in contactsModels as! [ContactsEntity] {
                        var contactInDetail: ContactInDetail = ContactInDetail()
                        contactInDetail.city = contact.city!
                        contactInDetail.contactID = contact.contactID!
                        contactInDetail.firstName = contact.firstName!
                        contactInDetail.lastName = contact.lastName!
                        contactInDetail.phoneNumber = contact.phoneNumber!
                        contactInDetail.state = contact.state!
                        contactInDetail.streetAddress1 = contact.streetAddress1!
                        contactInDetail.streetAddress2 = contact.streetAddress2!
                        contactInDetail.zipCode = contact.zipCode!
                        DispatchQueue.main.async {
                            self.delegateActions?.addNewContact(contactNewInDetail: contactInDetail)
                        }
                    }
                } catch let error as NSError {
                    print("Unexpected error:Could not fetch data. \(error), \(error.userInfo)")
                }
            }
        }
}

//MARK: Here is delegation declaring for send data to view and updating view
protocol CoreUpdaterDelegate:class {
    func resetAllViewModel()
    func addNewContact(contactNewInDetail:ContactInDetail)
    func updateRows()
}
