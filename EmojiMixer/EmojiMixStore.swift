//import UIKit
import CoreData
import UIKit

enum EmojiMixStoreError: Error {
    case decodingErrorInvalidEmojies
    case decodingErrorInvalidColorHex
}

final class EmojiMixStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchEmojiMixes() throws -> [EmojiMix] {
        let fetchRequest = EmojiMixCoreData.fetchRequest()
        let emojiMixesFromCoreData = try context.fetch(fetchRequest)
        return try emojiMixesFromCoreData.map { try self.emojiMix(from: $0) }
    }
    
    func addNewEmojiMix(_ emojiMix: EmojiMix) throws {
        let emojiMixCoreData = EmojiMixCoreData(context: context)
        updateExistingEmojiMix(emojiMixCoreData, with: emojiMix)
        try context.save()
    }
    
    func updateExistingEmojiMix(_ emojiMixCorData: EmojiMixCoreData, with mix: EmojiMix) {
        emojiMixCorData.emojis = mix.emojis
        emojiMixCorData.colorHex = mix.backgroundColor.toHexString()
    }
    
    func emojiMix(from emojiMixCorData: EmojiMixCoreData) throws -> EmojiMix {
        guard let emojies = emojiMixCorData.emojis else {
            throw EmojiMixStoreError.decodingErrorInvalidEmojies
        }
        guard let colorHex = emojiMixCorData.colorHex,
               let color = UIColor(hex: colorHex)
        else {
            throw EmojiMixStoreError.decodingErrorInvalidEmojies
        }
        
        
        return EmojiMix(
            emojis: emojies,
            backgroundColor: color
        )
    }
    
}
