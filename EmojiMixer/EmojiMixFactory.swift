//
//  EmojiMixFactory.swift
//  EmojiMixer
//
//  Created by Alexander Bralnin on 22.10.2024.
//

import UIKit

let availableEmojis = [ "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏",
                                "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆",
                                "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅",
                                "🍄"]

struct EmojiMix {
    let emojis: String
    let backgroundColor: UIColor
}

final class EmojiMixFactory {
 
    func createEmojiMix() -> EmojiMix {
        let mix = makeNewMix()
        let color = makeMixColor(from: mix)
        return EmojiMix(emojis: mix.joined(), backgroundColor: color)
    }
    
    private func makeNewMix() -> [String] {
        return [availableEmojis.randomElement()!,
                availableEmojis.randomElement()!,
                availableEmojis.randomElement()!]
    }
    
    private func makeMixColor(from emojis: [String]) -> UIColor {
        var byteArray = [UInt8]()
        for emoji in emojis {
            if let firstByte = emoji.data(using: .utf8)?.last {
                byteArray.append(firstByte)
                print(firstByte)
            }
        }
        
        let red = CGFloat(byteArray[0])/255
        let green = CGFloat(byteArray[1])/255
        let blue = CGFloat(byteArray[2])/255
        
        print("\(red) \(green) \(blue)")

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
