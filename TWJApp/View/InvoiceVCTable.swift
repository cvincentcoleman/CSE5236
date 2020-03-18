//
//  InvoiceVCTable.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 3/4/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit

class InvoiceVCTable: UITableViewController {
    
//    wires the invoiceItemStore to the table view
    var itemStore =  invoiceItemStore()


    
    override func tableView(_ tableView: UITableView,
            numberOfRowsInSection section: Int) -> Int {
        return itemStore.allInvoices.count
    }
}
