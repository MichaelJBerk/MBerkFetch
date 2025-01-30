//
//  ContentView.swift
//  MBerkFetch
//
//  Created by Michael Berk on 1/29/25.
//

import SwiftUI

struct ContentView: View {
	
	@Environment(NetworkManager.self) var networkManager
	@State var urlToLoad: NetworkManager.URLToLoad = .normal
	@State var recipes: [FetchRecipe] = []
	@State var selectedRecipe: FetchRecipe? = nil
	@State var loading = false
	
	enum ListDisplayState {
		case list
		case loading
		case empty
		case error
	}
	
	@State var listDisplayState: ListDisplayState = .loading
	
    var body: some View {
		NavigationStack {
			Group {
				switch listDisplayState {
				case .list:
					List(recipes) {recipe in
						item(for: recipe)
					}
				case .loading:
					ProgressView()
						.progressViewStyle(.circular)
				case .empty:
					ContentUnavailableView("No Recipes Available", systemImage: "text.page.slash")
				case .error:
					ContentUnavailableView("Data Error", systemImage: "exclamationmark.square.fill")
				}
			}
			.refreshable {
				await fetchData()
			}
			.navigationTitle("Recipes")
			.sheet(item: $selectedRecipe, content: { recipe in
				detail(for: recipe)
			})
			.toolbar {
				ToolbarItem {
					Picker("", selection: $urlToLoad, content: {
						Text("Normal").tag(NetworkManager.URLToLoad.normal)
						Text("Malformed").tag(NetworkManager.URLToLoad.malformed)
						Text("Empty").tag(NetworkManager.URLToLoad.empty)
					})
				}
			}
			.onChange(of: urlToLoad, { _, _ in
				Task {
					await fetchData()
				}
			})
		}
		.task {
			await fetchData()
		}
		
		
    }
	func detail(for recipe: FetchRecipe) -> some View {
		NavigationStack {
			RecipeView(recipe: recipe)
				
		}
	}
	
	func item(for recipe: FetchRecipe) -> some View {
		Button {
			selectedRecipe = recipe
		} label: {
			RecipeListItem(recipe: recipe)
				.foregroundStyle(.foreground)
		}
	}
	
	func fetchData() async {
		loading = true
		do {
			recipes = try await networkManager.fetchData(urlToLoad: urlToLoad)
			if recipes == [] {
				listDisplayState = .empty
			} else {
				listDisplayState = .list
			}
		} catch {
			print(error)
			listDisplayState = .error
		}
		loading = false
	}
}

#Preview {
	@Previewable @State var networkManager = NetworkManager()
	
	ContentView()
		.environment(networkManager)
}
