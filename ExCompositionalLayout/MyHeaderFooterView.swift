//
//  MyHeaderFooterView.swift
//  ExCompositionalLayout
//
//  Created by Jake.K on 2022/04/20.
//

import UIKit

final class MyHeaderFooterView: UICollectionReusableView {
  private lazy var label: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(label)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .gray
    NSLayoutConstraint.activate([
      self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.label.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor),
      self.label.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.prepare(text: nil)
  }
  
  func prepare(text: String?, textColor: UIColor? = nil) {
    self.label.text = text
    guard textColor != nil else { return }
    self.label.textColor = textColor
  }
}
