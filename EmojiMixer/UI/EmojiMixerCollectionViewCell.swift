//
//  EmojiMixerCollectionViewCell.swift
//  EmojiMixer
//
//  Created by Alexander Bralnin on 09.10.2024.
//

import UIKit

class EmojiMixerCollectionViewCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    
    var viewModel: EmojiMixViewModel?  {
        didSet {
            viewModel?.onEmojiChanged = { [weak self] emojis in
                guard let self else { return }
                self.titleLabel.text = emojis
            }
            
            viewModel?.onBackgroundColorChanged = {[weak self] color in
                guard let self else { return }
                self.contentView.backgroundColor = color
            }
        }
    }
    
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
