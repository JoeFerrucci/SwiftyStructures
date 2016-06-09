//
//  LinkedList.swift
//  SwiftyStructures
//
//  Created by Eddie Kaiger on 4/30/16.
//  Copyright © 2016 Eddie Kaiger. All rights reserved.
//

/**
 A basic generic node class that contains an element and a reference to another node.
*/
public class Node<Element> {

    /// The element data stored in this node.
    public var element: Element

    /// The next node.
    public internal(set) var next: Node<Element>? = nil {
        didSet {
            if next?.previous !== self {
                next?.previous = self
            }
        }
    }

    /// The previous node.
    public internal(set) var previous: Node<Element>? = nil {
        didSet {
            if previous?.next !== self {
                previous?.next = self
            }
        }
    }

    /**
     Creates a new node with the specified element.

     - parameter    element:    The data to store in the node.
     */
    public init(element: Element) {
        self.element = element
    }
}

/**
 A generator for accessing a linked list iteratively.
*/
public struct LinkedListGenerator<Element>: GeneratorType {

    private(set) var currentNode: Node<Element>?

    /**
     Creates a new linked list generator.
     
     - parameter    head:   The head of the linked list.
    */
    internal init(head: Node<Element>?) {
        self.currentNode = head
    }

    /**
     Returns the next element in the linked list, or `nil`.
    */
    public mutating func next() -> Element? {
        let curr = currentNode
        currentNode = currentNode?.next
        return curr?.element
    }
}

/**
 A data structure representing a doubly linked list.
*/
public struct LinkedList<Element> {

    /// The head of the linked list, or nil if the list is empty.
    public internal(set) var head: Node<Element>? = nil {
        didSet {
            head?.previous = nil
        }
    }

    /// The tail of the linked list, or nil if the list is empty.
    public internal(set) var tail: Node<Element>? = nil {
        didSet {
            tail?.next = nil
        }
    }

    /// The number of nodes in the list.
    public private(set) var count: Int = 0

    /// `true` if the list contains no nodes.
    public var isEmpty: Bool {
        return count == 0
    }

    /**
     Creates an empty new list.
    */
    public init() { }

    /**
     Creates a new list with the elements, in the same order.
     
     - parameter:   elements:   The elements that should make up the linked list.
    */
    public init(arrayLiteral elements: Element...) {
        for element in elements {
            append(element)
        }
    }

    /**
     Appends a new element to the linked list. An O(1) operation.
     
     - parameter    element:    The element to append to the end of the list.
    */
    public mutating func append(element: Element) {
        insert(element, previousNode: tail)
    }

    /**
     Inserts a new node into the list, either at the beginning of the list or right before another node (if `previousNode` is provided). To insert an element at the end of the list, you can use `append(element:)`. Runs in O(1) time.
     
     - parameter    element:        The element to insert into the list.
     - parameter    previousNode:   The node after which to insert the new element. If `nil`, will insert at the beginning of the list, creating a `head` if the list is empty.
    */
    public mutating func insert(element: Element, previousNode: Node<Element>? = nil) {
        let newNode = Node(element: element)

        defer {
            count += 1
        }

        guard let previousNode = previousNode else {
            guard let head = head else {
                self.head = newNode
                tail = self.head
                return
            }
            newNode.next = head
            self.head = newNode
            return
        }

        newNode.next = previousNode.next
        previousNode.next = newNode
        if previousNode === tail {
            tail = newNode
        }
    }

    /**
     Deletes a node from the list (assumes that the node is part of the list). Runs in O(1) time.
     
     - parameter    node:   The node to delete from the list.
    */
    public mutating func delete(node: Node<Element>) {
        if node === head {
            head = node.next
        }
        if node === tail {
            tail = node.previous
        }

        node.previous?.next = node.next
        count -= 1
    }
}

extension LinkedList: ArrayLiteralConvertible { }

extension LinkedList: SequenceType {

    public typealias Generator = LinkedListGenerator<Element>

    /**
     Creates a generator over the linked list.
    */
    public func generate() -> Generator {
        return LinkedListGenerator(head: head)
    }
}

public func ==<Element: Equatable>(lhs: LinkedList<Element>, rhs: LinkedList<Element>) -> Bool {
    guard lhs.count == rhs.count else { return false }
    var leftGenerator = lhs.generate(), rightGenerator = rhs.generate()
    while let left = leftGenerator.next() {
        if left != rightGenerator.next() {
            return false
        }
    }
    return true
}
