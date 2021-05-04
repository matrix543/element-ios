// 
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

struct SpaceFeatureUnavailableViewData {    
    let informationText: String
    let shareLink: URL
}

final class SpaceFeatureUnaivableViewController: UIViewController {

    // MARK: - Constants
    
    private enum Constants {
        static let buttonHighlightedAlpha: CGFloat = 0.2
    }
    
    // MARK: - Properties
    
    // MARK: Outlets
        
    @IBOutlet private weak var artworkImageView: UIImageView!
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var generalInfoLabel: UILabel!
    @IBOutlet private weak var shareButton: CustomRoundedButton!
    
    // MARK: Private
 
    private var theme: Theme!
    private var viewData: SpaceFeatureUnavailableViewData!
    
    // MARK: - Setup
    
    class func instantiate(with viewData: SpaceFeatureUnavailableViewData) -> SpaceFeatureUnaivableViewController {
        let viewController = StoryboardScene.SpaceFeatureUnaivableViewController.initialScene.instantiate()
        viewController.theme = ThemeService.shared().theme
        viewController.viewData = viewData
        return viewController
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
                
        self.registerThemeServiceDidChangeThemeNotification()
        self.update(theme: self.theme)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.theme.statusBarStyle
    }
    
    // MARK: - Private
    
    private func registerThemeServiceDidChangeThemeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeServiceDidChangeTheme, object: nil)
    }
    
    @objc private func themeDidChange() {
        self.update(theme: ThemeService.shared().theme)
    }
    
    private func setupViews() {
        self.title = VectorL10n.spaceFeatureUnavailableTitle
        
        self.informationLabel.text = self.viewData.informationText
        self.generalInfoLabel.text = VectorL10n.spaceFeatureUnavailableGeneralInfo
        
        self.shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        self.shareButton.setTitle(VectorL10n.spaceFeatureUnavailableShareLinkAction, for: .normal)
    }
    
    // MARK: - Public
    
    func update(theme: Theme) {
        self.theme = theme
                
        self.view.backgroundColor = theme.backgroundColor
        
        if let navigationBar = self.navigationController?.navigationBar {
            theme.applyStyle(onNavigationBar: navigationBar)
        }
        
        self.informationLabel.textColor = theme.textPrimaryColor
        self.generalInfoLabel.textColor = theme.textSecondaryColor
        
        // Artwork image view
        
        let artworkImage = ThemeService.shared().isCurrentThemeDark() ?   Asset.Images.featureUnavaibleArtworkDark.image : Asset.Images.featureUnavaibleArtwork.image
        
        self.artworkImageView.image = artworkImage
        
        // Share button
        
        self.shareButton.setTitleColor(theme.baseTextPrimaryColor, for: .normal)
        self.shareButton.setTitleColor(theme.baseTextPrimaryColor.withAlphaComponent(Constants.buttonHighlightedAlpha), for: .highlighted)
        self.shareButton.vc_setBackgroundColor(theme.tintColor, for: .normal)
        
        let buttonImage = Asset.Images.shareActionButton.image.vc_tintedImage(usingColor: theme.baseIconPrimaryColor)
        
        self.shareButton.setImage(buttonImage, for: .normal)
    }
    
    func fill(informationText: String, shareLink: URL) {
        self.informationLabel.text = informationText
    }
    
    // MARK: - Private
    
    private func shareWebAppURL() {
        let webAppURL = self.viewData.shareLink
        
        // Set up activity view controller
        let activityItems: [Any] = [ webAppURL ]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // Configure source view when activity view controller is presented with a popover
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.shareButton
            popoverPresentationController.sourceRect = self.shareButton.bounds
            popoverPresentationController.permittedArrowDirections = [.down, .up]
        }
        
        self.present(activityViewController, animated: true)
    }
    
    // MARK: - Action
    
    @IBAction private func shareButtonAction(_ sender: UIButton) {
        self.shareWebAppURL()
    }
}
