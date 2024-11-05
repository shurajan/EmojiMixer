//
//  EmojiMixesViewModel.swift
//  EmojiMixer
//
//  Created by Alexander Bralnin on 05.11.2024.
//

final class EmojiMixesViewModel {
    private(set) var emojiMixes: [EmojiMixViewModel] = [] {
        didSet {
            emojiMixesBinding?(emojiMixes)
        }
    }

    private let factory = EmojiMixFactory()
    private let emojiMixStore = EmojiMixStore()
    
    var emojiMixesBinding: Binding<[EmojiMixViewModel]>?
    
    init() throws {
        emojiMixStore.delegate = self
        fetchEmojiMixes()
    }
    
    static func transform(id: String, from emojiMix: EmojiMix ) -> EmojiMixViewModel {
        return EmojiMixViewModel(id: id, emojis: emojiMix.emojis, backgroundColor: emojiMix.backgroundColor)
    }
    
    func addEmojiMix() {
        let mix = factory.createEmojiMix()
        try? emojiMixStore.addNewEmojiMix(mix)
    }
    
    func deleteAll() {
        try? emojiMixStore.deleteAll()
    }
    
    private func fetchEmojiMixes() {
        do {
            self.emojiMixes = try emojiMixStore.fetchEmojiMixes()
                .enumerated()
                .compactMap{(index, item) in
                    EmojiMixesViewModel.transform(id: "\(index)", from: item)
                }
        } catch {
            print("failed to load emojis from store")
        }
    }
}

extension EmojiMixesViewModel: EmojiMixStoreDelegate {
    func storeDidUpdate() {
        fetchEmojiMixes()
    }
}
