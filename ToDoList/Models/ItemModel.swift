//
//  ItemModel.swift
//  ToDoList
//
//  Created by Borborick Zhu on 9/7/21.
//

import Foundation

struct ItemModel: Identifiable, Codable {
    var id: String = UUID().uuidString
    let title: String
    let isCompleted: Bool
    let dateCompleted: String
    let date: Date
    
    init(id: String = UUID().uuidString, title: String, isCompleted: Bool, dateCompleted: String, date: Date) {
        self.id = UUID().uuidString
        self.title = title
        self.isCompleted = isCompleted
        self.dateCompleted = dateCompleted
        self.date = date
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: !isCompleted, dateCompleted: dateCompleted, date: date)
    }
    
}

