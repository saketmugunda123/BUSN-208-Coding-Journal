//
//  SquareView.swift
//  TicTacToev1
//
//  Created by Rajiv Mukherjee on 3/4/24.
//

import SwiftUI

struct SquareView: View {
    
    @EnvironmentObject var game: GameService
    let index: Int
    
    var body: some View {
        Button{
            game.makeMove(at: index)
        } label: {
            game.gameBoard[index].image
                .resizable()
                .frame(width:100, height:100)
        }
        .disabled(game.gameBoard[index].player != nil)
        .buttonStyle(.bordered)
        .foregroundColor(.primary)
    }
}

#Preview {
    //index set to 1 just for previewing 1 tile
    SquareView(index: 1)
        .environmentObject(GameService())
}
