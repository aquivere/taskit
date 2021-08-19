//
//  ListViewModel.swift
//  ToDoList
//
//  Created by Borborick Zhu on 9/7/21.
//

import Foundation

/*
 
CRUD FUNCTIONS
 create
 read
 update
 delete
 
*/



class ListViewModel: ObservableObject {
    
    @Published var items: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }
    
    @Published var recItems: [ItemModel] = [] {
        didSet {
            saveRecItems()
        }
    }
    
    let itemsKey: String = "items_list"
    let recItemsKey: String = "rec_items_list"
    
    init() {
        
    }
    
    // for regular items
    
    func getItems() {
        guard let data = UserDefaults.standard.data(forKey: itemsKey) else {return}
        guard let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)  else {return}
        self.items = savedItems
    }
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
        
    }
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    func addItem(title:String, dateCompleted: String, date: Date) {
        let newItem = ItemModel(title: title, isCompleted: false, dateCompleted: dateCompleted, date: date, recurrence: "")
        items.append(newItem)
    }
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
        }
    }
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
    
    // for recurring items
    
    func getRecItems() {
        guard let data = UserDefaults.standard.data(forKey: itemsKey) else {return}
        guard let savedRecItems = try? JSONDecoder().decode([ItemModel].self, from: data)  else {return}
        self.recItems = savedRecItems
        
    }
    func deleteRecItem(indexSet: IndexSet) {
        recItems.remove(atOffsets: indexSet)
        
    }
    func moveRecItem(from: IndexSet, to: Int) {
        recItems.move(fromOffsets: from, toOffset: to)
        
    }
    
    func addRecItem(title:String, dateCompleted: String, date: Date, recurrence: String) {
        let newRecItem = ItemModel(title: title, isCompleted: false, dateCompleted: dateCompleted, date: date, recurrence: recurrence)
        recItems.append(newRecItem)
        if let index = recItems.firstIndex(where: { $0.id == newRecItem.id }) {
            
           if newRecItem.recurrence == "Every Day" {
            // TODO: need to make it repeat AFTER the set date not right when it is saved
            // used to reset the to-do to incomplete after saved
                Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                    self.recItems[index] = newRecItem.resetCompletion()
                }
            }
        }
        
    }
    
    func updateRecItem(recItem: ItemModel) {
        if let index = recItems.firstIndex(where: { $0.id == recItem.id }) {
            recItems[index] = recItem.updateCompletion()
            // TODO: turn off timer if needed
        }
        
    }
    func saveRecItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
}

