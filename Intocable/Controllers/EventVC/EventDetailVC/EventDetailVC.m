//
//  EventDetailVC.m
//  Intocable
//
//  Created by Neeraj on 10/9/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "EventDetailVC.h"
#import "CommentCell.h"
#import "LocationVC.h"
#import "PostCommentVC.h"
#import "XMLDictionary.h"
#import "CommonHelper.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "CommentObj.h"
@interface EventDetailVC ()<UIViewControllerTransitioningDelegate,NSXMLParserDelegate>
{
    NSTimer *timer;
    NSString *_linkViewMap;
    NSString *_linkPurchase;
    NSString *_linkCheckIn;
    NSMutableArray *_arrComment;
    NSString *_titleMap;
}
@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSString *currentElement;
@end

@implementation EventDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   
    [CommonHelper showBusyView];
   
    if (IS_IPAD) {
        
    }
    else
    {
        if (!IPHONE_5) {
            [self.scrollPage setContentSize:CGSizeMake(320,350)];
            [self.tblComment setFrame:CGRectMake(self.tblComment.frame.origin.x,self.tblComment.frame.origin.y,320,self.tblComment.frame.size.height-88)];
        }
        
    }
    [self.scrollPage addSubview:self.subFlyer];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
 [self.imgEvent addGestureRecognizer:tapRecognizer];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void) callWS
{
    [timer invalidate];
    timer = nil;
    _arrComment = [[NSMutableArray alloc] init];
    if (![CommonHelper connectedInternet]) {
        [CommonHelper showAlert:ERROR_NETWORK];
        [CommonHelper hideBusyView];
        return;
    }
    
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    NSURL *URL;
    if (language==1) {
        URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.grupointocable.com/_ws/intocable/english/xml/eventdetails/%@.xml",self.eventObj.eventID]];
    }
    else
    {
         URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.grupointocable.com/_ws/intocable/spanish/xml/eventdetails/%@.xml",self.eventObj.eventID]];
    }
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSDictionary *event =[xmlDoc objectForKey:@"Event"];
    NSDictionary *info =[event objectForKey:@"Info"];
    // INFO
    self.lblTitle.text = [info objectForKey:@"_Title"];
    self.lblAdress.text = [NSString stringWithFormat:@"%@,%@",[info objectForKey:@"_State"],[info objectForKey:@"_City"]];
    self.lblDate.text = [info objectForKey:@"_Day"];
    self.lblTime.text = [info objectForKey:@"_Time"];
    
    NSDictionary *links = [event objectForKey:@"Links"];
    NSArray *arr =[links objectForKey:@"Link"];
    NSDictionary *dicMap = arr[0];
    _linkViewMap = [dicMap objectForKey:@"_ActionURL"];
    _titleMap = [dicMap objectForKey:@"_Title"];
    NSDictionary *dicPurchase = arr[1];
    _linkPurchase = [dicPurchase objectForKey:@"_ActionURL"];
    NSDictionary *dicCheckIn = arr[2];
    _linkCheckIn = [dicCheckIn objectForKey:@"_ActionURL"];
    
    
    NSDictionary *photos = [event objectForKey:@"Photos"];
    NSDictionary *photo = [photos objectForKey:@"Photo"];
    [self getImageForImageView:self.imgEvent imageUrl:[photo objectForKey:@"_LargeImageURL"]];
    self.lblTitlePage.text =[xmlDoc objectForKey:@"_Name"];
    [self downloadDataFromURL:URL withCompletionHandler:^(NSData *data) {
        // Check if any data returned.
        if (data != nil) {
            self.xmlParser = [[NSXMLParser alloc] initWithData:data];
            self.xmlParser.delegate = self;
            
            
            // Start parsing.
            [self.xmlParser parse];
        }
    }];

}

