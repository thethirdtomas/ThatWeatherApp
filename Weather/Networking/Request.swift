//
//  Request.swift
//  Weather
//
//  Created by Tomas Torres on 10/4/22.
//

import Foundation

// All the API services used by the app
// Only one in this case
enum APIService {
    case openWeatherMap
    
    var baseURL: String {
        switch self {
        case .openWeatherMap:
            return "https://api.openweathermap.org"
        }
    }
    
    var apiKey: String {
        switch self {
        case .openWeatherMap:
            return AppEnvironment.getSecretValueFor(key: "openweathermap") as String? ?? ""
        }
    }
}

enum Request {
    case weather(latitude: Double, longitude: Double)
    case citySearch(for: String)
    
    private var service: APIService {
        switch self {
        case .weather, .citySearch:
            return .openWeatherMap
        }
    }
    
    private var method: URLRequest.HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    private var path: String {
        var path: String
        switch self {
        case .weather:
            path = "data/2.5/weather"
        case .citySearch:
            path = "geo/1.0/direct"
        }
        
        guard !params.isEmpty else { return path }
        
        let parameters = params.map { "\($0)=\($1)" }.joined(separator: "&")
        return [path, parameters].joined(separator: "?")
    }
    
    private var params: [String: String] {
        var params = [String: String]()
        switch self {
        case .weather(let lat, let lon):
            params["units"] = "imperial"
            params["lat"] = "\(lat)"
            params["lon"] = "\(lon)"
            params["appid"] = service.apiKey
        case .citySearch(let city):
            params["q"] = city.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
            params["limit"] = "10"
            params["appid"] = service.apiKey
        }
        
        return params
    }
    
    private var urlString: String {
        return [service.baseURL, path].joined(separator: "/")
    }
    
    var urlRequest: URLRequest {
        guard let url = URL(string: urlString) else {
            fatalError("Unable to create url from \(urlString)")
        }
        
        var request = URLRequest(url: url)
        request.method = method
        return request
    }
}


extension URLRequest {
    enum HTTPMethod: String, CaseIterable {
        case options = "OPTIONS"
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case trace = "TRACE"
        case connect = "CONNECT"
    }

    var method: HTTPMethod? {
        get {
            guard let httpMethod = httpMethod else { return nil }
            return HTTPMethod(rawValue: httpMethod)
        }
        set {
            httpMethod = newValue?.rawValue
        }
    }
}
