//
//  Models.swift
//  News App
//
//  Created by Calvin Sung on 2021/7/16.
//

import Foundation

class APIResponse: Codable {
    let articles: [Article]
}

class Article: Codable {
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
}
