//
//  EmojiMixerViewModel.swift
//  EmojiMixer
//
//  Created by Alexander Bralnin on 05.11.2024.
//

import UIKit

typealias Binding<T> = (T) -> Void

final class EmojiMixViewModel: Identifiable {
    let id: String
    private let emojis: String
    private let backgroundColor: UIColor
    
    var onEmojiChanged: Binding<String>? {
        didSet {
            onEmojiChanged?(emojis)
        }
    }
    
    var onBackgroundColorChanged: Binding<UIColor>? {
        didSet {
            onBackgroundColorChanged?(backgroundColor)
        }
    }
    
    init(id: String, emojis: String, backgroundColor: UIColor){
        self.id = id
        self.emojis = emojis
        self.backgroundColor = backgroundColor
    }
        
}
