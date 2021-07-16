//
//  APICaller.swift
//  News App
//
//  Created by Calvin Sung on 2021/7/16.
//

import Foundation

class APICallers {
    
    static let shared = APICallers()
    
    struct Constants {
        static let newsUrl = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=d5314752787b415aa5df94f6b7bb4ba1")
        static let searchUrl = "https://newsapi.org/v2/everything?apiKey=d5314752787b415aa5df94f6b7bb4ba1&q="
    }
    
    func getNewsUrl(completion: @escaping(Result<[Article], Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: Constants.newsUrl!) { (data, _, error) in
            guard error == nil && data != nil else {return}
            do {
                let result = try JSONDecoder().decode(APIResponse.self, from: data!)
                print(result.articles.count)
                completion(.success(result.articles))
            }
            catch {
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func search(query: String, completion: @escaping(Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        
        let task = URLSession.shared.dataTask(with: URL(string: Constants.searchUrl + query)!) { (data, _, error) in
            guard error == nil && data != nil else {return}
            do {
                let result = try JSONDecoder().decode(APIResponse.self, from: data!)
                print(result.articles.count)
                completion(.success(result.articles))
            }
            catch {
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}


