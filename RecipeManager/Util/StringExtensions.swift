//
//  StringExtensinos.swift
//  RecipeManager
//
//  Created by Guido Roos on 13/09/2023.
//

extension String {
    func splitStringByDotWithSpace() -> [String] {
        let stringWithoutNewline = replacingOccurrences(of: "\n", with: ".")
            var substrings = stringWithoutNewline.components(separatedBy: ".")
            
        
        if let lastSubstring = substrings.last {
            substrings[substrings.count - 1] = lastSubstring.replacingOccurrences(of: ".", with: "")
        }
        
        return substrings.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}

extension [String] {
    func zipWithStringList(_ list: [String]) -> [String] {
        let zipped = zip(self, list)
        let result = zipped.map { "\($0) (\($1))" }
        return result
    }
}

