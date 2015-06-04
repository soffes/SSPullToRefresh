# SSPullToRefresh

[![Version](https://img.shields.io/github/release/soffes/sspulltorefresh.svg)](https://github.com/soffes/sspulltorefresh/releases) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/sspulltorefresh.svg)](https://cocoapods.org/pods/sspulltorefresh)

There are dozens of pull to refresh views. I've never found one I'm happy with. I always end up customizing one, so I decided to write one that's highly customizable. You can just write your content view and forget about the actual pull to refresh details.

If you're using SSPullToRefresh in your application, add it to [the list](https://github.com/soffes/sspulltorefresh/wiki/Applications).


## Example Usage

``` objective-c
// If automaticallyAdjustsScrollViewInsets is set to NO:
- (void)viewDidLoad {
   [super viewDidLoad];
   self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
}

// If automaticallyAdjustsScrollViewInsets is set to YES:
- (void)viewDidLayoutSubviews {
   if(self.pullToRefreshView == nil) {
      self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
   }
}

- (void)viewDidUnload {
   [super viewDidUnload];
   self.pullToRefreshView = nil;
}

- (void)refresh {
   [self.pullToRefreshView startLoading];
   // Load data...
   [self.pullToRefreshView finishLoading];
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
   [self refresh];
}
```

I generally make a property called `loading` in my view controller and just set that to `YES` inside refresh. Then in my custom setter, return if it's already `YES`. When it changes states, it will call `startLoading` and make the network call. Then when the network activity finishes, it will set it to `NO` and the customer setter handles calling `finishLoading` and doing whatever else.

The fine folks at [NSScreencast](http://nsscreencast.com) have an excellent episode on SSPullToRefresh and even implementing a custom content view with Core Graphics. [Check it out](http://nsscreencast.com/episodes/24-pull-to-refresh).


## Customizing

SSPullToRefresh view is highly customizable. All of the pulling logic, animations, etc are wrapped up for you in SSPullToRefreshView. It doesn't have any UI. Its `contentView` handles displaying the UI. By default, it sets up an instance of [`SSSimplePullToRefreshContentView`](https://github.com/samsoffes/sspulltorefresh/blob/master/SSSimplePullToRefreshContentView.h) as the `contentView`.

### Provided Content Views

[SSPullToRefreshDefaultContentView](https://github.com/samsoffes/sspulltorefresh/blob/master/SSPullToRefreshDefaultContentView.h) and [SSPullToRefreshSimpleContentView](https://github.com/samsoffes/sspulltorefresh/blob/master/SSPullToRefreshSimpleContentView.h) are provided by SSPullToRefresh. By default `SSPullToRefreshDefaultContentView` is used if you do not provide a content view. To use the provided simple content view, simply set it:

``` objective-c
pullToRefreshView.contentView = [[SSPullToRefreshSimpleContentView alloc] initWithFrame:CGRectZero];
```

### Custom Content Views

You can simply subclass `SSPullToRefreshDefaultContentView` or implement your own view that conforms to `SSPullToRefreshContentView`. You must implement the following method:

``` objective-c
- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view
```
This method will get called whenever the state changes. Here are the possible states. It is recommended to implement UI for most of the states, but you can do whatever you want.

* `SSPullToRefreshViewStateNormal` (*recommended*) — Most will say "Pull to refresh" in this state
* `SSPullToRefreshViewStateReady` (*recommended*) — Most will say "Release to refresh" in this state
* `SSPullToRefreshViewStateLoading` (*recommended*) — The view is loading
* `SSPullToRefreshViewStateClosing` (*optional*) — The view has finished loading and is animating closed

You may also optionally implement this method:

``` objective-c
- (void)setLastUpdatedAt:(NSDate *)date withPullToRefreshView:(SSPullToRefreshView *)view
```


## Adding To Your Project

[Carthage](https://github.com/carthage/carthage) is the recommended way to install SSPullToRefresh. Add the following to your Cartfile:

``` ruby
github "soffes/sspulltorefresh"
```

You can also install with [CocoaPods](https://cocoapods.org):

``` ruby
pod 'SSPullToRefresh'
```

For manual installation, I recommend adding the project as a subproject to your project or workspace and adding the framework as a target dependency.


## Thanks

I took some inspiration from [PullToRefreshView by chpwn](https://github.com/chpwn/PullToRefreshView), which is based on [EGOTableViewPullRefresh](https://github.com/enormego/EGOTableViewPullRefresh), which is inspired by Tweetie's pull to refresh by [Loren Brichter](http://twitter.com/lorenb). And around we go.

Enjoy.