-(void) callAgain
{
    if (![CommonHelper connectedInternet]) {
        [CommonHelper showAlert:ERROR_NETWORK];
        [CommonHelper hideBusyView];
        return;
    }
    
    [CommonHelper showBusyView];
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    NSURL *URL;
    if (language==1) {
        URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.grupointocable.com/_ws/intocable/english/xml/eventdetails/%@.xml",self.eventObj.eventID]];
    }
    else
    {
        URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.grupointocable.com/_ws/intocable/spanish/xml/eventdetails/%@.xml",self.eventObj.eventID]];
    }
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSDictionary *event =[xmlDoc objectForKey:@"Event"];
    NSDictionary *arr_comments = [event objectForKey:@"Comments"];
    NSLog(@"Comment %@",xmlDoc);
    NSArray *dics= [arr_comments objectForKey:@"Comment"];
    if (_arrComment.count==1) {
        _arrComment =[[NSMutableArray alloc] init];
        NSDictionary *dic = [arr_comments objectForKey:@"Comment"];
        CommentObj *commentObj = [[CommentObj alloc] init];
        commentObj.name = [dic objectForKey:@"_Author"];
        commentObj.content = [dic objectForKey:@"__text"];
        [_arrComment addObject:commentObj];
        [self.tblComment reloadData];
    }
    else
    {
        _arrComment =[[NSMutableArray alloc] init];
        for (NSDictionary *dic in dics) {
            CommentObj *commentObj = [[CommentObj alloc] init];
            commentObj.name = [dic objectForKey:@"_Author"];
            commentObj.content = [dic objectForKey:@"__text"];
            [_arrComment addObject:commentObj];
        }
        [self.tblComment reloadData];
    }
    
    [CommonHelper hideBusyView];
}

- (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %d", HTTPStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    
    // Resume the task.
    [task resume];
}
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    // Initialize the neighbours data array.
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    // When the parsing has been finished then simply reload the table view.
    //[self callAgain];
    NSLog(@"END");
    [CommonHelper hideBusyView];
}
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@", [parseError localizedDescription]);
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    NSLog(@"-------> ELEMENT %@",elementName);
    // If the current element name is equal to "geoname" then initialize the temporary dictionary.
    
    // Keep the current element.
    self.currentElement = elementName;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    NSLog(@"ELEMENT %@",elementName);
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // Store the found characters if only we're interested in the current element.
    NSLog(@"STRING %@",string);
    if ([self.currentElement isEqualToString:@"Comment"]){
        CommentObj *commentObj =[[CommentObj alloc] init];
        commentObj.content = string;
        [_arrComment addObject:commentObj];
    }
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
    [self initLaguage];
     _arrComment =[[NSMutableArray alloc] init];
     timer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callWS) userInfo:nil repeats:YES];
}

