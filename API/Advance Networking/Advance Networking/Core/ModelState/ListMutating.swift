//
//  ListMutating.swift
//  Advance Networking
//
//  Created by Israel Manzo on 5/1/26.
//

import Foundation

/// Shared list-mutation helpers for view models that render from `LoadingState<[Item]>`.
///
/// Motivation:
/// After a successful create/update/delete API call, many list screens want to update the currently
/// loaded list *locally* (so the UI updates immediately) without forcing a full refetch.
///
/// Usage:
/// Conform your `ObservableObject` view model by providing a `loadingState` property:
///
/// - `@Published var loadingState: LoadingState<[MyItem]>`
///
/// Then call the helpers after your service returns:
/// - `insertOrStart(_:)` after create
/// - `updateItemIfLoaded(_:)` after update
/// - `deleteIfLoaded(_:)` after delete
///
/// Note:
/// These helpers only mutate the list when it is already in a `.loaded` state (except
/// `insertOrStart`, which will start a new `.loaded` list). That keeps the state machine consistent
/// with what the view is currently rendering.
protocol ListMutatingProtocol: AnyObject {
    /// The list element type.
    ///
    /// This project’s API models use integer identifiers (e.g. `Post.id`, `User.id`), so the helper
    /// methods are specialized to `Item.ID == Int` to avoid unsafe casts.
    associatedtype Item: Identifiable & Decodable where Item.ID == Int
    
    /// The screen state driving the SwiftUI rendering.
    var loadingState: LoadingState<[Item]> { get set }
}

extension ListMutatingProtocol {
    /// Inserts an item at the top of the currently loaded list.
    ///
    /// If the list isn't loaded yet (idle/loading/empty/error), this starts a new `.loaded` list
    /// containing only the inserted item.
    func insertOrStart(_ item: Item) {
        switch loadingState {
        case .loaded(var items):
            items.insert(item, at: 0)
            loadingState = .loaded(items)
        default:
            loadingState = .loaded([item])
        }
    }
    
    /// Replaces an existing item in the loaded list by matching `id`.
    ///
    /// No-op unless the current state is `.loaded` and the id exists in the list.
    func updateItemIfLoaded(_ item: Item) {
        guard case .loaded(var items) = loadingState else {
            return
        }
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
        loadingState = .loaded(items)
    }
    
    /// Removes an item from the loaded list by id.
    ///
    /// No-op unless the current state is `.loaded` and the id exists in the list.
    func deleteIfLoaded(_ id: Item.ID) {
        guard case .loaded(var items) = loadingState else {
            return
        }
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items.remove(at: index)
        loadingState = .loaded(items)
    }
}
