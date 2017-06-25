//  Copyright © 2017 Derk Gommers. All rights reserved.

import Foundation

protocol ArticleListInteractor {
    func articles(completion: @escaping ([String]) -> Void)
}

struct ArticleListZalandoInteractor: ArticleListInteractor {
    var session: URLSessionType = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)

    func articles(completion: @escaping ([String]) -> Void) {
        let url = URL(string: "https://api.zalando.com/articles?fields=name")!
        session.request(with: url) { data, _, _ in
            let root = data?.json as? [String: Any]
            let content = root?["content"] as? [[String: String]]
            let names = content?.flatMap { $0["name"] }
            completion(names ?? [])
        }
    }
}

protocol URLSessionType {
    func request(with: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: URLSessionType {
    func request(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: url, completionHandler: completionHandler).resume()
    }
}

extension Data {
    var json: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
}
