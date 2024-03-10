import Foundation

struct Item: Codable {
    let id: Int
    let listId: Int
    let name: String?
}

func fetch() {
    let url = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json")!
    
    URLSession.shared.dataTask(with: url) { data, response, error in 
        guard let data = data else {
            print("Data inaccessable")
            return
        }

        do {
            let items = try JSONDecoder().decode([Item].self, from: data)
            let startFilter = items.filter{ $0.name != nil}
            let filteredItems = startFilter.filter{ $0.name != ""}

            let groupedItems = Dictionary(grouping: filteredItems, by: { $0.listId })


            let sortedListIdItems = groupedItems.sorted{ $0.key < $1.key }

            for (listId, items) in sortedListIdItems {
                let sortedNameItems = items.sorted{ $0.name ?? "" < $1.name ?? "" }
                print("Items in listID: \(listId)")
                for item in sortedNameItems {
                    if let name = item.name {
                        print("\(name)")
                    } else {continue}
                }
                print("END OF listID \(listId) \n")
            }

        } catch {
            print("Error decoding JSON")
            return
        }
        
    }.resume()
}

fetch()
RunLoop.main.run()
