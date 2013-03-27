YUI.add("yuidoc-meta", function(Y) {
   Y.YUIDoc = { meta: {
    "classes": [
        "addDeleteItemToCurrentUrl",
        "addEmailToVirtualClassroomSendLessonLinkSelector",
        "addLesson",
        "addLessonToVirtualClassroom",
        "addMediaElement",
        "bindLoader",
        "changePageDashboardLessons",
        "changePageDashboardMediaElements",
        "closeGenericVideoComponentCutter",
        "copyLesson",
        "destroyLesson",
        "destroyMediaElement",
        "dislikeLesson",
        "enlightTextarea",
        "getDragPosition",
        "getHtmlPagination",
        "getRelativePositionInImageEditor",
        "hideEverythingOutCurrentSlide",
        "hideLoader",
        "hideNewSlideChoice",
        "initLessonEditorPositions",
        "initTinymce",
        "initializeNotAvailableLessonsToLoadQuick",
        "initializeSortableNavs",
        "initializeVideoEditor",
        "isHorizontalMask",
        "likeLesson",
        "loadSlideAndAdhiacentInLessonEditor",
        "loadSlideInLessonEditor",
        "makeDraggable",
        "offlightTextarea",
        "previewLesson",
        "publishLesson",
        "reInitializeSlidePositionsInLessonEditor",
        "reloadDashboardPages",
        "reloadLessonsDashboardPagination",
        "reloadMediaElementsDashboardPagination",
        "removeGalleryInLessonEditor",
        "removeLesson",
        "removeLessonFromVirtualClassroom",
        "removeMediaElement",
        "resetImageEditorCrop",
        "resetImageEditorOperationsChoice",
        "resetImageEditorTexts",
        "resizeHeight",
        "resizeWidth",
        "saveCurrentSlide",
        "scrollPaneUpdate",
        "secondsToDateString",
        "showEverythingOutCurrentSlide",
        "showGalleryInLessonEditor",
        "showLoader",
        "showNewSlideChoice",
        "slideError",
        "slideTo",
        "stopMediaInCurrentSlide",
        "submitCurrentSlideForm",
        "switchToSuggestedLessons",
        "switchToSuggestedMediaElements",
        "textAreaImageEditorContent",
        "tinyMceCallbacks",
        "tinyMceKeyDownCallbacks",
        "unbindLoader",
        "unpublishLesson"
    ],
    "modules": [
        "AjaxLoader",
        "Buttons",
        "Dashboard",
        "ImageEditor",
        "LessonEditor",
        "Times",
        "VideoEditor",
        "VirtualClassroom"
    ],
    "allModules": [
        {
            "displayName": "AjaxLoader",
            "name": "AjaxLoader",
            "description": "Shows a loading image while page is loading, \nit handles ajax calls too."
        },
        {
            "displayName": "Buttons",
            "name": "Buttons",
            "description": "Lessons and Elements actions triggered via buttons."
        },
        {
            "displayName": "Dashboard",
            "name": "Dashboard",
            "description": "Dashboard is the welcome page of DESY where you find shared lessons and elements. \nThis handles elements interaction events."
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
            "displayName": "Times",
            "name": "Times",
            "description": "Shows a loading image while page is loading, \nit handles ajax calls too."
        },
        {
            "displayName": "VideoEditor",
            "name": "VideoEditor",
            "description": "Provides the base Widget class..."
        },
        {
            "displayName": "VirtualClassroom",
            "name": "VirtualClassroom",
            "description": "It's where users can share their lessons.\nIt handles share lessons link and add to playlist actions."
        }
    ]
} };
});