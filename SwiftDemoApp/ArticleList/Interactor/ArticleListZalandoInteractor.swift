//  Copyright © 2017 Derk Gommers. All rights reserved.

import Foundation

protocol ArticleListInteractor {
    func articles(page: UInt, completion: @escaping ([Article]) -> Void)
}

struct ArticleListZalandoInteractor: ArticleListInteractor {

    var session: URLSessionType = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    private let host = "api.zalando.com"

    func articles(page: UInt, completion: @escaping ([Article]) -> Void) {
        let url = URL(string: "https://\(host)/articles?fields=name,units.price.formatted&page=\(page)")!
        session.request(with: url) { data, _, _ in
            let root = data?.json as? [String: Any]
            let content = root?["content"] as? [Any]
            let articles = content?.map { Article(json: $0) }
            completion(articles ?? [])
        }
    }
}

private extension Data {
    var json: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
}
