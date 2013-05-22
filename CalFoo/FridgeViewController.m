//
//  FridgeViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/21/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "FridgeViewController.h"
#import "CalFooAppDelegate.h"
#import "FoodItem.h"
#import "FridgeItemViewController.h"

@interface FridgeViewController ()

@end

@implementation FridgeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // Register for notification involving changes of the fridge.
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fridgeChanged:) name:kFridgeChangedNotification object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//
// If any object besides this controller has modified the global fridge,
// then we need to reload the table data.
//
-(void)fridgeChanged:(NSNotification*)notification {
    if (notification.object != self) {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.fridge count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FridgeFoodCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    FoodItem *item = [appDelegate.fridge objectAtIndex:indexPath.row];
    cell.textLabel.text = item.description;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"srv=%0.2g %@, %0.0f/%0.0f/%0.0f %0.0f Cals", item.servingSize, item.servingUnits, item.fatGrams, item.carbsGrams, item.proteinGrams, item.calories];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.fridge removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFridgeChangedNotification object:self];
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    FoodItem *item  = [appDelegate.fridge objectAtIndex:fromIndexPath.row];
    [appDelegate.fridge removeObjectAtIndex:fromIndexPath.row];
    [appDelegate.fridge insertObject:item atIndex:toIndexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFridgeChangedNotification object:self];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

//-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    accessoryButtonIndexPath = indexPath;
//    [self performSegueWithIdentifier:@"FridgeItemDetailSegue" sender:self];
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FridgeItemDetailSegue"]) {
        FridgeItemViewController *viewController = (FridgeItemViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        viewController.fridgeIndex = indexPath.row;
    } else if ([segue.identifier isEqualToString:@"FridgeAddItemSegue"]) {
        UINavigationController *navController = (UINavigationController*)segue.destinationViewController;
        FridgeItemViewController *viewController = (FridgeItemViewController*)navController.topViewController;
        viewController.fridgeIndex = -1;
    }
}

@end
