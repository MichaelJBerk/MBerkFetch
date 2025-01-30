//
//  RecipeListItem.swift
//  MBerkFetch
//
//  Created by Michael Berk on 1/29/25.
//

import SwiftUI

struct RecipeListItem: View {
	@ScaledMetric(relativeTo: .body) var height = 75
	@Environment(NetworkManager.self) var networkManager
	var recipe: FetchRecipe
	
    var body: some View {
		HStack {
			imageView
			Spacer()
			VStack(alignment: .trailing) {
				Text(recipe.name)
					.font(.headline)
				Text(recipe.cuisine)
					.font(.subheadline)
			}
		}
		.frame(height: height)
    }
	
	var imageView: some View {
		Group {
			if ProcessInfo.processInfo.isPreview {
				previewImage
			} else if let imageURL = recipe.photoUrlSmall {
				RemoteImage(imageURL: imageURL)
			}
		}
			.aspectRatio(contentMode: .fit)
			.clipShape(RoundedRectangle(cornerRadius: 10))
	}
	
	var previewImage: some View {
		Image("small")
			.resizable()
	}
}

#Preview(traits: .sizeThatFitsLayout) {
	RecipeListItem(recipe: .previewRecipe)
		.padding()
		.frame(width: 400)
		.environment(NetworkManager())
}
