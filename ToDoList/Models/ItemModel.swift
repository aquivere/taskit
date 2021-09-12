//
//  ItemModel.swift
//  ToDoList
//
//  Created by Borborick Zhu, Vivian Wang and Brianna Kim
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
    
    // toggle completion of item
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: !isCompleted, dateCompleted: dateCompleted, date: date, recurrence: recurrence)
    }
    // update due date and reset as false of repeating item
    func updateRecCompletion(date: Date) -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: false, dateCompleted: dateCompleted, date: date, recurrence: recurrence)
    }
    // update due date of repeating item, does not reset completion
    func updateRecDate(date: Date) -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: isCompleted, dateCompleted: dateCompleted, date: date, recurrence: recurrence)
    }
}

