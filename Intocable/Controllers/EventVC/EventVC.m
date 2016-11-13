//
//  EventVC.m
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "EventVC.h"
#import "EventCell.h"
#import "EventDetailVC.h"
#import "CommonHelper.h"
#import "XMLDictionary.h"
#import "EventObj.h"
@interface EventVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSTimer *timer;
    NSMutableArray *_arrEvents;
    NSMutableArray *_arrSectionDays;
}

@end

@implementation EventVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
    }
}
-(void) viewWillAppear:(BOOL)animated{
    if ([self isLandScape]) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
    }
    
    if (![CommonHelper appDelegate].isEvents) {
        _arrSectionDays =[[NSMutableArray alloc] init];
        _arrEvents =[[NSMutableArray alloc] init];
        [self.tblEvents reloadData];
        [CommonHelper showBusyView];
        timer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callWS) userInfo:nil repeats:YES];

    }
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
    if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight) {
        [self setFrameRotated];
    }
    else{
        [self setFrameNormal];
    }
}
-(void) setFrameNormal{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
    }
    else
    {
        if (IPHONE_5) {
            [self.tblEvents setFrame:CGRectMake(0, 0, 320, 418)];
        }
        else
        {
            [self.tblEvents setFrame:CGRectMake(0, 0, 320, 330)];
        }
        
    }
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
    }
    else
    {
        
        [self.tblEvents setFrame:CGRectMake(0, 0, 568, 170)];
        
    }
}

-(BOOL) isLandScape{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ((orientation == UIInterfaceOrientationLandscapeLeft)||(orientation == UIInterfaceOrientationLandscapeRight))
    {
        return YES;
    }
    return NO;
}
- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) callWS
{
    [timer invalidate];
    timer = nil;
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    NSURL *URL;
    if (language==1) {
        URL = [[NSURL alloc] initWithString:LINK_EVENT_ENGLISH];
        self.lblTitle.text =@"Events";
    }
    else
    {
        URL = [[NSURL alloc] initWithString:LINK_EVENT_SPANISH];
        self.lblTitle.text =@"Eventos";
    }
    

    if (![CommonHelper connectedInternet]) {
        [CommonHelper showAlert:ERROR_NETWORK];
        [CommonHelper hideBusyView];
        return;
    }
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    
    NSDictionary *arr = [xmlDoc objectForKey:@"Sections"];
    
    NSDictionary *section = [arr objectForKey:@"Section"];
    NSDictionary *events =[section objectForKey:@"Events"];
    NSLog(@"Events %d",events.count);
   
    NSArray *date =[events objectForKey:@"Date"];
    if (date.count>0) {
        if (date.count==1) {
            NSDictionary *dic = date[0];
            EventObj *eventObj =[[EventObj alloc] init];
            NSDictionary *event =[dic objectForKey:@"Event"];
            NSDictionary *address = [event objectForKey:@"Address"];
            eventObj.title = [event objectForKey:@"Title"];
            eventObj.eventID = [event objectForKey:@"_ID"];
            eventObj.time = [event objectForKey:@"_Time"];
            eventObj.city = [address objectForKey:@"_City"];
            eventObj.state = [address objectForKey:@"_State"];
            eventObj.zip = [address objectForKey:@"_Zip"];
            eventObj.text = [address objectForKey:@"__text"];
            eventObj.day = [dic objectForKey:@"_Day"];
            [_arrEvents addObject:eventObj];
            
            if ([_arrSectionDays containsObject:[dic objectForKey:@"_Day"]]) {
                NSLog(@"Giong");
            }
            else
            {
                [_arrSectionDays addObject:[dic objectForKey:@"_Day"]];
            }

        }
        else
        {
            for (NSDictionary *dic in date) {
                EventObj *eventObj =[[EventObj alloc] init];
                NSDictionary *event =[dic objectForKey:@"Event"];
                NSDictionary *address = [event objectForKey:@"Address"];
                eventObj.title = [event objectForKey:@"Title"];
                eventObj.eventID = [event objectForKey:@"_ID"];
                eventObj.time = [event objectForKey:@"_Time"];
                eventObj.city = [address objectForKey:@"_City"];
                eventObj.state = [address objectForKey:@"_State"];
                eventObj.zip = [address objectForKey:@"_Zip"];
                eventObj.text = [address objectForKey:@"__text"];
                eventObj.day = [dic objectForKey:@"_Day"];
                [_arrEvents addObject:eventObj];
                
                if ([_arrSectionDays containsObject:[dic objectForKey:@"_Day"]]) {
                    NSLog(@"Giong");
                }
                else
                {
                    [_arrSectionDays addObject:[dic objectForKey:@"_Day"]];
                }
            }

        }
    }
    

    [CommonHelper appDelegate].isEvents = YES;
    [self.tblEvents reloadData];
    [CommonHelper hideBusyView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doHome:(id)sender {
    [[CommonHelper appDelegate] goHome];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrSectionDays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr =[[NSMutableArray alloc] init];
    NSString *str = [_arrSectionDays objectAtIndex:section];
    for (int i = 0;i<_arrEvents.count;i++) {
        EventObj *obj = [_arrEvents objectAtIndex:i];
        if ([str isEqualToString:obj.day]) {
            [arr addObject:obj];
        }
    }
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 66;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [_arrSectionDays objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventCell *currentCell=(EventCell *)[self.tblEvents dequeueReusableCellWithIdentifier:@"EventCell"];
    if (currentCell == nil)
    {
        
        currentCell = [[[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil] objectAtIndex:0];
        
        
    }
    NSString *str =[_arrSectionDays objectAtIndex:indexPath.section];
    NSMutableArray *arr =[[NSMutableArray alloc] init];
    for (int i = 0;i<_arrEvents.count;i++) {
        EventObj *obj = [_arrEvents objectAtIndex:i];
        if ([str isEqualToString:obj.day]) {
            [arr addObject:obj];
        }
    }
    EventObj *obj = [arr objectAtIndex:indexPath.row];

    currentCell.lblTime.text = obj.time;
    currentCell.lblTitle.text = obj.title;
    return currentCell;
}
/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(18,10, tableView.frame.size.width, 20);
    //myLabel.font = [UIFont boldSystemFontOfSize:18];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    headerView.backgroundColor =[UIColor lightGrayColor];
    return headerView;
}*/
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Set the text color of our header/footer text.
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Set the background color of our header/footer.
    header.contentView.backgroundColor = [UIColor grayColor];
    
    // You can also do this to set the background color of our header/footer,
    //    but the gradients/other effects will be retained.
    // view.tintColor = [UIColor blackColor];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str =[_arrSectionDays objectAtIndex:indexPath.section];
    NSMutableArray *arr =[[NSMutableArray alloc] init];
    for (int i = 0;i<_arrEvents.count;i++) {
        EventObj *obj = [_arrEvents objectAtIndex:i];
        if ([str isEqualToString:obj.day]) {
            [arr addObject:obj];
        }
    }
    EventObj *obj = [arr objectAtIndex:indexPath.row];
    if (IS_IPAD) {
         EventDetailVC *detailVC =[[EventDetailVC alloc] initWithNibName:@"EventDetailVC_iPad" bundle:nil];
        detailVC.eventObj = obj;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        EventDetailVC *detailVC =[[EventDetailVC alloc] initWithNibName:@"EventDetailVC" bundle:nil];
        detailVC.eventObj = obj;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}
@end
