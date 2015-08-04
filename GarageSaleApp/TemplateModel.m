//
//  TemplateModel.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 17/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "TemplateModel.h"
#import "AppDelegate.h"

@implementation TemplateModel

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)saveInitialDataforTemplates;
{
    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
    
    // Create template #1
    Template *tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00001";
    tempTemplate.title = @"Aviso comprador";
    tempTemplate.text = @"Hola #COMPRADOR. La dueña de es #DUENO y su teléfono es #D-TELEFONO. Coordina con #D-ELELLA cuando puedes ir a verlo, yo ya le avisé que #D-LALO vas a llamar. En caso lo llegues a comprar necesito que por favor me mandes un mensajito avisándome. Gracias. Saludos, Giuliana   #DESCRIPCION    #FBLINK";

    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];

    // Create template #2
    tempTemplate = [[Template alloc] init];
    
    tempTemplate.template_id = @"00002";
    tempTemplate.title = @"Sistema de trabajo";
    tempTemplate.text = @"Hola #COMPRADOR. Te cuento cuál es nuestro sistema de trabajo..... Para poder publicar tus cosas necesito que me mandes las fotos de cada cosa junto con el precio de venta, una pequeña descripción que incluya el estado en que se encuentra, tus teléfonos y distrito. La publicación es gratis y en caso se venda algo a través nuestro cobramos una comisión de 10% del precio de venta final y debe de estar incluido en el precio que nos das. Para qué la publicación sea aprobada los precios tienen que ser atractivos. Cuando una persona se interesa en un producto tuyo le damos tu teléfono por el inbox previa revisión de su perfil, por lo general son personas conocidas o referidas. Para el pago de la comisión tenemos una cuenta BCP donde puedes depositarnos o transferirnos. Si tienes alguna duda escríbeme. Saludos, Giuliana";
    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #3
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00003";
    tempTemplate.title = @"Interés inicial";
    tempTemplate.text = @"Si está disponible. Para poder mandarte los datos al inbox necesito que por favor aceptes mi solicitud de amistad y me avises una vez que lo hagas :)";
    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #4
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00004";
    tempTemplate.title = @"Confirmación de visita";
    tempTemplate.text = @"Hola #COMPRADOR. Cómo estás? Quería que por favor me cuentes si llegaste a ir por el #PRODUCTO. Espero tus comentarios. Gracias. Saludos, Giuliana";
    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #5
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00005";
    tempTemplate.title = @"Envío de cuenta";
    tempTemplate.text = @"Te paso nuestra cuenta para que puedas hacer el abono de la comisión (10%). BCP ahorros soles # 194-22457272-0-11 a nombre de Maria Giuliana Ugarelli Reinafarje.  Acuérdate de avisarme a penas lo hagas para saber que es tuyo y sacarte de la lista de pendientes.  Puede ser transferencia por internet o depósito (de preferencia en Agente y no en agencia).  Un beso, Giuliana";
    tempTemplate.type = @"O";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #6
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00006";
    tempTemplate.title = @"Confirmación de venta";
    tempTemplate.text = @"Hola #DUENO. Cómo estás? Quería que por favor me cuentes si fueron a ver el #PRODUCTO y llegaste a venderlo para coordinar lo de la comisión. Espero tus comentarios. Gracias. Saludos, Giuliana";
    tempTemplate.type = @"O";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #7
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00007";
    tempTemplate.title = @"Venta de ropa";
    tempTemplate.text = @"Si es ropa, no cobramos comisión, pero cobramos por nuestros servicios el 5% del precio de venta y debe ser abonado en nuestra cuenta BCP antes de la publicación y es muy independiente de si se vende o no el producto";
    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];
    
    // Create template #8
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00008";
    tempTemplate.title = @"Sistema de aviso";
    tempTemplate.text = @"En este caso lo que hacemos es poner un aviso y en la descripción ponemos tu teléfono para que te contacten directamente. No cobramos comisión por venta, pero cobramos un monto de s/. 30 por nuestros servicios. Si te interesa avísame para pasarte nuestro número de cuenta BCP. Un beso, Giuliana";
    tempTemplate.type = @"B";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [self addNewTemplate:tempTemplate];

}

