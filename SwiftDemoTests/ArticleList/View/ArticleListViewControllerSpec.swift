//  Copyright © 2017 Derk Gommers. All rights reserved.

import KIF
import Quick
import Nimble

@testable import SwiftDemoApp

class ArticleListViewControllerSpec: QuickSpec {
    override func spec() {

        var eventHandler: ArticleListEventHandlerStub!
        var subject: ArticleListViewController!

        beforeSuite {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ArticleListViewController")
            let navigationController = UINavigationController(rootViewController: viewController)

            subject = viewController as? ArticleListViewController
            UIApplication.shared.keyWindow?.rootViewController = navigationController
        }

        beforeEach {
            eventHandler = ArticleListEventHandlerStub()
            subject.eventHandler = eventHandler
        }

        func waitForItem(at row: Int) -> ArticleListItemView? {
            let indexPath = IndexPath(row: row, section: 0)
            return self.tester().waitForCellInTableView(at: indexPath) as? ArticleListItemView
        }

        it("has title 'Articles'") {
            expect(subject.navigationItem.title).to(equal("Articles"))
        }

        describe("view will appear") {
            beforeEach {
                subject.viewWillAppear(false)
            }

            it("fires a view will appear event") {
                expect(eventHandler.invokedViewWillAppear).to(beTrue())
            }
        }

        describe("update") {
            describe("three articles available") {
                beforeEach {
                    subject.viewModel = ArticleListViewModel(articles: [.mugshot, .selfie, .apple])
                }

                it("shows the first title") {
                    let item = waitForItem(at: 0)
                    expect(item?.nameLabel?.text).to(equal(ArticleListItemViewModel.mugshot.name))
                }

                it("shows the first price") {
                    let item = waitForItem(at: 0)
                    expect(item?.priceLabel?.text).to(equal(ArticleListItemViewModel.mugshot.price))
                }

                it("shows the last title") {
                    let item = waitForItem(at: 2)
                    expect(item?.nameLabel?.text).to(equal(ArticleListItemViewModel.apple.name))
                }
            }

            describe("many articles available") {
                let numberOfArticles = 40

                beforeEach {
                    subject.viewModel = ArticleListViewModel(articles:
                        Array(repeating: .mugshot, count: numberOfArticles)
                    )
                }

                describe("scroll to last row") {
                    beforeEach {
                        _ = waitForItem(at: numberOfArticles - 1)
                    }

                    it("fires a view did reach bottom event") {
                        expect(eventHandler.invokedDidReachBottom).to(beTrue())
                    }
                }
            }
        }
    }
}

extension ArticleListItemViewModel {
    static let mugshot = ArticleListItemViewModel(name: "Mugshot Maker PRO+", price: "€ 100", image: nil)
    static let selfie = ArticleListItemViewModel(name: "Selfie Stick", price: nil, image: nil)
    static let apple = ArticleListItemViewModel(name: "Apple iPhone", price: "€ 50.00", image: nil)
}