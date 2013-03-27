YUI.add("yuidoc-meta", function(Y) {
   Y.YUIDoc = { meta: {
    "classes": [
        "bindLoader",
        "closeGenericVideoComponentCutter",
        "enlightTextarea",
        "getDragPosition",
        "getRelativePositionInImageEditor",
        "hideLoader",
        "initializeVideoEditor",
        "offlightTextarea",
        "resetImageEditorCrop",
        "resetImageEditorOperationsChoice",
        "resetImageEditorTexts",
        "showLoader",
        "textAreaImageEditorContent",
        "unbindLoader"
    ],
    "modules": [
        "AjaxLoader",
        "ImageEditor",
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
            "displayName": "VideoEditor",
            "name": "VideoEditor",
            "description": "Provides the base Widget class..."
        }
    ]
} };
});