- (NSMutableArray*)getTemplatesFromCoreData;
{
    NSMutableArray *templatesArray = [[NSMutableArray alloc] init];
    
    // Fetch data from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Templates"];
    templatesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    // Set last product ID
    Template *templateToReview = [[Template alloc] init];
    int lastID = 0;
    
    for (int i=0; i<templatesArray.count; i=i+1)
    {
        templateToReview = [[Template alloc] init];
        templateToReview = (Template *)templatesArray[i];
        
        if ([templateToReview.template_id intValue] > lastID)
        {
            lastID = [templateToReview.template_id intValue];
        }
    }
    
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastTemplateID = lastID;
    
    return templatesArray;
}

- (NSMutableArray*)getTemplatesFromType:(NSString*)templateType;
{
    NSMutableArray *templateArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Template *templateToReview = [[Template alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayTemplates.count; i=i+1)
    {
        templateToReview = [[Template alloc] init];
        templateToReview = (Template *)mainDelegate.sharedArrayTemplates[i];
        
        if ([templateToReview.type isEqual:templateType])
        {
            [templateArray addObject:templateToReview];
        }
    }
    return templateArray;
}


- (NSString*)getNextTemplateID;
{
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastTemplateID = mainDelegate.lastTemplateID + 1;
    
    NSString *nextID = [NSString stringWithFormat:@"00000000%d", mainDelegate.lastTemplateID];
    nextID = [nextID substringFromIndex:[nextID length] - 5];
    
    return nextID;
}


- (BOOL)addNewTemplate:(Template*)newTemplate;
{
    BOOL updateSuccessful = YES;
    
    // Save object in persistent data store
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *coreDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Templates" inManagedObjectContext:context];
    
    [coreDataObject setValue:newTemplate.template_id forKey:@"template_id"];
    [coreDataObject setValue:newTemplate.title forKey:@"title"];
    [coreDataObject setValue:newTemplate.text forKey:@"text"];
    [coreDataObject setValue:newTemplate.type forKey:@"type"];
    [coreDataObject setValue:newTemplate.updated_time forKey:@"updated_time"];
    [coreDataObject setValue:newTemplate.agent_id forKey:@"agent_id"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        updateSuccessful = NO;
    }
    else // update successful!
    {
        // To have access to shared arrays from AppDelegate
        AppDelegate *mainDelegate;
        mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        [mainDelegate.sharedArrayTemplates addObject:newTemplate];
    }

    return updateSuccessful;
}


- (BOOL)updateTemplate:(Template*)templateToUpdate;
{
    BOOL updateSuccessful = YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Templates" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"template_id", templateToUpdate.template_id];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request");
        NSLog(@"%@, %@", error, error.localizedDescription);
        updateSuccessful = NO;
    }
    else
    {
        if (result.count == 0)
        {
            NSLog(@"No records retrieved");
            updateSuccessful = NO;
        }
        else
        {
            // Set updated values
            NSManagedObject *coreDataObject = (NSManagedObject *)[result objectAtIndex:0];
            
            [coreDataObject setValue:templateToUpdate.template_id forKey:@"template_id"];
            [coreDataObject setValue:templateToUpdate.title forKey:@"title"];
            [coreDataObject setValue:templateToUpdate.text forKey:@"text"];
            [coreDataObject setValue:templateToUpdate.type forKey:@"type"];
            [coreDataObject setValue:templateToUpdate.updated_time forKey:@"updated_time"];
            [coreDataObject setValue:templateToUpdate.agent_id forKey:@"agent_id"];
            
            // Save object to persistent store
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unable to save managed object context.");
                NSLog(@"%@, %@", error, error.localizedDescription);
                updateSuccessful = NO;
            }
            else // update successful!
            {
                // To have access to shared arrays from AppDelegate
                AppDelegate *mainDelegate;
                mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
 
                // Replace object in Shared Array
                Template *templateToReview = [[Template alloc] init];
                
                for (int i=0; i<mainDelegate.sharedArrayTemplates.count; i=i+1)
                {
                    templateToReview = [[Template alloc] init];
                    templateToReview = (Template *)mainDelegate.sharedArrayTemplates[i];
                    
                    if ([templateToReview.template_id isEqual:templateToUpdate.template_id])
                    {
                        [mainDelegate.sharedArrayTemplates replaceObjectAtIndex:i withObject:templateToUpdate];
                        break;
                    }
                }

            }
        }
    }

    return updateSuccessful;
}


