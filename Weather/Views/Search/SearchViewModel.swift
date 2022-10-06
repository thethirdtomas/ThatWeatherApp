//
//  SearchViewModel.swift
//  Weather
//
//  Created by Tomas Torres on 10/5/22.
//

import Foundation

class SearchViewModel: ObservableObject {
    enum LoadingState: Equatable {
        case none
        case failed
        case loaded
        case loading
        case empty(String)
    }
    
    @Published var loadingState: LoadingState = .none
    @Published private(set) var cities: [City] = []
    private let network: Network
    
    init(network: Network = RequestManager.shared) {
        self.network = network
    }
}

// MARK: - Action
extension SearchViewModel {
    func clearCities() {
        cities.removeAll()
    }
}

// MARK: - Network
extension SearchViewModel {
    func searchForCity(with searchQuery: String) async {
        await MainActor.run {
            loadingState = .loading
        }

        let result: Result<[City], NetworkError> = await network.send(.citySearch(for: searchQuery))
        
        await MainActor.run {
            switch result {
            case .success(let data):
                if data.isEmpty {
                    self.loadingState = .empty(searchQuery)
                } else {
                    self.cities = data
                    self.loadingState = .loaded
                }
                
            case .failure(let error):
                print(error)
                self.loadingState = .failed
            }
        }
    }
}
