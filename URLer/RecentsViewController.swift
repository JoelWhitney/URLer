//
//  RecentsViewController.swift
//  URLer
//
//  Created by Joel Whitney on 3/5/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class RecentsViewController: UITableViewController {
    // MARK: - variables/constants
    var alertTextField = UITextField()
    let supportedIdentifiers = Bundle.main.infoDictionary?["LSApplicationQueriesSchemes"] as? [String] ?? []
    
    // MARK: - initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    // MARK: - actions
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    
    // MARK: - tableview stuff
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.allItems.count + 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        if indexPath.row < DataStore.shared.allItems.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "URLCell", for: indexPath) as! URLCell
            let item = DataStore.shared.allItems[indexPath.row]
            cell.url.attributedText = NSMutableAttributedString(string: item.url.absoluteString)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCell", for: indexPath) as! LastCell
            cell.lastCellLabel.text = ""
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        DataStore.shared.moveItem(fromIndex: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == DataStore.shared.allItems.count {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == DataStore.shared.allItems.count {
            return false
        } else {
            return true
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == DataStore.shared.allItems.count {
            return false
        } else {
            return true
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = DataStore.shared.allItems[indexPath.row]
            let title = "Remove \(item.url.absoluteString)"
            let message = "Are you sure you want to remove this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: {
                (action) -> Void in
                print(DataStore.shared.allItems.count)
                DataStore.shared.removeItem(item)
                print(DataStore.shared.allItems.count)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            })
            ac.addAction(deleteAction)
            present(ac, animated: true, completion: nil)
        }
    }
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove URL"
    }

    // MARK: - class methods
    func addNewURL(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add URL", message: "Enter URL below", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configureTextField)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: handleCancel))
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: handleAddURL))
        self.present(alert, animated: true, completion: {
            // do stuff
        })
    }
    func clearURLs(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Clear all URLs", message: "Are you sure you want to clear all URLs?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: handleCancel))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: handleClearURLs))
        self.present(alert, animated: true, completion: {
            // do stuff
        })
    }
    func configureTextField(alertTextField: UITextField?) {
        if let textField = alertTextField {
            self.alertTextField = textField // save reference to UITextField
        }
    }
    func handleCancel(alertView: UIAlertAction!) {
        // do cancel stuff here
    }
    func handleAddURL(alertView: UIAlertAction!) {
        let newURL = self.alertTextField.text
        let urlString = newURL?.replacingOccurrences(of: " ", with: "")
        if !(urlString!.isEmpty), verifyApplicationID(url: urlString!), UIApplication.shared.canOpenURL(URL(string: urlString!)!) {
            // Create a new Item and add it to the store
            let url = URL(string: urlString!)
            DataStore.shared.addItem(url: url!)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)

        } else {
            print("Bad new url")
            let alertController = UIAlertController(title: "Error", message: "Application schema is not valid or application not installed", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func handleClearURLs(alertView: UIAlertAction!) {
        DataStore.shared.removeAllItems()
        tableView.reloadData()
    }
    func verifyApplicationID(url: String) -> Bool {
        let urlSplit = url.characters.split {$0 == ":"}
        let app = urlSplit.map(String.init)[0] // → ["arcgis-explorer", "//"]
        if supportedIdentifiers.contains(app) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - view transition overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        navigationItem.title = "Recents"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        var items = [UIBarButtonItem]()
        items.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewURL(sender:))))
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        items.append(UIBarButtonItem(title: "Clear All", style: .done, target: self, action: #selector(clearURLs(sender:))))
        toolbarItems = items
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DataStore.shared.saveChanges()
    }
    
}

// MARK: - URL Cell
class URLCell: UITableViewCell {
    @IBOutlet var url: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Last Cell
class LastCell: UITableViewCell {
    @IBOutlet var lastCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 10.0, *) {
            lastCellLabel.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
    }
    
}

