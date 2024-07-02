//
//  String+Extension.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 2/7/24.
//

import Foundation

extension String {
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func generateRandomAlphanumeric() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        let numbers = "0123456789"
        let alphanumeric = letters + numbers
        let randomIndex = Int.random(in: 0..<alphanumeric.count)
        let randomCharacter = alphanumeric[alphanumeric.index(alphanumeric.startIndex, offsetBy: randomIndex)]
        return String(randomCharacter)
    }
}
