//
//  invoiceItemStore.swift
//  TWJApp
//
//  Created by Charles Vincent Coleman on 3/4/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import UIKit

class invoiceItemStore {
    
    var allInvoices = [InvoiceItem]()
    
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
    
    //discardableResult means caller is free to ignor the results
    @discardableResult func createItem() -> InvoiceItem {
        
        //hardcoded to make TWJ input
        let newItem = InvoiceItem(amount: 100, team: "TWJ")

        allInvoices.append(newItem)

        return newItem
    }
    
    
}
