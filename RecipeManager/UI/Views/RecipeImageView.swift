//
//  RecipeImageView.swift
//  RecipeManager
//
//  Created by Guido Roos on 15/09/2023.
//

import SwiftUI

public struct RecipeImage: View {
    let url: URL?
    let savedImage: Data?
    let stateColor: Color

    public var body: some View {
        if let imageData = savedImage,
           let uiImage = UIImage(data: imageData)
        {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: Dimensions.imageRadius))
                .frame(width: 60, height: 60)
        } else if let url = url {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: Dimensions.imageRadius))
                        .frame(width: 60, height: 60)

                } else if phase.error != nil {
                    ErrorImageView(color: stateColor)
                        .frame(width: 60, height: 60)
                } else {
                    ErrorImageView(color: stateColor)
                        .frame(width: 60, height: 60)
                }
            }
        } else {
            Image(systemName: "photo.on.rectangle")
                .foregroundColor(stateColor)
                .frame(width: 60, height: 60)
        }
    }
}
