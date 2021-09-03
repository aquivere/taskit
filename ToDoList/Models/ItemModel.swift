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
    let recurrence: String
    
    init(id: String = UUID().uuidString, title: String, isCompleted: Bool, dateCompleted: String, date: Date, recurrence: String) {
        self.id = UUID().uuidString
        self.title = title
        self.isCompleted = isCompleted
        self.dateCompleted = dateCompleted
        self.date = date
        self.recurrence = recurrence
    }
    
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: !isCompleted, dateCompleted: dateCompleted, date: date, recurrence: recurrence)
    }
    
    func updateRecCompletion(date: Date) -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: false, dateCompleted: dateCompleted, date: date, recurrence: recurrence)
        
    }
    func updateRecDate(date: Date) -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: isCompleted, dateCompleted: dateCompleted, date: date, recurrence: recurrence)

    }
}

