//
//  EpisodesViewModelTests.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import XCTest
@testable import Multiverse

final class EpisodesViewModelTests: XCTestCase {
    var viewModel: EpisodesViewModel!
    var mockNetworkService: MockNetworkService!
    var mockCoordinatorDelegate: MockEpisodesCoordinatorDelegate!
    var mockDelegate: MockEpisodesViewModelDelegate!

    override func setUp() {
        super.setUp()

        mockNetworkService = MockNetworkService()
        let service = MultiverseService(networkService: mockNetworkService)
        mockCoordinatorDelegate = MockEpisodesCoordinatorDelegate()
        mockDelegate = MockEpisodesViewModelDelegate()
        
        viewModel = EpisodesViewModel(service: service)
        viewModel.coordinatorDelegate = mockCoordinatorDelegate
        viewModel.delegate = mockDelegate
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockCoordinatorDelegate = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testFetchEpisodesSuccess() {
        let expectation = self.expectation(description: "Fetch Episodes Success")
        mockNetworkService.mockFileName = "episodes_page_1.json"

        mockDelegate.didUpdateEpisodesCallback = { episodes in
            XCTAssertEqual(episodes.count, 20, "O número de episódios retornados está incorreto.")
            XCTAssertEqual(episodes.first?.name, "Pilot", "O nome do primeiro episódio está incorreto.")
            expectation.fulfill()
        }

        viewModel.fetchEpisodes()
        waitForExpectations(timeout: 2)
    }

    func testFetchEpisodesFailure() {
        mockNetworkService.mockFileName = "nonexistent.json"
        let expectation = self.expectation(description: "Fetch Episodes Failure")

        mockDelegate.didFailWithErrorCallback = { error in
            XCTAssertNotNil(error, "Esperava-se um erro, mas nenhum foi retornado.")
            expectation.fulfill()
        }

        viewModel.fetchEpisodes()
        waitForExpectations(timeout: 2)
    }

    func testSelectEpisode() {
        let mockEpisodes = [
            Episode(id: 1, name: "Pilot", airDate: "December 2, 2013", episode: "S01E01", characters: nil, url: nil, created: nil),
            Episode(id: 2, name: "Lawnmower Dog", airDate: "December 9, 2013", episode: "S01E02", characters: nil, url: nil, created: nil)
        ]
        viewModel.episodes = mockEpisodes

        viewModel.selectEpisode(at: 1)

        XCTAssertEqual(mockCoordinatorDelegate.selectedEpisodeID, 2, "O ID do episódio selecionado está incorreto.")
    }

    func testFetchEpisodesPagination() {
        let expectation = self.expectation(description: "Fetch Episodes Pagination")
        var pageLoadCount = 0
        let episodesPerPage = 20

        mockNetworkService.mockFileName = "episodes_page_1.json"

        mockDelegate.didUpdateEpisodesCallback = { episodes in
            pageLoadCount += 1

            let expectedCount = episodesPerPage * pageLoadCount
            XCTAssertEqual(episodes.count, expectedCount, "A contagem de episódios está incorreta após a paginação para a página \(pageLoadCount).")

            if pageLoadCount == 2 {
                expectation.fulfill()
            }
        }

        mockDelegate.didFailWithErrorCallback = { error in
            XCTFail("Erro inesperado: \(error)")
        }

        viewModel.delegate = mockDelegate
        viewModel.fetchEpisodes() // Página 1
        viewModel.fetchEpisodes() // Página 2

        waitForExpectations(timeout: 2)

        XCTAssertEqual(viewModel.paginationManager.currentPage, 3, "A página atual não foi incrementada corretamente após a paginação.")
    }

}

final class MockEpisodesCoordinatorDelegate: EpisodesCoordinatorDelegate {
    var selectedEpisodeID: Int?

    func didSelectEpisode(withID episodeID: Int) {
        selectedEpisodeID = episodeID
    }
}

final class MockEpisodesViewModelDelegate: EpisodesViewModelDelegate {
    var didUpdateEpisodesCallback: (([Episode]) -> Void)?
    var didFailWithErrorCallback: ((Error) -> Void)?

    func didUpdateEpisodes(_ episodes: [Episode]) {
        didUpdateEpisodesCallback?(episodes)
    }

    func didFailWithError(_ error: Error) {
        didFailWithErrorCallback?(error)
    }
}
