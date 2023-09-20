//
//  CustomTextField.swift
//  RecipeManager
//
//  Created by Guido Roos on 17/09/2023.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> Void = { _ in }
    var commit: () -> Void = {}

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .padding(.leading, Spacing.spacing1)
            }
        
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .padding(.leading, Spacing.spacing1)
        }
    }
}
