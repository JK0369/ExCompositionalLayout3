//
//  ViewController.swift
//  ExCompositionalLayout
//
//  Created by Jake.K on 2022/04/19.
//

import UIKit

final class ViewController: UIViewController {
  private lazy var collectionView: UICollectionView = {
    let layout = Self.getLayout()
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.interSectionSpacing = 16
    layout.configuration = config
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.isScrollEnabled = true
    view.showsHorizontalScrollIndicator = false
    view.showsVerticalScrollIndicator = true
    view.scrollIndicatorInsets = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 4)
    view.contentInset = .zero
    view.backgroundColor = .clear
    view.clipsToBounds = true
    view.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
    
    view.register(MyHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MyHeaderView")
    view.register(MyHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "MyFooterView")
    view.register(MyHeaderFooterView.self, forSupplementaryViewOfKind: "MyLeftView", withReuseIdentifier: "MyLeftView")
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  private let dataSource: [MySection] = [
    .first((1...10).map(String.init).map(MySection.FirstItem.init(value:))),
    .second((11...20).map(String.init).map(MySection.SecondItem.init(value:))),
  ]
  
  static func getLayout() -> UICollectionViewCompositionalLayout {
    UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
      switch section {
      case 0:
        let itemFractionalWidthFraction = 1.0 / 5.0 // horizontal 5개의 셀
        let groupFractionalHeightFraction = 1.0 / 3.0 // vertical 4개의 셀
        let itemInset: CGFloat = 2.5
        
        // Item
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(itemFractionalWidthFraction),
          heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(0.9),
          heightDimension: .fractionalHeight(groupFractionalHeightFraction)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
          leading: .flexible(0),
          top: nil,
          trailing: nil,
          bottom: nil
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        // header / footer
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerFooterSize,
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerFooterSize,
          elementKind: UICollectionView.elementKindSectionFooter,
          alignment: .bottom
        )
        let leftSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.1), heightDimension: .fractionalHeight(0.5))
        let left = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: leftSize,
          elementKind: "MyLeftView",
          alignment: .leading
        )
        
        section.boundarySupplementaryItems = [header, footer, left]
        return section
      default:
        let itemFractionalWidthFraction = 1.0 / 5.0 // horizontal 5개의 셀
        let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
        let itemInset: CGFloat = 2.5
        
        // Item
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(itemFractionalWidthFraction),
          heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(groupFractionalHeightFraction)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        return section
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.collectionView)
    NSLayoutConstraint.activate([
      self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
    ])
    self.collectionView.dataSource = self
  }
}

extension ViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    self.dataSource.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch self.dataSource[section] {
    case let .first(items):
      return items.count
    case let .second(items):
      return items.count
    }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
    switch self.dataSource[indexPath.section] {
    case let .first(items):
      cell.prepare(text: items[indexPath.item].value)
    case let .second(items):
      cell.prepare(text: items[indexPath.item].value)
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyHeaderView", for: indexPath) as! MyHeaderFooterView
      header.prepare(text: "헤더 타이틀")
      return header
    case UICollectionView.elementKindSectionFooter:
      let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyFooterView", for: indexPath) as! MyHeaderFooterView
      footer.prepare(text: "푸터 타이틀")
      return footer
    case "MyLeftView":
      let leftView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyLeftView", for: indexPath) as! MyHeaderFooterView
      leftView.backgroundColor = .gray.withAlphaComponent(0.3)
      leftView.prepare(text: "left 타이틀", textColor: .black)
      return leftView
    default:
      return UICollectionReusableView()
    }
  }
}