-(void) initLaguage
{
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
   
    if (language==1) {
        [self.btnFly setTitle:FLYER_ENGLISH forState:UIControlStateNormal];
        [self.btnViewMap setTitle:VIEW_MAP_ENGLISH forState:UIControlStateNormal];
        [self.btnPurchase setTitle:PURCHASE_ENGLISH forState:UIControlStateNormal];
        [self.btnCheckIn setTitle:CHECK_ENGLISH forState:UIControlStateNormal];
        [self.btnPostaComment setTitle:POST_A_COMMENT_ENGLISH forState:UIControlStateNormal];
    }
    else
    {
        [self.btnFly setTitle:FLYER_SPANISH forState:UIControlStateNormal];
        [self.btnViewMap setTitle:VIEW_MAP_SPANISH forState:UIControlStateNormal];
        [self.btnPurchase setTitle:PURCHASE_SPAINSH forState:UIControlStateNormal];
        [self.btnCheckIn setTitle:CHECK_SPANISH forState:UIControlStateNormal];
        [self.btnPostaComment setTitle:POST_A_COMMENT_SPAINSH forState:UIControlStateNormal];
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
        [self.scrollPage setContentSize:CGSizeMake(768,728)];
    }
    else
    {
         [self.subFlyer setFrame:CGRectMake(0, 0, 320, 310)];
        [self.subComment setFrame:CGRectMake(0, 0, 320, 310)];
        [self.subInfo setFrame:CGRectMake(0, 0, 320, 310)];
        
    }
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [self.scrollPage setContentSize:CGSizeMake(1024,728)];
    }
    else
    {
        if (IPHONE_5) {
            [self.subFlyer setFrame:CGRectMake(124, 0, 320, 310)];
            [self.subComment setFrame:CGRectMake(124, 0, 320, 310)];
            [self.subInfo setFrame:CGRectMake(124, 0, 320, 310)];
        }
        else
        {
            [self.subFlyer setFrame:CGRectMake(80, 0, 320, 310)];
            [self.subComment setFrame:CGRectMake(80, 0, 320, 310)];
            [self.subInfo setFrame:CGRectMake(80, 0, 320, 310)];
        }
        
        
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doFlyer:(id)sender {
    self.imgTab.image =[UIImage imageNamed:@"ic_tab_news_on.png"];
    [self.btnFly setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnInfo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.subFlyer removeFromSuperview];
    [self.subInfo removeFromSuperview];
    [self.subComment removeFromSuperview];
    [self.scrollPage addSubview:self.subFlyer];
}

- (IBAction)doInfo:(id)sender {
    self.imgTab.image =[UIImage imageNamed:@"ic_tab_facebook_on.png"];
    [self.btnFly setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.subFlyer removeFromSuperview];
    [self.subInfo removeFromSuperview];
    [self.subComment removeFromSuperview];
    [self.scrollPage addSubview:self.subInfo];
}

- (IBAction)doComment:(id)sender {
    self.imgTab.image =[UIImage imageNamed:@"ic_tab_tweets_on.png"];
    [self.btnFly setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnInfo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.subFlyer removeFromSuperview];
    [self.subInfo removeFromSuperview];
    [self.subComment removeFromSuperview];
    [self.scrollPage addSubview:self.subComment];
    if (_arrComment.count>0) {
         [self callAgain];
    }
   
}

- (IBAction)doPostComment:(id)sender {
    PostCommentVC *postCommentVC =[[PostCommentVC alloc] init];
    postCommentVC.eventObj = self.eventObj;
    [self.navigationController pushViewController:postCommentVC animated:YES];
}

- (IBAction)doViewMap:(id)sender {
    LocationVC *locationVC =[[LocationVC alloc] init];
    locationVC.strLink =_linkViewMap;
    locationVC.title = _titleMap;
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (IBAction)doPurchase:(id)sender {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:_linkPurchase]];
}

- (IBAction)doCheckIn:(id)sender {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:_linkCheckIn]];
}

- (IBAction)showImage:(id)sender {
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = self.imgEvent.image;
    imageInfo.referenceRect = self.imgEvent.frame;
    imageInfo.referenceView = self.imgEvent.superview;
    imageInfo.referenceContentMode = self.imgEvent.contentMode;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 96;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrComment.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *currentCell=(CommentCell *)[self.tblComment dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (currentCell == nil)
    {
        
        currentCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] objectAtIndex:0];
        
        
    }
    
    CommentObj *obj = [_arrComment objectAtIndex:indexPath.row];
    currentCell.lblName.text = obj.name;
    currentCell.lblContent.text = obj.content;
    currentCell.backgroundColor =[UIColor clearColor];
    return currentCell;
}
- (void) getImageForImageView:(UIImageView *)imageView imageUrl:(NSString *)url {
    dispatch_queue_t queue = dispatch_queue_create([url UTF8String], 0);
    __weak UIImageView *wImageView = imageView;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    indicator.hidesWhenStopped = YES;
    indicator.center = imageView.center;
    
    [imageView addSubview:indicator];
    dispatch_async(queue, ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (wImageView) {
                wImageView.image = image;
               // [self.btnImage setImage:image forState:UIControlStateNormal];
                self.btnImage.imageView.image = image;
                [indicator stopAnimating];
                indicator.hidden = YES;
            }
            
            
        });
    });
}
- (void)bigButtonTapped:(id)sender {
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = self.imgEvent.image;
    imageInfo.referenceRect = self.imgEvent.frame;
    imageInfo.referenceView = self.imgEvent.superview;
    imageInfo.referenceContentMode = self.imgEvent.contentMode;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}


@end
