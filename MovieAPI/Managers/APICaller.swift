//
//  APICaller.swift
//  NetflixClone
//
//  Created by mike liu on 2023/5/28.
//

import Foundation

struct Constants {
    static let API_KEY = "38e3c9b9c436e016a8246824bea9d7f1"
    static let baseURL = "https://api.themoviedb.org/3"
    static let YoutubeAPI_KEY = "AIzaSyCGeVBKp36qh-0Muw_pA51b5FKJ42qi4YI"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedTogetData
}


class APICaller {
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            
            let decoder = JSONDecoder()
            
            do {
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
            
        }
        
        task.resume()
    }
    
    func getUpcomingMovie(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/movie/upcoming?api_key=\(Constants.API_KEY)&languange=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            
            let decoder = JSONDecoder()
            
            do {
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                print(completion(.success(results.results)))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/movie/popular?api_key=\(Constants.API_KEY)&languange=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
            
            do {
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/movie/popular?api_key=\(Constants.API_KEY)&languange=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
            
            do {
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
        
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/discover/movie?api_key=\(Constants.API_KEY)&include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_watch_monetization_types=flatrate") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
            do {
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.baseURL)/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
            do {
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string:"\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
            
            do {
                let results = try decoder.decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
                print(results)
            } catch {
                completion(.failure(error))
                print(error)
            }
        }
        task.resume()
    }
    
    
}

// api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_watch_monetization_types=flatrate
// "\(Constants.baseURL)/movie/popular?api_key=\(Constants.API_KEY)&languange=en-US&page=1"
