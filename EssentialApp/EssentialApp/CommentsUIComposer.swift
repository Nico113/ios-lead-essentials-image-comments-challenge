//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class CommentsUIComposer {
	private init() {}

	private typealias ImageCommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], ImageCommentsAdapter>

	public static func feedComposedWith(
		imageCommentLoader: @escaping () -> AnyPublisher<[ImageComment], Error>
	) -> ListViewController {
		let presentationAdapter = ImageCommentsPresentationAdapter(loader: imageCommentLoader)

		let feedController = makeImageCommentViewController(title: ImageCommentsPresenter.title)
		feedController.onRefresh = presentationAdapter.loadResource

		presentationAdapter.presenter = LoadResourcePresenter(
			resourceView: ImageCommentsAdapter(
				controller: feedController),
			loadingView: WeakRefVirtualProxy(feedController),
			errorView: WeakRefVirtualProxy(feedController),
			mapper: ImageCommentsPresenter.map)

		return feedController
	}

	private static func makeImageCommentViewController(title: String) -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let feedController = storyboard.instantiateInitialViewController() as! ListViewController
		feedController.title = title
		return feedController
	}
}
