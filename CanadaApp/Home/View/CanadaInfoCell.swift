//
//  CanadaInfoCell.swift
//  CanadaApp
//
//  Created by CVN on 07/02/21.
//

import UIKit

/**
 *  A custom `UITableViewCell` that displays the details about canada.
 *
 *  - seeAlso: `thumpImageView`
 *  - seeAlso: `titleLabel`
 *  - seeAlso: `descriptionLabel`
 */
class CanadaInfoCell: UITableViewCell {
    static let reuseId = String(describing: CanadaInfoCell.self)
    
    /// `UIImageView` represents the icon imageview holder.
    let thumpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// `UILabel` represents the title about the detail.
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        return label
    }()
    
    /// `UILabel` represents the description detail.
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    /// Initializer of cell.
    /// - Parameters:
    ///   - style: `CellStyle` of this tableViewCell.
    ///   - reuseIdentifier: `String` represents the reuse identifier.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupImageView()
        setupTitleLabel()
        setupDescriptionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Prepares the icon imageview.
    func setupImageView() {
        addSubview(thumpImageView)
        thumpImageView.backgroundColor = .lightGray
        thumpImageView.setupAnchors(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: 0),
            size: .init(width: 50, height: 50)
        )
        thumpImageView.layer.cornerRadius = 25
        thumpImageView.image = UIImage(named: "placeholder")
    }
    
    /// Prepares the title label.
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.setupAnchors(
            top: thumpImageView.topAnchor,
            trailing: self.trailingAnchor,
            leading: thumpImageView.trailingAnchor,
            padding: .init(top: 0, left: 15, bottom: 0, right: 10),
            size: .init(width: 0, height: 20)
        )
    }
    
    /// Prepares the description label.
    func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.setupAnchors(
            top: titleLabel.bottomAnchor,
            bottom: self.bottomAnchor,
            trailing: titleLabel.trailingAnchor,
            leading: titleLabel.leadingAnchor,
            padding: .init(top: 5, left: 0, bottom: 30, right: 0)
        )
    }
    
    /// `CanadaDetail` represents the feed data of cell.
    var canadaDetail: CanadaDetail? {
        didSet {
            self.thumpImageView.getImage(from: canadaDetail?.imageHref)
            self.titleLabel.text = canadaDetail?.title
            self.descriptionLabel.text = canadaDetail?.rowDescription
        }
    }
}
