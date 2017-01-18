//
//  Request.m
//  WebViewApi
//
//  Created by jiang on 16/12/14.
//  Copyright © 2016年 com.meiniucn. All rights reserved.
//

#import "Request.h"
#import "Dialog.h"
#import "AFNetworking.h"
#import "TZImagePickerController.h"


@interface Request()<TZImagePickerControllerDelegate>
{
    FnDictionary* _fnDic;
    // 唯一ID
    NSString *_index;
    // 拍照--成功回调方法名的序号
    NSString *_idxCameraSuc;
    // 拍照--进度回调方法名的序号
    NSString *_idxCameraPro;
    // 拍照--失败回调方法名的序号
    NSString *_idxCameraFal;
    // 拍照--URL
    NSString *_cameraURL;
    // 拍照--URL
    NSString *_cameraLevel;
    // 拍照--URL
    NSString *_cameraInputName;
    // 拍照--参数
    NSDictionary *_cameraParam;
 
}
@end

@implementation Request

- (id)initSetSuperController:(UIViewController*)superC withWebView:(UIWebView *)webView
{
    self = [super init];
    if (self) {
        _index = @"0";
        _fnDic = [FnDictionary new];
        self.superController = superC;
        self.webView = webView;
    }
    return self;
}


- (NSString*)getIndex{
    NSInteger INDEX = [_index integerValue];
    INDEX++;
    _index = [NSString stringWithFormat:@"%ld", (long)INDEX];
    return [NSString stringWithFormat:@"MN_FILE_%@", _index];
}

// json to dic
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
    
}





- (void)upload:(NSString*) data {
    
    NSDictionary *dic = [self dictionaryWithJsonString:data];
    
    NSString *indexSuccess = [_fnDic add:@"upload_success" value:dic[@"onUploaded"]];
    NSString *indexProcess = [_fnDic add:@"upload_process" value:dic[@"onUploading"]];
    NSString *indexFail = [_fnDic add:@"upload_fail" value:dic[@"onUploadError"]];
    NSString *url = dic[@"url"];
    NSString *maxNumber = [NSString stringWithFormat:@"%@",dic[@"maxNum"]];
    NSString *quality = [NSString stringWithFormat:@"%@",dic[@"quality"]];
    NSString *inputName = [NSString stringWithFormat:@"%@",dic[@"inputName"]];
    NSDictionary *param = dic[@"data"];
 
    
    
    NSMutableArray *tary = [NSMutableArray new];
    
    //添加拍照按钮，判断是否支持摄像头
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertAction * cameraAction=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            _idxCameraFal = indexFail;
            _idxCameraPro = indexProcess;
            _idxCameraSuc = indexSuccess;
            _cameraURL = url;
            _cameraParam = param;
            _cameraLevel = quality;
            _cameraInputName = inputName;
            
            [self uploadWithCamera];
            
        }];
        [tary addObject:cameraAction];
    }
    
    //从相册获取
    UIAlertAction * photoAction=[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self upLoadImageWith:url withparam:param withmaxNum:maxNumber withindexSuccess:indexSuccess withindexProcess:indexProcess withindexFail:indexFail withquality:quality withinputName:inputName];
        
    }];
    [tary addObject:photoAction];
    
    
    //取消 按钮
    UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [tary addObject:cancelAction];
    
    Dialog *dialog = [[Dialog alloc]initSetSuperController:self.superController withWebView:self.webView];
    [dialog actionSheet:@"选择照片来源" with:tary];
    
}


- (void)upLoadImageWith:(NSString *)url withparam:(NSDictionary*) param withmaxNum:(NSString*) maxNum withindexSuccess:(NSString*) indexSuccess withindexProcess:(NSString*) indexProcess withindexFail:(NSString*) indexFail withquality:(NSString*) quality withinputName:(NSString*) inputName{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:[maxNum integerValue] delegate:self];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [self uploader:url withparam:param withimgaes:photos withimageIndex:0 withindexSuccess:indexSuccess withindexProcess:indexProcess withindexFail:indexFail withfileId:[self getIndex] withquality:quality withinputName:inputName];
        
    }];
    
    [self.superController presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)uploadWithCamera {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self showImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }else{
        return;
    }
}


- (void)uploader:(NSString*) url withparam:(NSDictionary*) param withimgaes:(NSArray<UIImage *>*) images withimageIndex:(int) imageIndex withindexSuccess:(NSString*) indexSuccess withindexProcess:(NSString*) indexProcess withindexFail:(NSString*) indexFail withfileId:(NSString*) fileId withquality:(NSString*) quality withinputName:(NSString*) inputName {
    
    if (images.count <= imageIndex) {
        [_fnDic removeFn:@"upload_success" andIndex:indexSuccess];
        [_fnDic removeFn:@"upload_process" andIndex:indexProcess];
        [_fnDic removeFn:@"upload_fail" andIndex:indexFail];
        return;
    }
    

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];

    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        float level = [quality floatValue] / 100;
        if (level > 1 || level <= 0) {
            level = 1;
        }
        
        NSData *imageData = UIImageJPEGRepresentation(images[imageIndex], level);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        //        NSLog(@"%@",str);
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:inputName fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@','%@')", [_fnDic getFn:@"upload_process" andindex:indexProcess], fileId, [NSString stringWithFormat:@"%f", uploadProgress.fractionCompleted]]];
                
            });  
            
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                
                NSMutableString *str = [[NSMutableString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@','%@')", [_fnDic getFn:@"upload_success" andindex:indexSuccess], fileId, str]];
                
                [self uploader:url withparam:param withimgaes:images withimageIndex:imageIndex+1 withindexSuccess:indexSuccess withindexProcess:indexProcess withindexFail:indexFail withfileId:[self getIndex] withquality:quality withinputName:inputName];
                
            });
            
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        NSLog(@"%@", task);
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@','%@')", [_fnDic getFn:@"upload_fail" andindex:indexFail], fileId, @"error"]];
                
                [self uploader:url withparam:param withimgaes:images withimageIndex:imageIndex+1 withindexSuccess:indexSuccess withindexProcess:indexProcess withindexFail:indexFail withfileId:[self getIndex] withquality:quality withinputName:inputName];
                
            });
            
        });
        
        
    }];
    
}


-(void)showImagePickerController:(UIImagePickerControllerSourceType)sourceType {
    //创建
    UIImagePickerController * pickerController=[[UIImagePickerController alloc]init];
    //设置代理
    pickerController.delegate=self;
    //设置是否允许编辑
    pickerController.allowsEditing=YES;
    //设置图片来源
    pickerController.sourceType=sourceType;
    
    //推出
    [self.superController presentViewController:pickerController animated:YES completion:nil];
}


#pragma mark - UIImagePickerController代理方法 -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    NSString *index = [self getIndex];
    
    NSArray<UIImage *> *images = @[image];
      
    [self uploader:_cameraURL withparam:_cameraParam withimgaes:images withimageIndex:0 withindexSuccess:_idxCameraSuc withindexProcess:_idxCameraPro withindexFail:_idxCameraFal withfileId:index withquality:_cameraLevel withinputName:_cameraInputName];
     //消失
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end




















