import Foundation
import Combine

class UserModel: ObservableObject {
    // Saves if user has already done tutorial/set-up
    @Published var isSetUp: Bool {
        didSet {
            UserDefaults.standard.set(isSetUp, forKey: "isSetUp")
        }
    }
    
    // Saves user's name
    @Published var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    
    // Saves if user has enabled dark mode
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
        
    init() {
        self.name = UserDefaults.standard.object(forKey: "name") as? String ?? ""
        self.isSetUp = UserDefaults.standard.object(forKey: "isSetUp") as? Bool ?? false
        self.isDarkMode = UserDefaults.standard.object(forKey: "isDarkMode") as? Bool ?? false
    }
}


