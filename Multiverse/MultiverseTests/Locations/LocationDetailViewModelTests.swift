//
//  LocationDetailViewModelTests.swift
//  Multiverse
//
//  Created by Luis Teodoro on 14/12/24.
//

import XCTest
@testable import Multiverse

final class LocationDetailViewModelTests: XCTestCase {
    
    var viewModel: LocationDetailViewModel!
    var mockNetworkService: MockNetworkService!
    var mockCoordinatorDelegate: MockLocationDetailCoordinatorDelegate!
    var mockDelegate: MockLocationDetailViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        
        mockNetworkService = MockNetworkService()
        let service = MultiverseService(networkService: mockNetworkService)
        mockCoordinatorDelegate = MockLocationDetailCoordinatorDelegate()
        mockDelegate = MockLocationDetailViewModelDelegate()
        
        viewModel = LocationDetailViewModel(service: service, locationID: 1)
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
    
    func testFetchLocationDetailsSuccess() {
        let expectation = self.expectation(description: "Delegate should call didFetchLocationDetails")
        mockNetworkService.mockFileName = "location_1.json"
        
        mockDelegate.didFetchLocationDetailsCallback = {
            XCTAssertTrue(self.mockDelegate.didFetchLocationDetailsCalled, "O método didFetchLocationDetails não foi chamado.")
            expectation.fulfill()
        }
        
        viewModel.fetchLocationDetails()
        
        waitForExpectations(timeout: 2)
    }
    
    func testFetchLocationDetailsFailure() {
        
        mockNetworkService.mockFileName = "nonexistent.json"

        let expectation = self.expectation(description: "Delegate should call didFailToFetchLocationDetails")
        
        mockDelegate.didFailToFetchLocationDetailsCallback = { error in
            XCTAssertTrue(self.mockDelegate.didFailToFetchLocationDetailsCalled, "O método didFailToFetchLocationDetails não foi chamado.")
            XCTAssertNotNil(error, "O erro capturado não deveria ser nulo.")
            expectation.fulfill()
        }
        
        viewModel.fetchLocationDetails()
        
        waitForExpectations(timeout: 2)
    }
    
    func testFetchResidentsSuccess() {
        let expectation = self.expectation(description: "Delegate should call didFetchResidents")
        mockNetworkService.mockFileName = "character_1.json"
        
        mockDelegate.didFetchResidentsCallback = {
            XCTAssertTrue(self.mockDelegate.didFetchResidentsCalled, "O método didFetchResidents não foi chamado.")
            XCTAssertEqual(self.viewModel.residents.count, 1, "O número de residentes retornados está incorreto.")
            expectation.fulfill()
        }
        
        viewModel.locationDetail = LocationDetail(id: 1, name: "Earth", type: "Planet", url: nil, dimension: "C-137", residents: ["https://rickandmortyapi.com/api/character/1"])
        viewModel.fetchResidents()
        
        waitForExpectations(timeout: 2)
    }
    
    func testFetchResidentsFailure() {
        let expectation = self.expectation(description: "Delegate should call didFailToFetchResidents")
        
        mockDelegate.didFailToFetchResidentsCallback = { error in
            XCTAssertTrue(self.mockDelegate.didFailToFetchResidentsCalled, "O método didFailToFetchResidents não foi chamado.")
            XCTAssertNotNil(error, "O erro capturado não deveria ser nulo.")
            expectation.fulfill()
        }
        
        viewModel.locationDetail = LocationDetail(id: 1, name: "Earth", type: "Planet", url: nil, dimension: "C-137", residents: ["https://rickandmortyapi.com/api/character/1"])
        viewModel.fetchLocationDetails()
        
        waitForExpectations(timeout: 2)
    }
    
    func testSelectResident() {
        let mockResidents = [
            Character(id: 1,
                      name: "Rick Sanchez",
                      status: "Alive",
                      species: "Human",
                      type: nil,
                      gender: "Male",
                      origin: nil,
                      location: nil,
                      image: nil,
                      episode: nil,
                      url: nil,
                      created: nil),
            Character(id: 2,
                      name: "Morty Smith",
                      status: "Alive",
                      species: "Human",
                      type: nil,
                      gender: "Male",
                      origin: nil,
                      location: nil,
                      image: nil,
                      episode: nil,
                      url: nil,
                      created: nil)
        ]
        viewModel.residents = mockResidents
        
        viewModel.selectResident(withID: 2)
        
        XCTAssertEqual(mockCoordinatorDelegate.selectedCharacterID, 2, "O ID do residente selecionado está incorreto.")
    }
}

// MARK: - Mocks

final class MockLocationDetailCoordinatorDelegate: LocationDetailCoordinatorDelegate {
    var selectedCharacterID: Int?
    
    func navigateToCharacterDetails(withID characterID: Int) {
        selectedCharacterID = characterID
    }
}

final class MockLocationDetailViewModelDelegate: LocationDetailViewModelDelegate {
    var didFetchLocationDetailsCalled = false
    var didFailToFetchLocationDetailsCalled = false
    var didFetchResidentsCalled = false
    var didFailToFetchResidentsCalled = false
    
    var didFetchLocationDetailsCallback: (() -> Void)?
    var didFailToFetchLocationDetailsCallback: ((Error) -> Void)?
    var didFetchResidentsCallback: (() -> Void)?
    var didFailToFetchResidentsCallback: ((Error) -> Void)?
    
    func didFetchLocationDetails() {
        didFetchLocationDetailsCalled = true
        didFetchLocationDetailsCallback?()
    }
    
    func didFailToFetchLocationDetails(with error: Error) {
        didFailToFetchLocationDetailsCalled = true
        didFailToFetchLocationDetailsCallback?(error)
    }
    
    func didFetchResidents() {
        didFetchResidentsCalled = true
        didFetchResidentsCallback?()
    }
    
    func didFailToFetchResidents(with error: Error) {
        didFailToFetchResidentsCalled = true
        didFailToFetchResidentsCallback?(error)
    }
}
