// Copyright 2016 Cisco Systems Inc
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

class ApplicationLifecycleObserver: NotificationObserver {
    
    static let sharedInstance = ApplicationLifecycleObserver()
    
    override func notificationMapping() -> [(Notification.Name, Selector)] {
        return [(.UIApplicationDidBecomeActive, #selector(onApplicationDidBecomeActive)),
                (.UIApplicationDidEnterBackground, #selector(onApplicationDidEnterBackground))]
    }
    
    func onApplicationDidBecomeActive() {
        Logger.info("Application did become active")
        
        CallManager.sharedInstance.fetchActiveCalls()
        if let webSocketUrl = DeviceService.sharedInstance.webSocketUrl {
            WebSocketService.sharedInstance.connect(URL(string: webSocketUrl)!)
        }
    }
    
    func onApplicationDidEnterBackground() {
        Logger.info("Application did enter background")
        
        WebSocketService.sharedInstance.disconnect()
    }
}
