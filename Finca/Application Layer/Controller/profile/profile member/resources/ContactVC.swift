//
//  ContactVC.swift
//  Finca
//
//  Created by Silverwing Technologies on 14/02/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit
import ContactsUI


class ContactVC: BaseVC {
    
let itemCell = "ContactsCell"

    @IBOutlet weak var tbData: UITableView!
    
    @IBOutlet weak var tfSearch: UITextField!
    var contacts = [CNContact]()
    var filterContacts = [CNContact]()
      
 
    var lifelinecall : GeneralKnowledgeGameVC!
    var  addTenantDialogVC : AddTenantDialogVC!
    var fromCome = ""
    let store = CNContactStore()
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: itemCell, bundle: nil)
        tbData.register(nib, forCellReuseIdentifier: itemCell)
        tbData.delegate = self
        tbData.dataSource = self
        tbData.separatorStyle = .none
       
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        tfSearch.delegate = self
        
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            self.requestAccess { (request) in
                if request {
                    self.loadConatat()
                }
                
            }
        }
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
       filterContacts = textField.text!.isEmpty ? contacts : contacts.filter({ (item:CNContact) -> Bool in
          
            let name = item.givenName
                 var number = ""
        if item.phoneNumbers.count > 0 {
            
            number = item.phoneNumbers[0].value.stringValue
            
//            if let phone = item.phoneNumbers[0].value as? CNPhoneNumber {
//                number = phone.stringValue
//            } else {
//                print("number.value not of type CNPhoneNumber")
//            }
        }
        return number.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil || name.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
       })
        
        tbData.reloadData()
        
    }
    func  loadConatat() {
      
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)

        if authorizationStatus == .notDetermined {
          // 3
          store.requestAccess(for: .contacts) { [weak self] didAuthorize,
          error in
            if didAuthorize {
                self?.retrieveContacts(from: self!.store)
            }
          }
        } else if authorizationStatus == .authorized {
            retrieveContacts(from: store)
        }
        
        
        
    }
    
    func retrieveContacts(from store: CNContactStore) {
       
       var contacts = [CNContact]()
       // let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
    let    keys = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactPhoneNumbersKey,
                CNContactEmailAddressesKey,
                CNContactFamilyNameKey
        ] as [Any]
        
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        request.sortOrder = .userDefault
        do {
            try store.enumerateContacts(with: request) {
                (contact, stop) in
                contacts.append(contact)
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
        self.contacts = contacts
        self.filterContacts = self.contacts
      /*  self.filterContacts.sort { (item, item2) -> Bool in
            return item.givenName.localizedCaseInsensitiveCompare(item2.givenName) == ComparisonResult.orderedAscending
        }*/
        
        DispatchQueue.main.async {
            self.tbData.reloadData()
        }
      
    }
   

    
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        @unknown default:
           print("defult")
            break
        }
    }
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Go to Settings to grant access.", preferredStyle: .alert)
        if
            let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
                alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
                    completionHandler(false)
                    UIApplication.shared.open(settings)
                })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
    }
}


extension ContactVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  filterContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ContactsCell
              let item = filterContacts[indexPath.row]
              cell.selectionStyle  = .none
        // cell.lbName.text = item.phoneNumbers
        if item.phoneNumbers.count > 0 {
            cell.lbNumber.text = item.phoneNumbers[0].value.stringValue
//            if let phone = item.phoneNumbers[0].value as? CNPhoneNumber {
//                //print(phone.stringValue)
//                cell.lbNumber.text = phone.stringValue
//            } else {
//                print("number.value not of type CNPhoneNumber")
//            }
            //  cell.lbNumber.text = item.phoneNumbers[0].label
        }
        
        if item.givenName !=  "" {
            cell.lbName.text = item.givenName + " " + item.familyName
        } else {
            cell.lbName.text = item.givenName
        }
        
        if  item.givenName != "" {
            let fl = item.givenName.prefix(1)
            cell.ivImage.image =  self.doReturnImage(from: String(fl).lowercased())
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filterContacts[indexPath.row]
                 
        var number = ""
        // cell.lbName.text = item.phoneNumbers
        if item.phoneNumbers.count > 0 {
            number = item.phoneNumbers[0].value.stringValue
//            if let phone = item.phoneNumbers[0].value as? CNPhoneNumber {
//                //print(phone.stringValue)
//               // self.addResourceVC.tfMobile.text = phone.stringValue
//                number = phone.stringValue
//              } else {
//                print("number.value not of type CNPhoneNumber")
//            }
            //  cell.lbNumber.text = item.phoneNumbers[0].label
        }
        
            if fromCome ==  "AddTenant" {
            self.addTenantDialogVC.setNameAndNumber(number: number, fName: item.givenName , lName: item.familyName )
        }else if fromCome == "callLifeLine"{
            self.lifelinecall.setNameAndNumber(number: number)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
