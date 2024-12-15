//
//  CharacterDetailViewModelTests.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import XCTest
@testable import Multiverse

final class CharacterDetailViewModelTests: XCTestCase {
    var viewModel: CharacterDetailViewModel!
    var mockNetworkService: MockNetworkService!
    var mockCoordinatorDelegate: MockCharacterDetailCoordinatorDelegate!
    var mockDelegate: MockCharacterDetailViewModelDelegate!

    override func setUp() {
        super.setUp()

        mockNetworkService = MockNetworkService()
        let service = MultiverseService(networkService: mockNetworkService)
        mockCoordinatorDelegate = MockCharacterDetailCoordinatorDelegate()
        mockDelegate = MockCharacterDetailViewModelDelegate()
        
        viewModel = CharacterDetailViewModel(service: service, characterId: 1)
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

    func testFetchCharacterDetailsSuccess() {
        let expectation = self.expectation(description: "Fetch Character Details Success")
        mockNetworkService.mockFileName = "character_1.json"

        mockDelegate.didFetchCharacterDetailsCallback = {
            XCTAssertNotNil(self.viewModel.character, "O personagem deveria ser carregado com sucesso.")
            XCTAssertEqual(self.viewModel.character?.id, 1, "O ID do personagem está incorreto.")
            XCTAssertEqual(self.viewModel.character?.name, "Rick Sanchez", "O nome do personagem está incorreto.")
            expectation.fulfill()
        }

        viewModel.fetchCharacterDetails()
        waitForExpectations(timeout: 2)
    }

    func testFetchCharacterDetailsFailure() {
        mockNetworkService.mockFileName = "nonexistent.json"
        let expectation = self.expectation(description: "Fetch Character Details Failure")

        mockDelegate.didFailToFetchCharacterDetailsCallback = { error in
            XCTAssertNotNil(error, "Esperava-se um erro, mas nenhum foi retornado.")
            expectation.fulfill()
        }

        viewModel.fetchCharacterDetails()
        waitForExpectations(timeout: 2)
    }

    func testGetEpisodeIDSuccess() {
        let character = Character( id: 1, name: "Rick Sanchez",
                                   status: nil,
                                   species: nil,
                                   type: nil,
                                   gender: nil,
                                   origin: nil,
                                   location: nil,
                                   image: nil,
                                   episode: ["https://rickandmortyapi.com/api/episode/1"],
                                   url: nil,
                                   created: nil)
        viewModel.character = character

        viewModel.getEpisodeID(at: 0)

        XCTAssertEqual(mockCoordinatorDelegate.selectedEpisodeID, 1, "O ID do episódio selecionado está incorreto.")
    }

    func testGetEpisodeIDFailure() {
        let character = Character( id: 1,
                                   name: "Rick Sanchez",
                                   status: nil,
                                   species: nil,
                                   type: nil,
                                   gender: nil,
                                   origin: nil,
                                   location: nil,
                                   image: nil,
                                   episode: [],
                                   url: nil,
                                   created: nil)
        viewModel.character = character

        viewModel.getEpisodeID(at: 0)

        XCTAssertNil(mockCoordinatorDelegate.selectedEpisodeID, "Nenhum episódio deveria ser selecionado.")
    }
}

final class MockCharacterDetailViewModelDelegate: CharacterDetailViewModelDelegate {
    var didFetchCharacterDetailsCallback: (() -> Void)?
    var didFailToFetchCharacterDetailsCallback: ((Error) -> Void)?

    func didFetchCharacterDetails() {
        didFetchCharacterDetailsCallback?()
    }

    func didFailToFetchCharacterDetails(with error: Error) {
        didFailToFetchCharacterDetailsCallback?(error)
    }
}

final class MockCharacterDetailCoordinatorDelegate: CharacterDetailCoordinatorDelegate {
    var selectedEpisodeID: Int?

    func didSelectEpisode(withID episodeID: Int) {
        selectedEpisodeID = episodeID
    }
}
