//
//  M13ProgressViewImage.h
//  M13ProgressView
//


#import "M13ProgressView.h"

typedef enum {
    M13ProgressViewImageProgressDirectionLeftToRight,
    M13ProgressViewImageProgressDirectionBottomToTop,
    M13ProgressViewImageProgressDirectionRightToLeft,
    M13ProgressViewImageProgressDirectionTopToBottom
} M13ProgressViewImageProgressDirection;

/**A progress bar where progress is shown by cutting an image.
 @note This progress bar does not have in indeterminate mode and does not respond to actions.*/
@interface M13ProgressViewImage : M13ProgressView

/**@name Appearance*/
/**The image to use when showing progress.*/
@property (nonatomic, retain) UIImage *progressImage;
/**The direction of progress. (What direction the fill proceeds in.)*/
@property (nonatomic, assign) M13ProgressViewImageProgressDirection progressDirection;
/**Wether or not to draw the greyscale background.*/
@property (nonatomic, assign) BOOL drawGreyscaleBackground;

@end
