//
//  MessageModel.swift
//  Test
//
//  Created by Kseniya Zharikova on 25/10/23.
//

import Foundation

struct MessageModel {
    let text: String
}

struct Page {
    let pageNumber: Int
    var items: [MessageModel]
}
