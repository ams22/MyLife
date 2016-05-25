//
//  LoginTableViewControllerTests.swift
//  MyLife
//
//  Created by Андрей Решетников on 25.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import XCTest
@testable import MyLife


class LoginTableViewControllerTests: XCTestCase {
    
    var vc: LoginTableViewController!
    var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        vc = nav.childViewControllers.first as! LoginTableViewController
        
        tableView = vc.tableView
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginVK() {
        vc.viewDidLoad()
        XCTAssertNotNil(vc.view.backgroundColor)
        XCTAssertNotNil(vc.navigationController?.navigationBar.tintColor)
        XCTAssertNotNil(vc.navigationController?.navigationBar.barTintColor)
        XCTAssertEqual(tableView.dataSource!.numberOfSectionsInTableView!(tableView), 2)
        XCTAssertEqual(tableView.dataSource!.tableView(tableView, numberOfRowsInSection: 0), 1)
        XCTAssertEqual(tableView.dataSource!.tableView(tableView, numberOfRowsInSection: 1), 3)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
}