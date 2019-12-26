    //
    //  ServiceSecretWord.swift
    //  DragAndDropTests
    //
    //  Created by Badre DAHA BELGHITI on 26/12/2019.
    //  Copyright © 2019 BadNetApps. All rights reserved.
    //
    
    import XCTest
    
    @testable import DragAndDrop
    
    class ServiceSecretWordTests: XCTestCase {
        
        var sut:ServiceSecretWord?
        fileprivate var mockDelegate: HelperServiceSecretWord.MockServiceWordDelegate?
        
        var delegate: ServiceSecretWordDelegate?
        
        override func setUp() {
            // Put setup code here. This method is called before the invocation of each test method in the class.
            sut = ServiceSecretWord(delegate: mockDelegate)
        }
        
        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
            sut = nil
        }
        
        func test_sud_without_delegate(){
            XCTAssertNotNil(sut, "SUD musn't be null if delegate is null")
        }
        
        func test_words_with_item_in_array_in_first_call(){
            let words = sut?.words
            XCTAssert(words!.count > 0, "Words must be > 0")
        }
        
        func test_words_start_with_underscroc_character_first_in_first_call(){
            let words = sut?.words
            XCTAssertEqual(words?.first, "_","Underscor '_' must ne the first item of array in the first call")
        }
        
        func test_is_placeholder_always_at_last_element(){
            let isPlaceHolderAtEnd = sut?.isPlaceHolderPresentAtEnd()
            XCTAssert(isPlaceHolderAtEnd!, "Underscrore must be at last element")
        }
        
        func test_add_new_word_underscro_character_cannot_exist_two_times(){
            let underscores = sut?.words.filter({ $0 == "_" })
            sut?.addNewWord("_")
            sut?.addNewWord("_")
            XCTAssertEqual(underscores?.count, 1,"Underscore charaters must existing ones into words array ")
        }
        
        func test_add_new_word_and_underscore_is_last_item() {
            sut?.addNewWord("test")
            sut?.addNewWord("test2")
            XCTAssertEqual(sut?.words.last, "_","Underscore must bet last item ")
        }
        
        func test_add_new_word_is_added_good_index_call_once() {
            let testWord1 = "test1"
            let testWord2 = "test2"
            sut?.addNewWord(testWord1)
            sut?.addNewWord(testWord2)
            
            XCTAssertEqual(sut?.words[0],testWord1,"add new word in note good place")
            XCTAssertEqual(sut?.words[1],testWord2,"add new word in note good place")
        }
        
        func test_max_words_must_be_twelve() {
            XCTAssertEqual(sut?.maxWordAuthorized, 12, "Max words must to be 12 ! ")
        }
        
        func test_max_word_achieved() {
            //sut?.words = Hel
            
            let words = HelperServiceSecretWord.makeMaxWordsForSut()
            words.forEach { (s) in
                sut?.addNewWord(s)
            }
            XCTAssert((sut?.isMaxWordAchieved())!, "Max words is not equal to max word authorized")
        }
        
        func test_add_new_word_must_call_can_write_new_word_delegate_call_once() {
            let mockDelegate = HelperServiceSecretWord.MockServiceWordDelegate()
            sut?.delegate = mockDelegate
            
            let testWord1 = "test1"
            sut?.addNewWord(testWord1)
            XCTAssertEqual(mockDelegate.incrementOfCallCanWriteNewWord, 1)
        }
    
        func test_add_new_word_must_call_can_write_new_word_delegate_twice() {
            
            let mockDelegate = HelperServiceSecretWord.MockServiceWordDelegate()
            sut?.delegate = mockDelegate
            
            let testWord1 = "test1"
            let testWord2 = "test2"
            sut?.addNewWord(testWord1)
            sut?.addNewWord(testWord2)
            XCTAssertEqual(mockDelegate.incrementOfCallCanWriteNewWord, 2)
        }
        
        func test_add_new_word_must_call_can_write_new_word_and_not_maxWord_delegate() {
            let mockDelegate = HelperServiceSecretWord.MockServiceWordDelegate()
            sut?.delegate = mockDelegate
            
            let testWord1 = "test1"
            sut?.addNewWord(testWord1)
            XCTAssertEqual(mockDelegate.incrementOfCallMaxWordsAuthorized, 0)
        }
        
        func test_add_new_word_must_call_maxWord_delegate_and_not_can_write_new_word() {
            
            let mockDelegate = HelperServiceSecretWord.MockServiceWordDelegate()
            sut?.delegate = mockDelegate
            
            let words = HelperServiceSecretWord.makeMaxWordsForSut()
            words.forEach { (s) in
                sut?.addNewWord(s)
            }
            
            XCTAssertEqual(mockDelegate.incrementOfCallMaxWordsAuthorized, 1)
        }
    }
    
    
    private class HelperServiceSecretWord{
        //TODO: Refacto To Helper Tests
        class MockServiceWordDelegate: ServiceSecretWordDelegate{
            
            var incrementOfCallMaxWordsAuthorized = 0
            var incrementOfCallCanWriteNewWord = 0
            
            func maxWordsAuthorized() {
                self.incrementOfCallMaxWordsAuthorized += 1
            }
            
            func canWriteNewWord() {
                self.incrementOfCallCanWriteNewWord += 1
            }
            
        }
        
        static func makeMaxWordsForSut() -> [String]{
            var words = [""]
            for i in 0...10 {
                words.append("word\(i)")
            }
            return words
        }
        
    }

    
