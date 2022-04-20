//
//  MySection.swift
//  ExCompositionalLayout
//
//  Created by Jake.K on 2022/04/20.
//

enum MySection {
  case first([FirstItem])
  case second([SecondItem])
  
  struct FirstItem {
    let value: String
  }
  struct SecondItem {
    let value: String
  }
}
