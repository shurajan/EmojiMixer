//
//  EmojiMixerCollectionViewCell.swift
//  EmojiMixer
//
//  Created by Alexander Bralnin on 09.10.2024.
//

import UIKit

class EmojiMixerCollectionViewCell: UICollectionViewCell {
    // Здесь будет код нашей ячейки
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                                    ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
