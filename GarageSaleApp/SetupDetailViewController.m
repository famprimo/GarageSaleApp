//
//  SetupDetailViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 16/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "SetupDetailViewController.h"
#import "Template.h"
#import "TemplateModel.h"

@interface SetupDetailViewController ()
{
    // Data for the tables
    NSMutableArray *_myDataTemplates;
    
    // /For the selections in the tables
    Template *_selectedTemplate;
    NSString *_selectedType;
}
@end

@implementation SetupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableTemplates.delegate = self;
    self.tableTemplates.dataSource = self;

    _selectedType = @"C";
    _myDataTemplates = [[[TemplateModel alloc] init] getTemplatesFromType:_selectedType];
    _selectedTemplate = [[Template alloc] init];
    
    CGRect imageTemplateIconFrame = self.imageTemplateIcon.frame;
    imageTemplateIconFrame.origin.x = 23;
    imageTemplateIconFrame.origin.y = 86;
    imageTemplateIconFrame.size.width = 50;
    imageTemplateIconFrame.size.height = 50;
    self.imageTemplateIcon.frame = imageTemplateIconFrame;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing button actions

-(IBAction)saveTemplate:(id)sender;
{
    TemplateModel *templateMethods = [[TemplateModel alloc] init];

    _selectedTemplate.title = self.labelTemplateTitle.text;
    _selectedTemplate.text = self.labelTemplateText.text;
    _selectedTemplate.updated_time = [NSDate date];
    
    [templateMethods updateTemplate:_selectedTemplate];

    // Load data again
    _myDataTemplates = [[NSMutableArray alloc] init];
    _myDataTemplates = [[[TemplateModel alloc] init] getTemplatesFromType:_selectedType];

    // [templateMethods updateTemplate:_selectedTemplate withArray:_myDataTemplates];
    
    [self.tableTemplates reloadData];

}

-(IBAction)newTemplate:(id)sender;
{
    TemplateModel *templateMethods = [[TemplateModel alloc] init];
    
    _selectedTemplate = [[Template alloc] init];
    _selectedTemplate.template_id = [templateMethods getNextTemplateID];
    _selectedTemplate.title = @"Nuevo template";
    _selectedTemplate.text = @"";
    _selectedTemplate.type = _selectedType;
    _selectedTemplate.updated_time = [NSDate date];
    _selectedTemplate.agent_id = @"00001";

    [templateMethods addNewTemplate:_selectedTemplate];
    [_myDataTemplates insertObject:_selectedTemplate atIndex:0];
    [self.tableTemplates reloadData];

}

-(IBAction)segmentedControlChange:(id)sender;
{
    if (self.segmentedControlType.selectedSegmentIndex == 0)
    {
        _selectedType = @"C";
    }
    else if (self.segmentedControlType.selectedSegmentIndex == 1)
    {
        _selectedType = @"O";
    }
    
    _myDataTemplates = [[NSMutableArray alloc] init];
    _myDataTemplates = [[[TemplateModel alloc] init] getTemplatesFromType:_selectedType];
    [self.tableTemplates reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _myDataTemplates.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    
    UILabel *labelTitle = (UILabel*)[cell.contentView viewWithTag:1];
    // UILabel *labelType = (UILabel*)[cell.contentView viewWithTag:2];

    // Configure the cell...
    Template *myTemplate = _myDataTemplates[indexPath.row];
    
    labelTitle.text = myTemplate.title;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected listing to var
    _selectedTemplate = _myDataTemplates[indexPath.row];
    
    self.labelTemplateTitle.text = _selectedTemplate.title;
    self.labelTemplateText.text = _selectedTemplate.text;
    self.labelTemplateText.editable = YES;
    
}


@end
