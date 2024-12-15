//
//  PaginationManager.swift
//  Multiverse
//
//  Created by Luis Teodoro on 14/12/24.
//

class PaginationManager {
    var currentPage = 1
    var totalPages = 1
    var isFetching = false
    
    func canFetchNextPage() -> Bool {
        return !isFetching && currentPage <= totalPages
    }
    
    func updatePagination(totalPages: Int) {
        self.totalPages = totalPages
        self.currentPage += 1
    }
    
    func resetPagination() {
        currentPage = 1
        totalPages = 1
        isFetching = false
    }
}
