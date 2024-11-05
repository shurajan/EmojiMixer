//import UIKit
import CoreData
import UIKit

enum EmojiMixStoreError: Error {
    case decodingErrorInvalidEmojies
    case decodingErrorInvalidColorHex
}

struct EmojiMixStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

protocol EmojiMixStoreDelegate: AnyObject {
    func storeDidUpdate()
}


final class EmojiMixStore: NSObject {
    private let context: NSManagedObjectContext
    weak var delegate: EmojiMixStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<EmojiMixCoreData> = {
        
        let fetchRequest = NSFetchRequest<EmojiMixCoreData>(entityName: "EmojiMixCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \EmojiMixCoreData.emojis, ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
   
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchEmojiMixes() throws -> [EmojiMix] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let emojiMixes = try? objects.map({ try self.emojiMix(from: $0) })
        else { return [] }
        return emojiMixes
    }
    
    func addNewEmojiMix(_ emojiMix: EmojiMix) throws {
        let emojiMixCoreData = EmojiMixCoreData(context: context)
        updateExistingEmojiMix(emojiMixCoreData, with: emojiMix)
        try context.save()
    }
    
    func deleteAll() throws {
        let objects = fetchedResultsController.fetchedObjects ?? []
        for object in objects {
            context.delete(object)
        }
        try context.save()
    }
    
    func updateExistingEmojiMix(_ emojiMixCoreData: EmojiMixCoreData, with mix: EmojiMix) {
        emojiMixCoreData.emojis = mix.emojis
        emojiMixCoreData.colorHex = mix.backgroundColor.toHexString()
    }
    
    func emojiMix(from emojiMixCoreData: EmojiMixCoreData) throws -> EmojiMix {
        guard let emojies = emojiMixCoreData.emojis else {
            throw EmojiMixStoreError.decodingErrorInvalidEmojies
        }
        guard let colorHex = emojiMixCoreData.colorHex,
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


extension EmojiMixStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
   
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath {
                insertedIndexes?.insert(newIndexPath.item)
            }
            
        case .delete:
            if let newIndexPath {
                deletedIndexes?.insert(newIndexPath.item)
            }
        case .update:
            print("Unsuported")
        case .move:
            print("Unsuported")
        @unknown default:
            fatalError("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate()
    }
    
}
