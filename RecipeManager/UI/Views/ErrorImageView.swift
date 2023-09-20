//
//  ErrorImageView.swift
//  RecipeManager
//
//  Created by Guido Roos on 12/09/2023.
//

import SwiftUI

struct ErrorImageView: View {
    let color: Color
    
    var body: some View {
        Image(systemName: "exclamationmark.triangle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
    }
}

struct ErrorImageView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorImageView(color: .black)
    }
}
