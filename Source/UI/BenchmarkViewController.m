#import "BenchmarkViewController.h"
#import "CoreDataBenchmark.h"

@interface BenchmarkViewController ()

@end

@implementation BenchmarkViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[[CoreDataBenchmark alloc] init] runWithChannelsCount:100 programsCount:8000];
    [[[CoreDataBenchmark alloc] initWithRelationShipsEnabled:NO] runWithChannelsCount:100 programsCount:8000];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
