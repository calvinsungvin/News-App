//
//  ViewModel.swift
//  News App
//
//  Created by Calvin Sung on 2021/7/16.
//

import Foundation

class viewModel {
    let title: String
    let subtitle: String?
    let newsImage: URL?
    var imageData: Data? = nil
    
    init(title: String, subtitle: String?, newsImage: URL?){
        self.title = title
        self.subtitle = subtitle
        self.newsImage = newsImage
    }
}
