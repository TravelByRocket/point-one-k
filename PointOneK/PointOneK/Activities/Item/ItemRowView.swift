//
//  ItemRowView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

// swiftlint:disable comment_spacing

// import SwiftUI

// MOVED TO FUNCTION DUE TO SWIFTDATA CRASH
//
// struct ItemRowView: View {
//    let item: Item
//
//    var body: some View {
//        HStack {
//            Text(item.itemTitle)
//                .lineLimit(1)
//
//            Spacer()
//
//            ForEach(item.project?.projectQualities ?? []) { quality in
//                InfoPill(
//                    letter: quality.qualityIndicatorCharacter,
//                    level: quality.score(for: item)?.value ?? 0
//                )
//            }
//        }
//        .listRowBackground(
//            BackgroundBarView(
//                value: item.scoreTotal,
//                max: item.project?.scorePossible ?? 0
//            )
//        )
//    }
// }
//
// #Preview {
//    NavigationView {
//        List {
//            ItemRowView(item: Item.example)
//            ItemRowView(item: Item.example)
//            ItemRowView(item: Item.example)
//        }
//    }
// }
