import Foundation
import Foundation

// ---------------------------------------------------------
// FUNCTION 1 — Extract the Google Doc ID from the URL
// ---------------------------------------------------------
func extractGoogleDocID(from url: String) -> String? {
    // Convert Substring or URL to String safely
    let urlString = String(url)

    // Expect URLs like:
    // https://docs.google.com/document/d/DOC_ID/edit
    guard let part = urlString.components(separatedBy: "/d").last else {
        return nil
    }

    // DOC_ID is before next "/"
    return part.components(separatedBy: "/").first
}



// ---------------------------------------------------------
// FUNCTION 2 — Fetch the doc content, parse grid, print result
// ---------------------------------------------------------
func fetchAndPrintGrid(fromDocID docID: String) {
    let exportURL = "https://docs.google.com/document/d/\(docID)/export?format=txt"

    guard let url = URL(string: exportURL),
          let text = try? String(contentsOf: url, encoding: .utf16) else {
        print("Failed to fetch Google Doc.")
        return
    }

    // Parse lines like: 5 12 █
    struct Cell {
        let x: Int
        let y: Int
        let char: Character
    }

    var cells: [Cell] = []

    for line in text.split(separator: "\n") {
        let parts = line.split(separator: " ")
        if parts.count >= 3,
           let x = Int(parts[0]),
           let y = Int(parts[1]),
           let char = parts.last?.first {
            cells.append(Cell(x: x, y: y, char: char))
        }
    }

    // Determine grid size
    let maxX = cells.map{$0.x}.max() ?? 0
    let maxY = cells.map{$0.y}.max() ?? 0

    // Create a 2D grid filled with spaces
    var grid = Array(
        repeating: Array(repeating: " ", count: maxX + 1),
        count: maxY + 1
    )

    // Fill characters
    for cell in cells {
        grid[cell.y][cell.x] = String(cell.char)
    }

    // Print the grid
    for row in grid {
        print(row.joined())
    }
}



// ---------------------------------------------------------
// MAIN SPEC REQUIRED FUNCTION — Accepts URL only
// ---------------------------------------------------------
func renderMessage(from url: String) {
    guard let docID = extractGoogleDocID(from: url) else {
        print("Invalid Google Docs URL.")
        return
    }

    fetchAndPrintGrid(fromDocID: docID)
}

fetchAndPrintGrid(fromDocID: "https://docs.google.com/document/d/e/2PACX-1vRPzbNQcx5UriHSbZ-9vmsTow_R6RRe7eyAU60xIF9Dlz-vaHiHNO2TKgDi7jy4ZpTpNqM7EvEcfr_p/pub")
