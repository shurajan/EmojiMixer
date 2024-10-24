//
//  ViewController.swift
//  EmojiMixer
//
//  Created by Alexander Bralnin on 09.10.2024.
//

import UIKit

class EmojiMixerViewController: UIViewController  {
    //MARK: - UI components
    private var constraints = [NSLayoutConstraint]()
    private let factory = EmojiMixFactory()
    private let emojiMixStore = EmojiMixStore()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: UIControl.State.normal)
        button.accessibilityIdentifier = "plusButton"
        button.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
        
        constraints.append(contentsOf: [
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
        ])
        return button
    }()
    
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    
    private var visibleEmojiMixes = [EmojiMix]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawSelf()
        try? visibleEmojiMixes = fetchEmojiMixes()
    }
    
    private func drawSelf() {
        addView(control: plusButton)
        addView(control: collectionView)
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
        
        constraints.append(contentsOf: [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.register(EmojiMixerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        addAndActivateConstraints(from: constraints)
    }
    
    final func addView(control newControl: UIView) {
        newControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newControl)
    }
    
    final func addAndActivateConstraints(from controlConstraints:[NSLayoutConstraint] = []) {
        constraints.append(contentsOf: controlConstraints)
        NSLayoutConstraint.activate(constraints)
    }
    
    private func fetchEmojiMixes() throws -> [EmojiMix] {
        try emojiMixStore.fetchEmojiMixes()
    }
    
    @IBAction private func plusButtonTapped(_ sender: UIButton) {
        
        let mix = factory.createEmojiMix()
        
        try? emojiMixStore.addNewEmojiMix(mix)
        
        try? visibleEmojiMixes = fetchEmojiMixes()
        
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [IndexPath(row: visibleEmojiMixes.count-1, section: 0)])
        }
    }
}

extension EmojiMixerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleEmojiMixes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiMixerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = visibleEmojiMixes[indexPath.row].emojis
        cell.backgroundColor = visibleEmojiMixes[indexPath.row].backgroundColor
        cell.layer.cornerRadius = 8
        return cell
    }
    
}

extension EmojiMixerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let totalSpacing = collectionView.contentInset.left + collectionView.contentInset.right + 10 // Между ячейками
        let width = (collectionViewWidth - totalSpacing) / 2
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
