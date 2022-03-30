// https://github.com/Quick/Quick
//
//  Tests.swift
//  MysticViewContentStateSupportingByWebOperationContent
//
//  Created by Hai Feng Kao on 30/03/2022.
//  Copyright © 2022 com.howgeli. All rights reserved.
//

import Foundation
import MysticViewContentStateSupportingByWebOperationContent
import Nimble
import Quick

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        xdescribe("these will fail") {
            it("can do maths") {
                expect(1) == 2
            }

            it("can read") {
                expect("number") == "string"
            }

            it("will eventually fail") {
                expect("time").toEventually(equal("done"))
            }

            context("these will pass") {
                it("can do maths") {
                    expect(23) == 23
                }

                it("can read") {
                    expect("🐮") == "🐮"
                }

                it("will eventually pass") {
                    var time = "passing"

                    DispatchQueue.main.async {
                        time = "done"
                    }

                    waitUntil { done in
                        Thread.sleep(forTimeInterval: 0.5)
                        expect(time) == "done"

                        done()
                    }
                }
            }
        }
    }
}
