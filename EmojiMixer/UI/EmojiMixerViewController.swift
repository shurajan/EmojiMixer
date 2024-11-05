//
//  ViewController.swift
//  EmojiMixer
//
//  Created by Alexander Bralnin on 09.10.2024.
//

import UIKit

class EmojiMixerViewController: UIViewController  {
    private var viewModel: EmojiMixesViewModel?
    
    //MARK: - UI components
    private var constraints = [NSLayoutConstraint]()
        
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    private var visibleEmojiMixes = [EmojiMix]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawSelf()
        do {
            viewModel = try EmojiMixesViewModel()
        } catch {
            print("\(error)")
        }
        
        viewModel?.emojiMixesBinding = { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    private func drawSelf() {
        
        if let navBar = navigationController?.navigationBar {
            let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
            navBar.topItem?.setRightBarButton(rightButton, animated: false)
            
            let leftButton = UIBarButtonItem(
                title: NSLocalizedString("Delete All", comment: ""),
                style: .plain,
                target: self,
                action: #selector(deleteAll)
            )
            navBar.topItem?.setLeftBarButton(leftButton, animated: false)
            
        }
        addView(control: collectionView)
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
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
    
    @IBAction private func plusButtonTapped(_ sender: UIButton) {
        viewModel?.addEmojiMix()
    }
    
    @IBAction private func deleteAll(_ sender: UIButton) {
        viewModel?.deleteAll()
    }
}

extension EmojiMixerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.emojiMixes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiMixerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.viewModel = viewModel?.emojiMixes[indexPath.row]
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
