import Foundation


//The class for the tic tac toe game
class TicTacToe {
    private var board: [[String]] = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
    private var currentPlayer: String = "X"
    
    // Funct to print board, (its like a nested for loop_
    func printBoard() {
        for row in board {
            print(row.joined(separator: " | "))
        }
        print("---------")
    }
    
    //This function computes the make move (also
    func makeMove(row: Int, col: Int) -> Bool {
        if board[row][col] == " " {
            board[row][col] = currentPlayer
            currentPlayer = (currentPlayer == "X") ? "O" : "X"
            return true
        }
        return false
    }
    
    // Simple funcion that checks all possible winning combinations
    //Its a static set of copmbinations
    func checkWin() -> String? {
        let lines = board +
            [[board[0][0], board[1][0], board[2][0]],
             [board[0][1], board[1][1], board[2][1]],
             [board[0][2], board[1][2], board[2][2]],
             [board[0][0], board[1][1], board[2][2]],
             [board[0][2], board[1][1], board[2][0]]]
        
        //This part is the actualy win checking part
        for line in lines {
            if line[0] != " " && line[0] == line[1] && line[1] == line[2] {
                return line[0] // Ret winner player (either X or O)
            }
        }
        return nil
    }
}

// Ex
let game = TicTacToe()
game.printBoard()
game.makeMove(row: 0, col: 0)
game.printBoard()

