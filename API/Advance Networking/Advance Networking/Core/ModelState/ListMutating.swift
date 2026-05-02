//
//  ListMutating.swift
//  Advance Networking
//
//  Created by Israel Manzo on 5/1/26.
//

import Foundation

protocol ListMutatingProtocol: AnyObject {
    associatedtype Item: Identifiable & Decodable
    
    var loadingState: LoadingState<[Item]> { get set }
}

extension ListMutatingProtocol {
    func insertOrStart(_ item: Item) {
        switch loadingState {
        case .loaded(var items):
            items.insert(item, at: 0)
            loadingState = .loaded(items)
        default:
            loadingState = .loaded([item])
        }
    }
    
    func updateItemIfLoaded(_ item: Item) {
        guard case .loaded(var items) = loadingState else {
            return
        }
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
        loadingState = .loaded(items)
    }
    
    func deleteIfLoaded(_ id: Int) {
        guard case .loaded(var items) = loadingState else {
            return
        }
        guard let index = items.firstIndex(where: { $0.id as! Int == id }) else { return }
        items.remove(at: index)
        loadingState = .loaded(items)
    }
}
