//
//  MockLogService.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 27. 1. 2025..
//

import Testing

final class MockLogService: LogService, @unchecked Sendable {
    
    // swiftlint:disable:next large_tuple
    var identifiedUsers: [(userId: String, name: String?, email: String?)] = []
    var trackedEvents: [AnyLoggableEvent] = []
    var addedUserProperties: [[String: Any]] = []
    
    func identifyUser(userId: String, name: String?, email: String?) {
        identifiedUsers.append((userId, name, email))
    }
    
    func addUserProperties(dict: [String: Any], isHighPriority: Bool) {
        addedUserProperties.append(dict)
    }
    
    func deleteUserProfile() {
        // Implement if needed for specific tests
    }
    
    func trackEvent(event: LoggableEvent) {
        let anyEvent = AnyLoggableEvent(eventName: event.eventName, parameters: event.parameters, type: event.type)
        trackedEvents.append(anyEvent)
    }
    
    func trackScreenView(event: LoggableEvent) {
        let anyEvent = AnyLoggableEvent(eventName: event.eventName, parameters: event.parameters, type: event.type)
        trackedEvents.append(anyEvent)
    }
}
