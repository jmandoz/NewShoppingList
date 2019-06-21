//
//  NewShoppingList+Convenience.swift
//  NewShoppingList
//
//  Created by Jason Mandozzi on 6/21/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation

import CoreData

extension ShoppingList {
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
    }
}
