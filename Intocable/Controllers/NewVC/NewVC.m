//
//  NewVC.m
//  Intocable
//
//  Created by Neeraj on 10/6/14.
//  Copyright (c) 2014 Neeraj. All rights reserved.
//

#import "NewVC.h"
#import "NewCell.h"
#import "CommonHelper.h"
#import "SVProgressHUD.h"
#import "XMLDictionary.h"
#import "NewObj.h"
#import "DetailNewVC.h"
#import "SocialHelpers.h"
@interface NewVC ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    NSTimer *timer;
    NSMutableArray *_arrNews;
    NSMutableArray *_arrFacebooks;
    NSMutableArray *_arrTwitters;
    int indexTab;
    NSMutableArray *_arrSectionDays;
}
@end

@implementation NewVC

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
    self.webview.hidden = YES;
    self.tblNews.hidden = NO;
    [super viewDidLoad];
   
    // Do any additional setup after loading the view from its nib.
}
-(void) callWS
{
    _arrSectionDays =[[NSMutableArray alloc] init];
    [timer invalidate];
    timer = nil;
    
    if (![CommonHelper connectedInternet]) {
        [CommonHelper showAlert:ERROR_NETWORK];
        [SVProgressHUD dismiss];
        return;
    }
    
    int language =[[USER_DEFAULT valueForKey:@"IS_LANGUAGE"] intValue];
    NSURL *URL;
    if (language==1) {
        URL = [[NSURL alloc] initWithString:LINK_NEW_ENGLISH];
    }
    else
    {
        URL = [[NSURL alloc] initWithString:LINK_NEW_SPANISH];
    }
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSLog(@"XML Doc %@",xmlDoc);
    self.lblTitle.text = [xmlDoc objectForKey:@"_Name"];
    NSDictionary *arr = [xmlDoc objectForKey:@"Sections"];
    
    NSDictionary *section = [arr objectForKey:@"Section"];
    NSDictionary *feed =[section objectForKey:@"Feed"];
    NSArray *articles =[feed objectForKey:@"Article"];
    for (NSDictionary *dic in articles) {
        NewObj *obj = [[NewObj alloc] init];
        obj.body = [dic objectForKey:@"Body"];
        obj.title =[dic objectForKey:@"Title"];
        obj.idNew = [dic objectForKey:@"_ID"];
        obj.linkThumbnail = [dic objectForKey:@"_SmallImage"];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:obj.linkThumbnail]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                obj.imgThumbnail = [UIImage imageWithData:data];
                [self.tblNews reloadData];
            });
        });

        obj.linkBigImg = [dic objectForKey:@"_LargeImage"];
        obj.dayPost = [dic objectForKey:@"_Posted"];
        if ([_arrSectionDays containsObject:[dic objectForKey:@"_Posted"]]) {
            NSLog(@"Giong");
        }
        else
        {
            [_arrSectionDays addObject:[dic objectForKey:@"_Posted"]];
        }
        [_arrNews addObject:obj];
    }
    [CommonHelper appDelegate].isNews = YES;
    [self.tblNews reloadData];
    [CommonHelper hideBusyView];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doNews:(id)sender {
    self.webview.hidden = YES;
    self.tblNews.hidden = NO;
    indexTab = 0;
    if (!IS_IPAD) {
        [self.btnNews setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnFacebook setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.btnTweet setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.imgTab.image =[UIImage imageNamed:@"ic_tab_news_on.png"];

    }
    else
    {
        self.imgTab.image =[UIImage imageNamed:@"ic_tab_new.png"];

    }
    [self.tblNews reloadData];
   
}

-(void) callWSfacebook
{
   
    [timer invalidate];
    timer = nil;
    if (![CommonHelper connectedInternet]) {
        [CommonHelper showAlert:ERROR_NETWORK];
        [SVProgressHUD dismiss];
        return;
    }
    if (IS_IPAD) {
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fgrupointocable&width=768&height=806&show_faces=false&colorscheme=light&stream=true&border_color=0&header=false&appId=290904444377323"]]];
    }
    else
    {
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fgrupointocable&width=320&height=568&show_faces=false&colorscheme=light&stream=true&border_color=0&header=false&appId=290904444377323"]]];
    }
    
    
    /*NSURL *url=[NSURL URLWithString:@"https://www.facebook.com/feeds/page.php?id=10972486708&format=json"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    if (data.length>0) {
        NSError *error=nil;
        NSDictionary *response=[NSJSONSerialization JSONObjectWithData:data options:
                                NSJSONReadingMutableContainers error:&error];
       
        NSArray *arrs = [response objectForKey:@"entries"];
        NSLog(@"Arrs %@",arrs);
        for (NSDictionary *dic in arrs) {
            NewObj *fobject = [[NewObj alloc] init];
            fobject.title = [dic objectForKey:@"title"];
            fobject.body = [dic objectForKey:@"content"];
            
            NSString *content =[[[dic objectForKey:@"published"] substringWithRange: NSMakeRange( 0, 16)] stringByReplacingOccurrencesOfString:@"T"
                                                                           withString:@" "];

            fobject.dayPost = content;
            fobject.linkThumbnail  =@"http://graph.facebook.com/10972486708/picture?type=large";
            [_arrFacebooks addObject:fobject];
        }
        [SVProgressHUD dismiss];
        [self.tblNews reloadData];
    }
    else
    {
        [SVProgressHUD dismiss];
    }*/
}
- (IBAction)doFacebook:(id)sender {
    self.webview.hidden = NO;
    self.tblNews.hidden = YES;
    indexTab = 1;
    _arrFacebooks =[[NSMutableArray alloc] init];
    [self.tblNews reloadData];
    if (!IS_IPAD) {
        [self.btnNews setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.btnFacebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnTweet setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.imgTab.image =[UIImage imageNamed:@"ic_tab_facebook_on.png"];
    }
    else
    {
        self.imgTab.image =[UIImage imageNamed:@"ic_tab_facebook.png"];
    }
    [CommonHelper showBusyView];
      timer =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(callWSfacebook) userInfo:nil repeats:YES];
    
   
}
-(void)callWStwitter
{
    [timer invalidate];
    timer = nil;
    if (![CommonHelper connectedInternet]) {
        [CommonHelper showAlert:ERROR_NETWORK];
        [SVProgressHUD dismiss];
        return;
    }
    
    NSURL *url=[NSURL URLWithString:@"http://www.grupointocable.com/_ws/twitter_feed/send_twitter.php?twitter_str=920FBFOJHTGIEI2UE2E584"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    NSDictionary *response=[NSJSONSerialization JSONObjectWithData:data options:
                            NSJSONReadingMutableContainers error:&error];
    NSArray *arrs = [response objectForKey:@"statuses"];
     NSLog(@"Response %@",response);
    for (int i=0;i<arrs.count;i++) {
        NSDictionary *dic = [arrs objectAtIndex:i];
        NSDictionary *user = [dic objectForKey:@"user"];
        
        NewObj *fobject = [[NewObj alloc] init];
        fobject.title = [dic objectForKey:@"text"];;
        fobject.body = [dic objectForKey:@"text"];
        NSString *content =[[dic objectForKey:@"created_at"] substringWithRange: NSMakeRange( 0, 19)];
        fobject.dayPost = content;
        fobject.linkThumbnail = [user objectForKey:@"profile_background_image_url"];
        [_arrTwitters addObject:fobject];
    }
    [CommonHelper hideBusyView];
    [self.tblNews reloadData];
}


- (IBAction)doTweet:(id)sender {
    self.webview.hidden = YES;
    self.tblNews.hidden = NO;
    indexTab = 2;
    _arrTwitters =[[NSMutableArray alloc] init];
    [self.tblNews reloadData];
    if (!IS_IPAD) {
        [self.btnNews setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.btnFacebook setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.btnTweet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         self.imgTab.image =[UIImage imageNamed:@"ic_tab_tweets_on.png"];
    }
    else
    {
         self.imgTab.image =[UIImage imageNamed:@"ic_tab_tweets.png"];
    }
    [CommonHelper showBusyView];
    timer =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(callWStwitter) userInfo:nil repeats:YES];
    
}
- (void)getTweets
{
    [[SocialHelpers sharedManager] fetchTimelineForUser:TW_USERNAME completionHandler:^(BOOL success, NSInteger intValue, id objectValue) {
        if (success) {
            for (NSDictionary *feed in objectValue) {
                
                 NSLog(@"feed = %@",[feed objectForKey:@"text"]);
                NewObj *fobject = [[NewObj alloc] init];
                fobject.title = [feed objectForKey:@"text"];
                fobject.body = [feed objectForKey:@"text"];
                fobject.dayPost = [feed objectForKey:@"created_at"];
                NSDictionary *urls = [feed objectForKey:@"urls"];
                if (urls) {
                    fobject.linkThumbnail = [urls objectForKey:@"url"];
                }
              
                fobject.linkThumbnail = [[[SocialHelpers sharedManager] shareTwitterAccount] avatarUrl];
                
                [_arrTwitters addObject:fobject];
            }
            
        }
        [CommonHelper hideBusyView];
        [self.tblNews reloadData];
        
    }];
    
}
- (IBAction)doHome:(id)sender {
    [[CommonHelper appDelegate] goHome];
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
    if (![CommonHelper appDelegate].isNews) {
        _arrNews =[[NSMutableArray alloc] init];
        [self.tblNews reloadData];
        self.navigationController.navigationBarHidden = YES;
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
        [self.tblNews setFrame:CGRectMake(0, 50, 768, 806)];
    }
    else
    {
        if (IPHONE_5) {
            [self.tblNews setFrame:CGRectMake(0, 50, 320, 364)];
        }
        else
        {
            [self.tblNews setFrame:CGRectMake(0, 50, 320, 276)];
        }
        
    }
}

-(void) setFrameRotated
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [self.tblNews setFrame:CGRectMake(0, 50, 1024, 600)];
    }
    else
    {
        
        [self.tblNews setFrame:CGRectMake(0, 50, 568, 120)];
        
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
#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (indexTab==0) {
        return _arrSectionDays.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 105;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberNews;
    switch (indexTab) {
        case 0:
        {
            NSMutableArray *arr =[[NSMutableArray alloc] init];
            NSString *str = [_arrSectionDays objectAtIndex:section];
            for (int i = 0;i<_arrNews.count;i++) {
                NewObj *obj = [_arrNews objectAtIndex:i];
                if ([str isEqualToString:obj.dayPost]) {
                    [arr addObject:obj];
                }
            }
            return arr.count;

        }
        break;
        case 1:
            numberNews = _arrFacebooks.count;
        break;
        case 2:
            numberNews = _arrTwitters.count;
            break;
        default:
            break;
    }
    return numberNews;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewCell *currentCell=(NewCell *)[self.tblNews dequeueReusableCellWithIdentifier:@"NewCell"];
    if (currentCell == nil)
    {
        
        currentCell = [[[NSBundle mainBundle] loadNibNamed:@"NewCell" owner:self options:nil] objectAtIndex:0];
        
        
    }
    if (indexTab==0) {
        NSString *str =[_arrSectionDays objectAtIndex:indexPath.section];
        NSMutableArray *arr =[[NSMutableArray alloc] init];
        for (int i = 0;i<_arrNews.count;i++) {
            NewObj *obj = [_arrNews objectAtIndex:i];
            if ([str isEqualToString:obj.dayPost]) {
                [arr addObject:obj];
            }
        }

        NewObj *obj = [arr objectAtIndex:indexPath.row];
        if (obj.imgThumbnail) {
            currentCell.imgThumbnail.image = [CommonHelper imageByScalingAndCroppingForSize:CGSizeMake(80, 92) andImage:obj.imgThumbnail];
        }
        else
        {
            currentCell.imgThumbnail.image = nil;
        }
        currentCell.title.text = obj.title;
        currentCell.tvBody.hidden = YES;
        currentCell.title.hidden = NO;
        currentCell.lblDetail.text = obj.dayPost;
        currentCell.backgroundColor =[UIColor clearColor];
    }
    
    else if (indexTab==1)
    {
        NewObj *obj = [_arrFacebooks objectAtIndex:indexPath.row];
        if (obj.imgThumbnail) {
            currentCell.imgThumbnail.image = [CommonHelper imageByScalingAndCroppingForSize:CGSizeMake(80, 92) andImage:obj.imgThumbnail];
        }
        else
        {
            currentCell.imgThumbnail.image = nil;
            [self getImageForImageView:currentCell.imgThumbnail imageUrl:obj.linkThumbnail andNew:obj];
        }
        currentCell.title.hidden = YES;
         currentCell.tvBody.hidden = NO;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[obj.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        currentCell.tvBody.attributedText = attributedString;
        [currentCell.tvBody setFont:[UIFont systemFontOfSize:14]];
        currentCell.lblDetail.text = obj.dayPost;
         currentCell.backgroundColor =[UIColor clearColor];
    }
    else if(indexTab==2)
    {
        NewObj *obj = [_arrTwitters objectAtIndex:indexPath.row];
        if (obj.imgThumbnail) {
            currentCell.imgThumbnail.image = [CommonHelper imageByScalingAndCroppingForSize:CGSizeMake(80, 92) andImage:obj.imgThumbnail];;
        }
        else
        {
            currentCell.imgThumbnail.image = nil;
            [self getImageForImageView:currentCell.imgThumbnail imageUrl:obj.linkThumbnail andNew:obj];
        }
         currentCell.tvBody.hidden = YES;
        currentCell.title.hidden = NO;

        currentCell.title.text = obj.title;
        currentCell.lblDetail.text = obj.dayPost;
         currentCell.backgroundColor =[UIColor clearColor];
    }
    
    [currentCell initCell];
    
    return currentCell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (indexTab==0) {
        return [_arrSectionDays objectAtIndex:section];
    }
    return nil;
}
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
    switch (indexTab) {
        case 0:
        {
            NSString *str =[_arrSectionDays objectAtIndex:indexPath.section];
            NSMutableArray *arr =[[NSMutableArray alloc] init];
            for (int i = 0;i<_arrNews.count;i++) {
                NewObj *obj = [_arrNews objectAtIndex:i];
                if ([str isEqualToString:obj.dayPost]) {
                    [arr addObject:obj];
                }
            }
            DetailNewVC *detailVC =[[DetailNewVC alloc] init];
            detailVC.objNew = [arr objectAtIndex:indexPath.row];
            detailVC.indexTab = indexTab;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 1:
        {
            DetailNewVC *detailVC =[[DetailNewVC alloc] init];
            detailVC.indexTab = indexTab;
            detailVC.objNew = [_arrFacebooks objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 2:
        {
            DetailNewVC *detailVC =[[DetailNewVC alloc] init];
            detailVC.indexTab = indexTab;
            detailVC.objNew = [_arrTwitters objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}
- (void) getImageForImageView:(UIImageView *)imageView imageUrl:(NSString *)url andNew:(NewObj *) obj
{
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
                obj.imgThumbnail = image;
                [indicator stopAnimating];
                indicator.hidden = YES;
                [self.tblNews reloadData];
            }
            
            
        });
    });
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}
@end
