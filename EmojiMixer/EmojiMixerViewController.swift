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
    
    private lazy var undoButton: UIButton = {
        let button = UIButton()

        button.setTitle("Undo", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.red, for: .highlighted)
        
        button.accessibilityIdentifier = "undoButton"
        button.addTarget(self, action: #selector(undoButtonTapped(_:)), for: .touchUpInside)
        
        constraints.append(contentsOf: [
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
        ])
        return button
    }()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let availableEmojis = [ "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏",
                           "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆",
                           "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅",
                           "🍄"]
    
    private var emojis = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawSelf()
    }
    
    private func drawSelf() {
        addView(control: plusButton)
        addView(control: undoButton)
        addView(control: collectionView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: undoButton)
        
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
    
    @IBAction private func undoButtonTapped(_ sender: UIButton) {
        if emojis.count == 0 {return}
        let index = emojis.count-1
        emojis.removeLast()
        
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    @IBAction private func plusButtonTapped(_ sender: UIButton) {
        let emoji = availableEmojis[Int.random(in: 0..<availableEmojis.count)]
        emojis.append(emoji)
        
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [IndexPath(row: emojis.count-1, section: 0)])
        }
    }
}

extension EmojiMixerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiMixerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = emojis[indexPath.row]
        return cell
    }
    
}

extension EmojiMixerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // 1
        return CGSize(width: collectionView.bounds.width / 2, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
