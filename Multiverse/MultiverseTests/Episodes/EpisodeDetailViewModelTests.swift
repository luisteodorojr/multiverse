//
//  EpisodeDetailViewModelTests.swift
//  Multiverse
//
//  Created by Luis Teodoro on 14/12/24.
//

import XCTest
@testable import Multiverse

final class EpisodeDetailViewModelTests: XCTestCase {
    
    var viewModel: EpisodeDetailViewModel!
    var mockNetworkService: MockNetworkService!
    var mockCoordinatorDelegate: MockEpisodeDetailCoordinatorDelegate!
    var mockDelegate: MockEpisodeDetailViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        
        mockNetworkService = MockNetworkService()
        let service = MultiverseService(networkService: mockNetworkService)
        mockCoordinatorDelegate = MockEpisodeDetailCoordinatorDelegate()
        mockDelegate = MockEpisodeDetailViewModelDelegate()
        
        viewModel = EpisodeDetailViewModel(service: service, episodeID: 1)
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
    
    func testSelectCharacter() {
        let mockCharacters = [
            Character(id: 1,
                      name: "Rick Sanchez",
                      status: "Human",
                      species: nil,
                      type: nil,
                      gender: nil,
                      origin: nil,
                      location: nil,
                      image: nil,
                      episode: nil,
                      url: nil,
                      created: nil),
            Character(id: 2,
                      name: "Morty Smith",
                      status: "Human",
                      species: nil,
                      type: nil,
                      gender: nil,
                      origin: nil,
                      location: nil,
                      image: nil,
                      episode: nil,
                      url: nil,
                      created: nil)
        ]
        viewModel.characters = mockCharacters
        
        let character = viewModel.characters[1]
        
        viewModel.selectCharacter(withId: character.id ?? 0)
        
        XCTAssertEqual(mockCoordinatorDelegate.selectedCharacterID, 2, "O ID do personagem selecionado está incorreto.")
    }
    
    func testDidFetchEpisodeDetailsSuccess() {
        let expectation = self.expectation(description: "Delegate should call didFetchEpisodeDetails")
        mockNetworkService.mockFileName = "episode_2.json"
        
        mockDelegate.didFetchEpisodeDetailsCallback = {
            XCTAssertTrue(self.mockDelegate.didFetchEpisodeDetailsCalled, "O método didFetchEpisodeDetails não foi chamado.")
            expectation.fulfill()
        }
        
        viewModel.fetchEpisodeDetails()
        
        waitForExpectations(timeout: 5)
    }

    func testFetchEpisodeDetailsFailure() {
        let expectation = self.expectation(description: "Delegate should call didFailToFetchEpisodeDetails")
        
        mockDelegate.didFailToFetchEpisodeDetailsCallback = { error in
            XCTAssertTrue(self.mockDelegate.didFailToFetchEpisodeDetailsCalled, "O método didFailToFetchEpisodeDetails não foi chamado.")
            XCTAssertNotNil(error, "O erro capturado não deveria ser nulo.")
            expectation.fulfill()
        }
        
        viewModel.fetchEpisodeDetails()
        
        waitForExpectations(timeout: 5)
    }

    func testDidFetchEpisodeCharactersSuccess() {
        let expectation = self.expectation(description: "Delegate should call didFailToFetchEpisodeCharacters")
        mockNetworkService.mockFileName = "character_page.json"
        
        mockDelegate.didFetchEpisodeCharactersCallback = {
            XCTAssertTrue(self.mockDelegate.didFetchEpisodeCharactersCalled, "O método didFailToFetchEpisodeCharacters não foi chamado.")
            expectation.fulfill()
        }
        
        viewModel.episodeDetail = Episode(id: 1,
                                          name: "Pilot",
                                          airDate: "December 2, 2013",
                                          episode: "S01E01",
                                          characters: ["https://rickandmortyapi.com/api/character/2"],
                                          url: nil,
                                          created: nil)
        
        viewModel.fetchEpisodeCharacters()
        
        waitForExpectations(timeout: 2)
    }
    
    func testDidFetchEpisodeCharactersFailure() {
        mockNetworkService.mockFileName = "nonexistent.json"
        let expectation = self.expectation(description: "Fetch Episodes Failure")

        mockDelegate.didFailToFetchEpisodeCharactersCallback = { error in
            XCTAssertNotNil(error, "Esperava-se um erro, mas nenhum foi retornado.")
            expectation.fulfill()
        }

        viewModel.episodeDetail = Episode(id: 1,
                                          name: "Pilot",
                                          airDate: "December 2, 2013",
                                          episode: "S01E01",
                                          characters: ["https://rickandmortyapi.com/api/character/2"],
                                          url: nil,
                                          created: nil)
        
        viewModel.fetchEpisodeCharacters()
        waitForExpectations(timeout: 2)
    }
}

final class MockEpisodeDetailCoordinatorDelegate: EpisodeDetailCoordinatorDelegate {
    var selectedCharacterID: Int?
    
    func didSelectCharacter(withId id: Int) {
        selectedCharacterID = id
    }
}

final class MockEpisodeDetailViewModelDelegate: EpisodeDetailViewModelDelegate {
    var didFetchEpisodeDetailsCalled = false
    var didFailToFetchEpisodeDetailsCalled = false
    var didFetchEpisodeCharactersCalled = false
    var didFailToFetchEpisodeCharactersCalled = false
    
    var didFetchEpisodeDetailsCallback: (() -> Void)?
    var didFailToFetchEpisodeDetailsCallback: ((Error) -> Void)?
    var didFetchEpisodeCharactersCallback: (() -> Void)?
    var didFailToFetchEpisodeCharactersCallback: ((Error) -> Void)?
    
    func didFetchEpisodeDetails() {
        didFetchEpisodeDetailsCalled = true
        didFetchEpisodeDetailsCallback?()
    }
    
    func didFailToFetchEpisodeDetails(with error: Error) {
        didFailToFetchEpisodeDetailsCalled = true
        didFailToFetchEpisodeDetailsCallback?(error)
    }
    
    func didFetchEpisodeCharacters() {
        didFetchEpisodeCharactersCalled = true
        didFetchEpisodeCharactersCallback?()
    }
    
    func didFailToFetchEpisodeCharacters(with error: Error) {
        didFailToFetchEpisodeCharactersCalled = true
        didFailToFetchEpisodeCharactersCallback?(error)
    }
}
