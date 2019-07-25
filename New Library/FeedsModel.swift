//
//  FeedsModel.swift
//  New Library
//
//  Created by Марат Нургалиев on 24/07/2019.
//  Copyright © 2019 Марат Нургалиев. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class Feed {
    var id: Int
    var text: String
    
    init(id: Int, text: String) {
        self.id = id
        self.text = text
    }
}

class GetFeedInfoResponse: Feed {
}

class FeedsViewModel {
    
    let feedsObservable: Observable<[Feed]>
    let clickObservable: Observable<GetFeedInfoResponse>
    
    // If some process in progress
    let indicator: Observable<Bool>
    
    init(input: (UITableView), dependency: (API: APIManager, wireframe: Wireframe)) {
        let API = dependency.API
        let wireframe = dependency.wireframe
        
        let indicator = ViewIndicator()
        self.indicator = indicator.asObservable()
        
        feedsObservable = API.getFeeds()
            .trackView(indicator)
            .map { getFeedResponse in
                return getFeedResponse.data
            }
            .catchError { error in
                return wireframe.promptFor(String(error), cancelAction: "OK", actions: [])
                    .map { _ in
                        return error
                    }
                    .flatMap { error in
                        return Observable.error(error)
                }
            }
            .shareReplay(1)
        
        clickObservable = input
            .rx_modelSelected(Feed)
            .flatMap { feed in
                return API.getFeedInfo(feed.id).trackView(indicator)
            }
            .catchError { error in
                return wireframe.promptFor(String(error), cancelAction: "OK", actions: [])
                    .map { _ in
                        return error
                    }
                    .flatMap { error in
                        return Observable.error(error)
                }
            }
            // If error when click uitableview - set retry() if you want to click cell again
            .retry()
            .shareReplay(1)
    }
}
