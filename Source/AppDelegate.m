#import "AppDelegate.h"
#import "BenchmarkViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BenchmarkViewController *benchmarkViewController = [[BenchmarkViewController alloc] initWithNibName:nil bundle:nil];

    window.rootViewController = benchmarkViewController;
    [window makeKeyAndVisible];
    self.window = window;

    return YES;
}

@end
