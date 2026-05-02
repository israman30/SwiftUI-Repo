## SwiftUI Pagination (Infinite Scroll)

This sample shows a clean, testable way to do **pagination in SwiftUI** using:

- A **service layer** (`PostsServicing`) that knows how to fetch a single page
- A **paging view model** (`PostsViewModel`) that owns paging state and loading/error flags
- A **SwiftUI `List`** that triggers “load more” when the last row appears

The demo API is [JSONPlaceholder](https://jsonplaceholder.typicode.com/) using:

- `GET /posts?_page=<page>&_limit=<limit>`

### Pagination type implemented

This project implements **offset/page-number pagination** (a.k.a. **`limit` + `page`**), with an
**infinite-scroll UI** that loads the next page when the last row appears.

### How pagination works here

Pagination is implemented using **page numbers** and a **page size**:

- **`page`**: the next page to request (1-based)
- **`pageSize`**: items per page (default: 20)
- **`hasMore`**: stops requests once the server returns a “short page”

When `PostsViewModel.loadMore()` completes:

- If the API returns **`pageSize` items**, we assume there *may* be another page → increment `page`
- If it returns **fewer than `pageSize`**, we assume we reached the end → `hasMore = false`

### Infinite scroll trigger

In `ContentView`, each row runs:

- `vm.loadMoreIfNeeded(currentPost:)` in `onAppear`

`loadMoreIfNeeded` only calls `loadMore()` **when the appearing item is the last item** in the list.
This is a common SwiftUI pattern that avoids needing scroll position APIs.

### Preventing duplicate requests

`loadMore()` has guard checks to prevent overlapping fetches:

- `!isLoadingInitial`
- `!isLoadingMore`
- `hasMore`

This is important because SwiftUI can call `onAppear` more than once during list updates.

### Pull to refresh

`refresh()` resets paging to the first page:

- `page = 1`
- clears `errorMessage`
- fetches page 1 and replaces the list content

### Files to look at

- **`Pagination Implementatoin/APIClient.swift`**
  - `JSONPlaceholderPostsService` (fetches a page)
  - `Post` model
- **`Pagination Implementatoin/PostsViewModel.swift`**
  - paging state + `loadInitial`, `refresh`, `loadMore`
- **`Pagination Implementatoin/ContentView.swift`**
  - list UI + “load more” trigger + loading/error UI

### Customization tips

- **Change page size**: in `ContentView`

```swift
@StateObject private var vm = PostsViewModel(
    service: JSONPlaceholderPostsService(),
    pageSize: 30
)
```

- **Prefetch earlier** (instead of only the last row):
  - Update `loadMoreIfNeeded` to trigger when the appearing row is within the last N items.

### Notes

- JSONPlaceholder has a fixed dataset (100 posts). With a page size of 20, you’ll fetch ~5 pages.
- Real-world APIs often use cursor pagination (tokens/links). You can keep the same UI approach;
  only the service + paging state need to change.

