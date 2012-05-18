# SSPullToRefresh

There are dozens of pull to refresh views. I've never found one I'm happy with. I always end up customizing one, so I decided to write one that's highly customizable. You can just write you view and forget about the actual pull to refresh details.

## Example Usage

``` objective-c
- (void)viewDidLoad {
   [super viewDidLoad];
   self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
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

## Thanks

I took some inspiration from [PullToRefreshView by chpwn](https://github.com/chpwn/PullToRefreshView), which is based on [EGOTableViewPullRefresh](https://github.com/enormego/EGOTableViewPullRefresh), which is inspired by Tweetie 2's pull to refresh by [Loren Brichter](http://twitter.com/lorenb). And around we go.

Enjoy.
