//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSArray *filterdData;

- (void)fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessWithQuery:@"Restaurants" params:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    self.tableView.estimatedRowHeight = 68.0; // Needed!!!
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"Yelp";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 140.0, 30.0)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(5.0, 0.0, 130.0, 30.0)];
//    searchBarView.autoresizingMask = 0;
    searchBar.delegate = self;
//    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBar;
    //self.navigationItem.titleView = searchBarView
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
    //return self.filterdData.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];

    cell.business = self.businesses[indexPath.row];
    //cell.business = self.filterdData[indexPath.row];

    return cell;
    
}


- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.filterdData = self.businesses;
    if ([searchText length] == 0) {
        NSLog(@"Search no Keyword");
        //self.filterdData = self.businesses;
    }
    else {
        NSLog(@"Search with Keyword : %@",searchText);
        [self fetchBusinessWithQuery:searchText params:nil];

    }
    [self.tableView reloadData];
}


- (void) filterViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters {
    [self fetchBusinessWithQuery:@"Restaurants" params:filters];
    NSLog(@"fire new network event %@", filters);
}

- (void) fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params {

    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        NSArray *businessDictionaries = response[@"businesses"];
        
        self.businesses = [Business businessesWithDictionaries:businessDictionaries];
        
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];

}


- (void)onFilterButton {
    FilterViewController *vc = [[FilterViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}


@end
