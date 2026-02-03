//
//  MemorySection.swift
//  Stivo
//
//  Created by aisha alh on 16/08/1447 AH.
//

import Foundation
//
//  MemorySection.swift
//  DailyActionsApp
//
//  Memory section component with image gallery
//

import SwiftUI

struct MemorySection: View {
    let memories: [MemoryItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Memory")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.5))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(memories) { memory in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 150, height: 150)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray.opacity(0.5))
                            )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}
