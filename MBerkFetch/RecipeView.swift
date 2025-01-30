//
//  RecipeView.swift
//  MBerkFetch
//
//  Created by Michael Berk on 1/29/25.
//

import SwiftUI

struct RecipeView: View {
	
	@Environment(\.dismiss) var dismiss
	
	var recipe: FetchRecipe
	
    var body: some View {
		List {
			Section {
				if ProcessInfo.processInfo.isPreview {
					Image("small")
						.resizable()
				} else if let imageURL = recipe.photoUrlLarge {
					RemoteImage(imageURL: imageURL)
				}
			}
			LabeledContent("Cuisine") {
				Text(recipe.cuisine)
			}
			LabeledContent("Photo URL Large") {
				Text(recipe.photoUrlLarge?.absoluteString ?? "?")
			}
			LabeledContent("Photo URL Small") {
				Text(recipe.photoUrlSmall?.absoluteString ?? "?")
			}
			LabeledContent("UUID") {
				Text(recipe.uuid)
			}
			LabeledContent("Source URL") {
				Text(recipe.sourceUrl?.absoluteString ?? "?")
			}
			LabeledContent("Youtube URL") {
				Text(recipe.youtubeUrl?.absoluteString ?? "?")
			}
		}
		.navigationTitle(Text(recipe.name))
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem {
				Button("Done") {
					dismiss()
				}
			}
		}
    }
}

#Preview {
	NavigationStack {
		RecipeView(recipe: .previewRecipe)
	}
}
