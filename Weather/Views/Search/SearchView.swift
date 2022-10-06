//
//  SearchView.swift
//  Weather
//
//  Created by Tomas Torres on 10/5/22.
//

import SwiftUI


struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @State var searchQuery: String = ""
    @FocusState var searchFocus: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    searchBarView()
                        .padding()
                    
                    ScrollView {
                        VStack {
                            ForEach(viewModel.cities) { city in
                                NavigationLink(destination: WeatherView(viewModel: WeatherViewModel(latitude: city.latitude, longitude: city.longitude))) {
                                    cityResultView(city)
                                }
                            }
                        }
                    }
                }
                
                switch viewModel.loadingState {
                case .loading:
                    ProgressView()
                case .empty(let badSearchQuery):
                    Text("Oops. We couldn't find any cities with the name **\(badSearchQuery)**")
                        .font(.title2)
                case .failed:
                    Text("Something went wrong...")
                        .font(.title2)
                    
                case .loaded:
                    EmptyView()
                case .none:
                    VStack {
                        HStack {
                            Image(systemName: "cloud.sun")
                                .font(.system(size: 50))
                        }
                        .padding(.bottom, 30)
                        
                        Text("Search for the weather in your favorite cities.")
                            .font(.title2)
                        
                        Button {
                            searchFocus = true
                        } label: {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Search")
                            }
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(25)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    func searchBarView() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search city", text: $searchQuery)
                .onSubmit {
                    if !searchQuery.isEmpty {
                        Task {
                            await viewModel.searchForCity(with: searchQuery)
                        }
                    }
                }
                .focused($searchFocus)
            if searchQuery.count > 0 {
                Image(systemName: "xmark.circle")
                    .onTapGesture {
                        searchQuery = ""
                        viewModel.clearCities()
                        viewModel.loadingState = .none
                    }
            }
        }
    }
    
    func cityResultView(_ city: City) -> some View {
        HStack {
            Text("\(city.name), \(city.state)")
                .font(.title)
                .lineLimit(1)
            Spacer()
        }
        .padding()
    }
}
