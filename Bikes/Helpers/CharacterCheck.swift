//
//  CharacterCheck.swift
//  Bikes
//
//  Created by Andy Geipel on 12/21/20.
//

import Foundation

class CharacterCheck {
    
    func entryCharacterCheck(entryToCheck: String) -> Bool {
        let entry = "^[A-Z0-9a-z]+$"
        let entryTest = NSPredicate(format: "SELF MATCHES %@", entry)
        return entryTest.evaluate(with: entryToCheck)
    }
    
}
