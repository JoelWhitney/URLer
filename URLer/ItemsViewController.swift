//
//  ItemsViewController.swift
//  URLer
//
//  Created by Joel Whitney on 2/22/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {

    //    // MARK: - Variables
//    var itemStore: ItemStore!
//    var imageStore: ImageStore!
//    // MARK: - Initialization
//    // navbar edit tool
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        navigationItem.leftBarButtonItem = editButtonItem
//    }
//    // MARK: - @IBActions
//    // toggle edit mode action
//    @IBAction func toggleEditingMode(_ sender: UIButton) {
//        if isEditing {
//            sender.setTitle("Edit", for: .normal)
//            setEditing(false, animated: true)
//        } else {
//            sender.setTitle("Done", for: .normal)
//            setEditing(true, animated: true)
//        }
//    }
//    // MARK: - TableView Data Model
//    // determine sections
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return itemStore.allItems.count + 1
//    }
//    // cells per sections
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(indexPath.row)
//        if indexPath.row < itemStore.allItems.count {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
//            let item = itemStore.allItems[indexPath.row]
//            cell.nameLabel.text = item.name
//            cell.serialNumberLabel.text = item.serialNumber
//            cell.valueLabel.text = "$\(item.valueInDollars)"
//            cell.styleCell(valueInDollars: item.valueInDollars)
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicItemCell", for: indexPath) as! BasicItemCell
//            cell.basicCellLabel.text = "No more items!  💩"
//            return cell
//        }
//    }
//    // MARK: - TableView Modify Data
//    // check move destination
//    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//        if proposedDestinationIndexPath.row == itemStore.allItems.count {
//            return sourceIndexPath
//        } else {
//            return proposedDestinationIndexPath
//        }
//    }
//    // move item
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
//    }
//    // MARK: - TableView Editing Tools
//    // move tool for cell
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        if indexPath.row == itemStore.allItems.count {
//            return false
//        } else {
//            return true
//        }
//    }
//    // edit tool for cell
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        if indexPath.row == itemStore.allItems.count {
//            return false
//        } else {
//            return true
//        }
//    }
//    // editing style
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let item = itemStore.allItems[indexPath.row]
//            let title = "Remove \(item.name)"
//            let message = "Are you sure you want to remove this item?"
//            
//            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            ac.addAction(cancelAction)
//            
//            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: {
//                (action) -> Void in
//                self.itemStore.removeItem(item)
//                self.imageStore.deleteImage(forKey: item.itemKey)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            })
//            ac.addAction(deleteAction)
//            present(ac, animated: true, completion: nil)
//        }
//    }
//    // title for delete tool
//    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "Remove this junk"
//    }
//    // MARK: - Seque
//    // transition
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "showItem"?:
//            if let row = tableView.indexPathForSelectedRow?.row {
//                let item = itemStore.allItems[row]
//                let detailViewController = segue.destination as! DetailViewController
//                detailViewController.item = item
//                detailViewController.imageStore = imageStore
//            }
//        default:
//            preconditionFailure("Unexpected segue identifier.")
//        }
//    }
//    
//    // MARK: - View Life Cycle
//    // view did load
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 65
//        
//    }
//    // view will appear
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        tableView.reloadData()
//    }
//    
}