- (NSString*)changeKeysForText:(NSString*)textToReview usingBuyer:(Client*)clientBuyer andOwner:(Client*)clientOwner andProduct:(Product*)relatedProduct;
{
    NSMutableString *reviewedText = [NSMutableString stringWithString:textToReview];
    NSRange keyRange;

    if ([clientBuyer.client_id length] > 0)
    {
        keyRange = [reviewedText rangeOfString:@"#COMPRADOR"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientBuyer.name];
        }
        
        keyRange = [reviewedText rangeOfString:@"#C-TELEFONO"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientBuyer.phone1];
        }
        
        keyRange = [reviewedText rangeOfString:@"#C-LALO"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"lo"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"la"];
            }
        }
        
        keyRange = [reviewedText rangeOfString:@"#C-ELELLA"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"el"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"ella"];
            }
        }
    }
    
    if ([clientOwner.client_id length] > 0)
    {
        keyRange = [reviewedText rangeOfString:@"#DUENO"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientOwner.name];
        }
        
        keyRange = [reviewedText rangeOfString:@"#D-TELEFONO"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientOwner.phone1];
        }
        
        keyRange = [reviewedText rangeOfString:@"#D-ZONA"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientOwner.client_zone];
        }
        
        keyRange = [reviewedText rangeOfString:@"#D-LALO"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"lo"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"la"];
            }
        }
 
        keyRange = [reviewedText rangeOfString:@"#D-ELELLA"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"el"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"ella"];
            }
        }
       
    }
    
    if ([relatedProduct.product_id length] > 0)
    {
        keyRange = [reviewedText rangeOfString:@"#PRODUCTO"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:relatedProduct.name];
        }
        
        keyRange = [reviewedText rangeOfString:@"#PRECIO"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:[NSString stringWithFormat:@"%@", relatedProduct.price]];
        }

        keyRange = [reviewedText rangeOfString:@"#DESCRIPCION"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:[NSString stringWithFormat:@"%@", relatedProduct.desc]];
        }

        keyRange = [reviewedText rangeOfString:@"#FBLINK"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:[NSString stringWithFormat:@"%@", relatedProduct.fb_link]];
        }

    }    
    
    
    
    return [NSString stringWithString:reviewedText];
}


#pragma mark -  Methods for shorte URL taken from http://www.warewoof.com/goo-gl-url-shortener-in-ios/

-(void)shortenMapUrl:(NSString*)originalURL
{
    
    NSString* googString = @"https://www.googleapis.com/urlshortener/v1/url";
    NSURL* googUrl = [NSURL URLWithString:googString];
    
    NSMutableURLRequest* googReq = [NSMutableURLRequest requestWithURL:googUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    [googReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString* longUrlString = [NSString stringWithFormat:@"{\"longUrl\": \"%@\"}",originalURL];
    
    NSData* longUrlData = [longUrlString dataUsingEncoding:NSUTF8StringEncoding];
    [googReq setHTTPBody:longUrlData];
    [googReq setHTTPMethod:@"POST"];
    
    NSURLConnection* connect = [[NSURLConnection alloc] initWithRequest:googReq delegate:self];
    connect = nil;
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *returnData = [NSString stringWithUTF8String:[data bytes]];
    NSError* error = nil;
    
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSString* shortenedURL;
    if (error == nil) {
        if ([jsonArray valueForKey:@"id"] != nil) {
            shortenedURL = [jsonArray valueForKey:@"id"];
        }
    } else {
        NSLog(@"Error %@", error);
    }
    
    NSLog(@"Returned URL: %@", shortenedURL);
}

@end
