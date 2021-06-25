// File created from ScreenTemplate
// $ createScreen.sh Room/NotificationSettings RoomNotificationSettings
/*
 Copyright 2020 New Vector Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

protocol RoomNotificationSettingsViewModelViewDelegate: AnyObject {
    func roomNotificationSettingsViewModel(_ viewModel: RoomNotificationSettingsViewModelType, didUpdateViewState viewSate: RoomNotificationSettingsViewState)
}

protocol RoomNotificationSettingsViewModelCoordinatorDelegate: AnyObject {
    func roomNotificationSettingsViewModelDidComplete(_ viewModel: RoomNotificationSettingsViewModelType)
    func roomNotificationSettingsViewModelDidCancel(_ viewModel: RoomNotificationSettingsViewModelType)
}

/// Protocol describing the view model used by `RoomNotificationSettingsViewController`
protocol RoomNotificationSettingsViewModelType {        
        
    var viewDelegate: RoomNotificationSettingsViewModelViewDelegate? { get set }
    var coordinatorDelegate: RoomNotificationSettingsViewModelCoordinatorDelegate? { get set }
    
    func process(viewAction: RoomNotificationSettingsViewAction)
}
