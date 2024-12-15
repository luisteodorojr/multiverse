//
//  CharacterViewModelTests.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import XCTest
@testable import Multiverse

final class CharacterViewModelTests: XCTestCase {
    var viewModel: CharacterViewModel!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        let service = MultiverseService(networkService: mockNetworkService)
        viewModel = CharacterViewModel(service: service)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testFetchCharactersSuccess() {
        let expectation = self.expectation(description: "Fetch Characters Success")
        
        mockNetworkService.mockFileName = "character_page.json"

        let mockDelegate = MockCharacterViewModelDelegate { characters, error in
            XCTAssertNil(error, "Erro inesperado ao buscar personagens")
            XCTAssertEqual(characters.count, 20, "O número de personagens retornados está incorreto")
            expectation.fulfill()
        }

        viewModel.delegate = mockDelegate
        viewModel.fetchCharacters()

        waitForExpectations(timeout: 2)
    }

    func testFetchCharactersFailure() {
       
        mockNetworkService.mockFileName = "nonexistent.json"

        let expectation = self.expectation(description: "Fetch Characters Failure")
        
        let mockDelegate = MockCharacterViewModelDelegate { characters, error in
            XCTAssertNotNil(error, "Esperava um erro, mas nenhum foi retornado")
            XCTAssertTrue(characters.isEmpty, "Personagens não deveriam ser retornados em caso de erro")
            expectation.fulfill()
        }

        viewModel.delegate = mockDelegate
        viewModel.fetchCharacters()

        waitForExpectations(timeout: 2)
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
        viewModel.allCharacters = mockCharacters

        class MockCoordinatorDelegate: CharacterCoordinatorDelegate {
            var selectedCharacterId: Int?
            func didSelectCharacter(withId id: Int) {
                selectedCharacterId = id
            }
        }

        let mockCoordinator = MockCoordinatorDelegate()
        viewModel.coordinatorDelegate = mockCoordinator

        viewModel.selectCharacter(at: 1)

        XCTAssertEqual(mockCoordinator.selectedCharacterId, 2, "ID do personagem selecionado está incorreto")
    }

    func testResetPagination() {
        viewModel.fetchCharacters()

        viewModel.resetPagination()

        XCTAssertEqual(viewModel.paginationManager.currentPage, 1, "Página atual não foi redefinida")
        XCTAssertEqual(viewModel.paginationManager.totalPages, 1, "Total de páginas não foi redefinido")
        XCTAssertTrue(viewModel.allCharacters.isEmpty, "Os personagens não foram limpos")
        XCTAssertFalse(viewModel.paginationManager.isFetching, "O estado de fetching não foi redefinido")
    }

    func testFetchCharactersWhenAllPagesFetched() {
        viewModel.paginationManager.currentPage = 2
        viewModel.paginationManager.totalPages = 1

        let expectation = self.expectation(description: "No API Call Expected")

        let mockDelegate = MockCharacterViewModelDelegate { _, _ in
            XCTFail("Não deveria haver atualizações ou erros, pois todas as páginas já foram carregadas")
        }

        viewModel.delegate = mockDelegate

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        viewModel.fetchCharacters()

        waitForExpectations(timeout: 2)
    }

}

final class MockCharacterViewModelDelegate: CharacterViewModelDelegate {
    private let callback: ([Character], Error?) -> Void

    init(callback: @escaping ([Character], Error?) -> Void) {
        self.callback = callback
    }

    func didUpdateCharacters(_ characters: [Character]) {
        callback(characters, nil)
    }

    func didFailWithError(_ error: Error) {
        callback([], error)
    }
}
