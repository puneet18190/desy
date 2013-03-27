YUI.add("yuidoc-meta", function(Y) {
   Y.YUIDoc = { meta: {
    "classes": [
        "bindLoader",
        "closeGenericVideoComponentCutter",
        "enlightTextarea",
        "getDragPosition",
        "getRelativePositionInImageEditor",
        "hideEverythingOutCurrentSlide",
        "hideLoader",
        "hideNewSlideChoice",
        "initLessonEditorPositions",
        "initTinymce",
        "initializeSortableNavs",
        "initializeVideoEditor",
        "isHorizontalMask",
        "loadSlideAndAdhiacentInLessonEditor",
        "loadSlideInLessonEditor",
        "makeDraggable",
        "offlightTextarea",
        "reInitializeSlidePositionsInLessonEditor",
        "removeGalleryInLessonEditor",
        "resetImageEditorCrop",
        "resetImageEditorOperationsChoice",
        "resetImageEditorTexts",
        "resizeHeight",
        "resizeWidth",
        "saveCurrentSlide",
        "scrollPaneUpdate",
        "showEverythingOutCurrentSlide",
        "showGalleryInLessonEditor",
        "showLoader",
        "showNewSlideChoice",
        "slideError",
        "slideTo",
        "stopMediaInCurrentSlide",
        "submitCurrentSlideForm",
        "textAreaImageEditorContent",
        "tinyMceCallbacks",
        "tinyMceKeyDownCallbacks",
        "unbindLoader"
    ],
    "modules": [
        "AjaxLoader",
        "ImageEditor",
        "LessonEditor",
        "VideoEditor"
    ],
    "allModules": [
        {
            "displayName": "AjaxLoader",
            "name": "AjaxLoader",
            "description": "Shows a loading image while page is loading, \nit handles ajax calls too."
        },
        {
            "displayName": "ImageEditor",
            "name": "ImageEditor",
            "description": "Image editor functions, \ncrop and textarea management."
        },
        {
            "displayName": "LessonEditor",
            "name": "LessonEditor",
            "description": "Lesson editor functions, \nit handles visual effects, CRUD actions on single slides and lessons, it handles tinyMCE editor too."
        },
        {
            "displayName": "VideoEditor",
            "name": "VideoEditor",
            "description": "Provides the base Widget class..."
        }
    ]
} };
});