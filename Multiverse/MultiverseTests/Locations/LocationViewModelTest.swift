//
//  LocationViewModelTest.swift
//  Multiverse
//
//  Created by Luis Teodoro on 14/12/24.
//

import XCTest
@testable import Multiverse

final class LocationViewModelTests: XCTestCase {
    var viewModel: LocationViewModel!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        let service = MultiverseService(networkService: mockNetworkService)
        viewModel = LocationViewModel(service: service)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testFetchLocationsSuccess() {
        let expectation = self.expectation(description: "Fetch Locations Success")
        
        mockNetworkService.mockFileName = "location_page.json"

        let mockDelegate = MockLocationViewModelDelegate { locations, error in
            XCTAssertNil(error, "Erro inesperado ao buscar locais")
            XCTAssertEqual(locations.count, 20, "O número de locais retornados está incorreto")
            expectation.fulfill()
        }

        viewModel.delegate = mockDelegate
        viewModel.fetchLocations()

        waitForExpectations(timeout: 2)
    }

    func testFetchLocationsFailure() {
        
        mockNetworkService.mockFileName = "nonexistent.json"

        let expectation = self.expectation(description: "Fetch Locations Failure")

        let mockDelegate = MockLocationViewModelDelegate { locations, error in
            XCTAssertNotNil(error, "Esperava um erro, mas nenhum foi retornado")
            XCTAssertTrue(locations.isEmpty, "Locais não deveriam ser retornados em caso de erro")
            expectation.fulfill()
        }

        viewModel.delegate = mockDelegate
        viewModel.fetchLocations()

        waitForExpectations(timeout: 2)
    }
    
    func testSelectLocation() {
        let mockLocations = [
            LocationDetail(id: 1, name: "Earth", type: "Planet", url: nil, dimension: nil, residents: nil),
            LocationDetail(id: 2, name: "Citadel of Ricks", type: "Space Station", url: nil, dimension: nil, residents: nil)
        ]
        viewModel.allLocations = mockLocations

        class MockCoordinatorDelegate: LocationCoordinatorDelegate {
            var selectedLocationId: Int?
            func navigateToLocationDetails(withID id: Int) {
                selectedLocationId = id
            }
        }

        let mockCoordinator = MockCoordinatorDelegate()
        viewModel.coordinatorDelegate = mockCoordinator

        viewModel.selectLocation(at: 1)

        XCTAssertEqual(mockCoordinator.selectedLocationId, 2, "ID do local selecionado está incorreto")
    }

    func testResetPagination() {
        viewModel.fetchLocations()

        viewModel.resetPagination()

        XCTAssertEqual(viewModel.paginationManager.currentPage, 1, "Página atual não foi redefinida")
        XCTAssertEqual(viewModel.paginationManager.totalPages, 1, "Total de páginas não foi redefinido")
        XCTAssertTrue(viewModel.allLocations.isEmpty, "Os locais não foram limpos")
        XCTAssertFalse(viewModel.paginationManager.isFetching, "O estado de fetching não foi redefinido")
    }

    func testFetchLocationsWhenAllPagesFetched() {
        viewModel.paginationManager.currentPage = 2
        viewModel.paginationManager.totalPages = 1

        let expectation = self.expectation(description: "No API Call Expected")

        let mockDelegate = MockLocationViewModelDelegate { _, _ in
            XCTFail("Não deveria haver atualizações ou erros, pois todas as páginas já foram carregadas")
        }

        viewModel.delegate = mockDelegate

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        viewModel.fetchLocations()

        waitForExpectations(timeout: 2)
    }
}

final class MockLocationViewModelDelegate: LocationViewModelDelegate {
    private let callback: ([LocationDetail], Error?) -> Void

    init(callback: @escaping ([LocationDetail], Error?) -> Void) {
        self.callback = callback
    }

    func didUpdateLocations(_ locations: [LocationDetail]) {
        callback(locations, nil)
    }

    func didFailWithError(_ error: Error) {
        callback([], error)
    }
}
