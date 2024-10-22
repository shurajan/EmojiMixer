//
//  EmojiMixStore.swift
//  EmojiMixer
//
//  Created by Alexander Bralnin on 22.10.2024.
//

import CoreData
import UIKit

final class EmojiMixStore {
    
    private final let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    convenience init(){
        self.init(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
    
    func addNewEmojiMix(_ emojiMix: EmojiMix) throws {
        let mix = EmojiMixCoreData(context: context)
        
        mix.emojis = emojiMix.emojis
        mix.colorHex = emojiMix.backgroundColor.toHexString()
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print(error)
            }
        }
    }
}
