//
//  ImagesViewModelTests.swift
//  SwordHealthChallengeTests
//
//  Created by Simão Neves Samouco on 14/08/2023.
//

import XCTest
@testable import SwordHealthChallenge

final class ImagesViewModelTests: XCTestCase {
    
    var viewModel: ImagesViewModel!
    var mockServices: MockServicesManager!
    
    override func setUpWithError() throws {
        mockServices = MockServicesManager()
        viewModel = ImagesViewModel(services: mockServices)
    }
        func testFetchImagesForDogProfiles() {
        
        let mockDogProfile = DogProfile(id: "01",
                                        breedName: "Mock Name",
                                        breedGroup: "Mock Group",
                                        origin: "Mock Origin",
                                        imageUrl: "www.mockurl.com",
                                        width: 200,
                                        height: 200,
                                        temperament: "Mock Temperament",
                                        bredFor: "Mock Bred For")
       
        let mockImage = UIImage(named: "dog_icon")
        
        mockServices.stubImageFetch = mockImage
        
        viewModel.fetchImagesForDogProfiles([mockDogProfile])
        
        XCTAssertEqual(viewModel.dogsProfileList.value.first?.image, mockImage)
    }
    
    func testFetchImagesForDogProfilesWithInvalidURL() {
        
        let mockDogProfile = DogProfile(id: "01",
                                        breedName: "Mock Name",
                                        breedGroup: "Mock Group",
                                        origin: "Mock Origin",
                                        imageUrl: "Mock URL Invalid",
                                        width: 200,
                                        height: 200,
                                        temperament: "Mock Temperament",
                                        bredFor: "Mock Bred For")
        
        viewModel.fetchImagesForDogProfiles([mockDogProfile])
        
        XCTAssertEqual(viewModel.dogsProfileList.value.first?.image, nil)
    }
    
    func testOrderListAlphabetically() {
        let mockDogProfile1 = DogProfile(id: "01",
                                        breedName: "AMock Name",
                                        breedGroup: "Mock Group",
                                        origin: "Mock Origin",
                                        imageUrl: "www.mockurl.com",
                                        width: 200,
                                        height: 200,
                                        temperament: "Mock Temperament",
                                        bredFor: "Mock Bred For")
        let mockDogProfile2 = DogProfile(id: "01",
                                        breedName: "BMock Name",
                                        breedGroup: "Mock Group",
                                        origin: "Mock Origin",
                                        imageUrl: "www.mockurl.com",
                                        width: 200,
                                        height: 200,
                                        temperament: "Mock Temperament",
                                        bredFor: "Mock Bred For")
        let array = [mockDogProfile2, mockDogProfile1]
        viewModel.dogsProfileList.accept(array)
        
        viewModel.orderListAlphabetically()
        
        XCTAssertEqual(viewModel.dogsProfileList.value.first?.breedName, mockDogProfile1.breedName)
        XCTAssertEqual(viewModel.dogsProfileList.value.last?.breedName, mockDogProfile2.breedName)
    }
    
    func testGetDogsList() {
        let breed = Breed(id: 01,
                          name: "Mock Name",
                          breedGroup: "Mock Group",
                          origin: "Mock Origin",
                          temperament: "Mock temperament",
                          weight: Weight(imperial: "200", metric: "200"),
                          height: Height(imperial: "100", metric: "100"))
        
        let dog = Dog(breeds: [breed], id: "01", url: "www.mockurl.com", width: 200, height: 200)
        
        mockServices.stubDogsList = .success([dog])
        
        var capturedDogProfiles: [DogProfile]?
        var capturedError: Error?
        
        viewModel.getDogsListFromService { dogProfiles, error in
            capturedDogProfiles = dogProfiles
            capturedError = error
        }
        
        XCTAssertEqual(capturedDogProfiles?.count, 1)
        XCTAssertEqual(capturedDogProfiles?.first?.breedName, "Mock Name")
        XCTAssertNil(capturedError)
    }
    
}
