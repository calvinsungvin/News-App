//
//  NewsTableViewCell.swift
//  News App
//
//  Created by Calvin Sung on 2021/7/16.
//

import UIKit



class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        return titleLabel
    }()
    
    let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = .systemFont(ofSize: 18, weight: .regular)
        return subtitleLabel
    }()
    
    var newsImage: UIImageView = {
       let newsImage = UIImageView()
        newsImage.layer.cornerRadius = 6
        newsImage.layer.masksToBounds = true
        newsImage.clipsToBounds = true
        newsImage.contentMode = .scaleAspectFill
       return newsImage
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 170, height: 70)
        subtitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 170, height: contentView.frame.size.height/2)
        newsImage.frame = CGRect(x: contentView.frame.size.width - 150, y: 5, width: 100, height: 130)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImage)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        newsImage.image = nil
    }
    
    func configure(with viewModel: viewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        if let data = viewModel.imageData {
            self.newsImage.image = UIImage(data: data)
        } else if let url = viewModel.newsImage {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard data != nil && error == nil else {return}
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self.newsImage.image = UIImage(data: data!)
                }
            }
            task.resume()
        }
    }
}
