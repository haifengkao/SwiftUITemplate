// https://github.com/Quick/Quick
//
//  Tests.swift
//  MyInfrastructureCode
//
//  Created by Hai Feng Kao on 25/03/2022.
//

import Foundation
import MyInfrastructureCode
import Nimble
import Quick

func awaitTest() async -> Int {
    return 1
}

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        it("can call async func") {
            let a = await awaitTest()
            await expect(a) == 1
        }
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
