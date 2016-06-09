 //
//  SwiftyStructuresTests.swift
//  SwiftyStructuresTests
//
//  Created by Eddie Kaiger on 4/30/16.
//  Copyright © 2016 Eddie Kaiger. All rights reserved.
//

import XCTest
@testable import SwiftyStructures

class SwiftyStructuresTests: XCTestCase {

    // MARK: - Node

    func testNode_initializer() {
        let node = Node(element: 5)
        XCTAssertEqual(node.element, 5)
        XCTAssertNil(node.next)
    }

    func testNode_setsElement() {
        let node = Node(element: 1)
        XCTAssertEqual(node.element, 1)
        node.element = 2
        XCTAssertEqual(node.element, 2)
    }

    func testNode_setsNext() {
        let firstNode = Node(element: "a")
        let secondNode = Node(element: "b")
        XCTAssertNil(firstNode.next)
        firstNode.next = secondNode
        XCTAssert(firstNode.next === secondNode)
        XCTAssertNil(secondNode.next)
        XCTAssert(secondNode.previous === firstNode)
        XCTAssertNil(firstNode.previous)
    }

    func testNode_setsPrevious() {
        let firstNode = Node(element: "a")
        let secondNode = Node(element: "b")
        XCTAssertNil(secondNode.previous)
        secondNode.previous = firstNode
        XCTAssert(firstNode.next === secondNode)
        XCTAssertNil(secondNode.next)
        XCTAssert(secondNode.previous === firstNode)
        XCTAssertNil(firstNode.previous)
    }

    // MARK: - Linked List Generator

    func testLinkedListGenerator_initializer() {
        let generator = LinkedListGenerator(head: Node(element: "hey"))
        XCTAssertEqual(generator.currentNode!.element, "hey")
    }

    func testLinkedListGenerator_next() {
        let head = Node(element: 1)
        let second = Node(element: 2)
        let third = Node(element: 3)
        head.next = second
        second.next = third
        var generator = LinkedListGenerator<Int>(head: head)
        XCTAssertEqual(generator.next()!, head.element)
        XCTAssertEqual(generator.next()!, second.element)
        XCTAssertEqual(generator.next()!, third.element)
        XCTAssertNil(generator.next())
    }

    // MARK: - Linked List

    func testLinkedList_initializer() {
        let list = LinkedList<Int>()
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        XCTAssertEqual(list.count, 0)
        XCTAssert(list.isEmpty)
    }

    func testLinkedList_arrayLiteralInitializer() {
        let list: LinkedList<Int> = [5, 4, 3]
        XCTAssertEqual(list.head!.element, 5)
        XCTAssertEqual(list.head!.next!.element, 4)
        XCTAssertEqual(list.tail!.element, 3)
        XCTAssertEqual(list.count, 3)
    }

    func testLinkedList_append() {
        var list = LinkedList<Int>()
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        list.append(5)
        XCTAssertEqual(list.count, 1)
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.head!.element, 5)
        XCTAssertEqual(list.tail!.element, 5)
        XCTAssert(list.head! === list.tail!)
        XCTAssertNil(list.head!.next)
        list.append(12)
        XCTAssertEqual(list.count, 2)
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.head!.element, 5)
        XCTAssertEqual(list.tail!.element, 12)
        XCTAssert(list.head! !== list.tail!)
        XCTAssert(list.head!.next === list.tail!)
    }

    func testLinkedList_insert() {
        var list = LinkedList<Int>()
        list.insert(14)
        XCTAssertEqual(list.count, 1)
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.head!.element, 14)
        XCTAssertEqual(list.tail!.element, 14)
        XCTAssert(list.head! === list.tail!)
        list.insert(1)
        XCTAssertEqual(list.count, 2)
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.head!.element, 1)
        XCTAssertEqual(list.tail!.element, 14)
        XCTAssert(list.head! !== list.tail!)
        XCTAssert(list.head!.next === list.tail!)
        list.insert(32, previousNode: list.head!)
        XCTAssertEqual(list.head!.element, 1)
        XCTAssertEqual(list.head!.next!.element, 32)
        XCTAssertEqual(list.count, 3)
        XCTAssertFalse(list.isEmpty)
        XCTAssert(list.head!.next!.next === list.tail!)
        XCTAssertNil(list.tail!.next)
    }

    func testLinkedList_delete() {
        var list: LinkedList<Int> = [5, 6, 2, 3]
        XCTAssertEqual(list.count, 4)
        XCTAssertEqual(list.head!.element, 5)
        list.delete(list.head!)
        XCTAssertEqual(list.count, 3)
        XCTAssert(list == [6, 2, 3])
        XCTAssertEqual(list.head!.element, 6)
        list.delete(list.head!.next!)
        XCTAssertEqual(list.count, 2)
        XCTAssert(list == [6, 3])
        XCTAssertEqual(list.head!.element, 6)
        XCTAssert(list.head!.next === list.tail!)
        list.delete(list.tail!)
        XCTAssertEqual(list.count, 1)
        XCTAssert(list == [6])
        XCTAssertEqual(list.head!.element, 6)
        XCTAssert(list.head! === list.tail!)
        list.delete(list.head!)
        XCTAssert(list.isEmpty)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }

}
