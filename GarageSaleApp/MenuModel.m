//
//  MenuModel.m
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "MenuModel.h"
#import "MenuItem.h"
#import "AppDelegate.h"

@implementation MenuModel

- (NSMutableArray *)getMenuItem
{
    NSMutableArray *menuItemArray = [[NSMutableArray alloc] init];

    MenuItem *item0 = [[MenuItem alloc] init];
    item0.menuTitle = @"Mensajes";
    item0.menuIcon = @"ProductMenuIcon";
    item0.screenType = ScreenTypeMessages;
    [menuItemArray addObject:item0];

    MenuItem *item02 = [[MenuItem alloc] init];
    item02.menuTitle = @"Mensajes (NEW)";
    item02.menuIcon = @"ProductMenuIcon";
    item02.screenType = 30;
    [menuItemArray addObject:item02];

    MenuItem *item1 = [[MenuItem alloc] init];
    item1.menuTitle = @"Productos";
    item1.menuIcon = @"ProductMenuIcon";
    item1.screenType = ScreenTypeProduct;
    [menuItemArray addObject:item1];
    
    MenuItem *item2 = [[MenuItem alloc] init];
    item2.menuTitle = @"Clientes";
    item2.menuIcon = @"ClientMenuIcon";
    item2.screenType = ScreenTypeClient;
    [menuItemArray addObject:item2];
    
    MenuItem *item3 = [[MenuItem alloc] init];
    item3.menuTitle = @"Oportunidades";
    item3.menuIcon = @"OpportunityMenuIcon";
    item3.screenType = ScreenTypeOpportunity;
    [menuItemArray addObject:item3];
    
    MenuItem *item4 = [[MenuItem alloc] init];
    item4.menuTitle = @"Estadisticas";
    item4.menuIcon = @"AboutMenuIcon";
    item4.screenType = ScreenTypeStatistics;
    [menuItemArray addObject:item4];
    
    MenuItem *item5 = [[MenuItem alloc] init];
    item5.menuTitle = @"Configuracion";
    item5.menuIcon = @"AboutMenuIcon";
    item5.screenType = ScreenTypeSetup;
    [menuItemArray addObject:item5];
    

    return menuItemArray;
    
}

@end
