import Foundation

// Check if a queen can be placed
func isSafe(board: [Int], row: Int, col: Int) -> Bool {
    for i in 0..<row {
        if board[i] == col || abs(board[i] - col) == abs(i - row) {
            return false
        }
    }
    return true
}

// Recursive function to solve 4-Queens
//The idea here is to use backtracking to determine valid moves
//You try placing a queen at each location (using the isSafe method above)
//Once all 4 queens have been placed you exit the recursion
func solve(row: Int, board: inout [Int]) -> Bool {
    if row == 4 {  // All 4 queens are placed (base case of the recurison)
        print(board)
        return true
    }
    
    for col in 0..<4 {
        if isSafe(board: board, row: row, col: col) {
            board[row] = col
            if solve(row: row + 1, board: &board) { return true }
            board[row] = -1
        }
    }
    
    return false
}

// Intializing the board
var board = [-1, -1, -1, -1]
solve(row: 0, board: &board)

