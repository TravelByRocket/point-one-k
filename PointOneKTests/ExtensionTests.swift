//
//  ExtensionTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import SwiftUI
import Testing

@testable import PointOneK

final class ExtensionTests {
    @Test func testSequenceKeyPathSortingSelf() {
        let items = [1, 4, 3, 2, 5]
        let sortedItems = items.sorted(by: \.self)

        #expect(sortedItems == [1, 2, 3, 4, 5])
    }

    @Test func testSequenceKeyPathSortingCustom() {
        struct Example: Equatable {
            let value: String
        }

        let example1 = Example(value: "a")
        let example2 = Example(value: "b")
        let example3 = Example(value: "c")
        let array = [example1, example2, example3]

        let sortedItems = array.sorted(by: \.value) {
            $0 > $1
        }

        #expect(sortedItems == [example3, example2, example1])
    }

    @Test func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")
        #expect(data == "The rain in Spain falls mainly on the Spaniards", "The string must match the content of DecodableString.json") // swiftlint:disable:this line_length
    }

    @Test func testDecodingDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode([String: Int].self, from: "DecodableDictionary.json")
        #expect(data.count == 3, "There should be 3 items decoded from DecodableDictionary.json")
        #expect(data["one"] == 1, "The dictionary should contain Int to String mappings")
    }

    @MainActor @Test func testBindingOnChange() {
        var onChangeFunctionRun = false

        func exampleFunctionToCall() {
            onChangeFunctionRun = true
        }

        var storedValue = ""
        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0 }
        )

        let changedBinding = binding.onChange(exampleFunctionToCall)
        changedBinding.wrappedValue = "Test"

        #expect(onChangeFunctionRun, "The onChange() function must be run when the binding is changed")
    }
}
