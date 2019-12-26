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
        
        var sud:ServiceSecretWord?
        var mockDelegate:MockServiceWordDelegate?
        
        var delegate: ServiceSecretWordDelegate?
        
        override func setUp() {
            // Put setup code here. This method is called before the invocation of each test method in the class.
            sud = ServiceSecretWord(delegate: mockDelegate)
        }
        
        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
            sud = nil
        }
        
        func test_sud_without_delegate(){
            XCTAssertNotNil(sud, "SUD musn't be null if delegate is null")
        }
        
        func test_words_with_item_in_array_in_first_call(){
            
            let words = sud?.words
            XCTAssert(words!.count > 0, "Words must be > 0")
        }
        
        func test_words_start_with_underscroc_character_first_in_first_call(){
            
            let words = sud?.words
            
            XCTAssertEqual(words?.first, "_","Underscor '_' must ne the first item of array in the first call")
        }
        
        func test_is_new_word_with_underscor_character_always_at_last_element(){
            let lastIndex = (sud?.words.count)! - 1
            let isNewWord = sud?.isNewWord(at: lastIndex)
            XCTAssert(isNewWord!, "Underscrore must be at last element")
        }
        
        func test_add_new_word_underscro_character_cannot_exist_two_times(){
            let underscores = sud?.words.filter({$0=="_"})
            sud?.addNewWord("_")
            sud?.addNewWord("_")
            XCTAssertEqual(underscores?.count, 1,"Underscore charaters must existing ones into words array ")
        }
        
        func test_add_new_word_and_underscore_is_last_item() {
            sud?.addNewWord("test")
            sud?.addNewWord("test2")
            
            XCTAssertEqual(sud?.words.last, "_","Underscore must bet last item ")
        }
        
        func test_add_new_word_is_added_good_index_call_once() {
            let testWord1 = "test1"
            let testWord2 = "test2"
            sud?.addNewWord(testWord1)
            sud?.addNewWord(testWord2)
            
            XCTAssertEqual(sud?.words[0],testWord1,"add new word in note good place")
            
            XCTAssertEqual(sud?.words[1],testWord2,"add new word in note good place")
            
        }
        
          func test_max_words_must_be_twelve() {
              XCTAssertEqual(sud?.maxWordAuthorized, 12, "Max words must to be 12 ! ")
          }
        
        func test_add_new_word_must_call_can_write_new_word_delegate_call_once() {
            
            let mockDelegate = MockServiceWordDelegate()
            sud?.delegate = mockDelegate
            
            let testWord1 = "test1"
            sud?.addNewWord(testWord1)
            XCTAssertEqual(mockDelegate.incrementOfCallCanWriteNewWord, 1)
            
        }
        
        
        func test_add_new_word_must_call_can_write_new_word_delegate_twice() {
            
            let mockDelegate = MockServiceWordDelegate()
            sud?.delegate = mockDelegate
            
            let testWord1 = "test1"
            let testWord2 = "test2"
            sud?.addNewWord(testWord1)
            sud?.addNewWord(testWord2)
            XCTAssertEqual(mockDelegate.incrementOfCallCanWriteNewWord, 2)
            
        }
        
        func test_add_new_word_must_call_can_write_new_word_and_not_maxWord_delegate() {
            
            let mockDelegate = MockServiceWordDelegate()
            sud?.delegate = mockDelegate
            
            let testWord1 = "test1"
            sud?.addNewWord(testWord1)
            XCTAssertEqual(mockDelegate.incrementOfCallMaxWordsAuthorized, 0)
        }
        
        func test_add_new_word_must_call_maxWord_delegate_and_not_can_write_new_word() {
               
               let mockDelegate = MockServiceWordDelegate()
               sud?.delegate = mockDelegate
               
            for i in 0...11 {
                sud?.addNewWord("word\(i)")
            }
    XCTAssertEqual(mockDelegate.incrementOfCallMaxWordsAuthorized, 1)
           }
        
        
    }

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
