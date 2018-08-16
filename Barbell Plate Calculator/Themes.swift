//
//  Styles.swift
//  ThemePractice
//
//  Created by Robert Oneill on 05/08/2018.
//  Copyright © 2018 oneilldvlpr. All rights reserved.
//


import UIKit

let SelectedThemeKey = "SelectedTheme"

enum Theme: Int {
    
    case Default, Dark, Graphical
    
    var tintColour: UIColor {
        switch self {
        case .Default:
            return .green
        case .Dark:
            return .red
        case .Graphical:
            return .black
        }
    }
    
    var mainColour: UIColor {
        switch self {
        case .Default:
            return .white
        case .Dark:
            return .black
        case .Graphical:
            return .yellow
        }
    }
}

struct ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .Default
            }
        }
    
    static func applyCurrentTheme() {
        applyTheme(currentTheme())
    }
    
    static func applyTheme(_ theme: Theme) {
        
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
    
        sharedApplication.delegate?.window??.tintColor = theme.tintColour
        
        UINavigationBar.appearance().tintColor = theme.tintColour
        UINavigationBar.appearance().barTintColor = theme.mainColour
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: theme.tintColour]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ThemeUpdated"), object: theme)
        }
    
}
