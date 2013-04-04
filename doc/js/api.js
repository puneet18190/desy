YUI.add("yuidoc-meta", function(Y) {
   Y.YUIDoc = { meta: {
    "classes": [
        "AdminAutocomplete",
        "AdminCollapsed",
        "AdminDocumentReady",
        "AjaxLoaderBinder",
        "AjaxLoaderDocumentReady",
        "AjaxLoaderVisibility",
        "AudioEditorComponents",
        "AudioEditorCutters",
        "AudioEditorDocumentReady",
        "AudioEditorGalleries",
        "AudioEditorGeneral",
        "AudioEditorGraphics",
        "AudioEditorPreview",
        "AudioEditorScrollpain",
        "BrowsersDocumentReady",
        "ButtonsAccessories",
        "ButtonsDocumentReady",
        "ButtonsLesson",
        "ButtonsMediaElement",
        "DashboardDocumentReady",
        "DashboardGeneral",
        "DashboardPagination",
        "DialogsAccessories",
        "DialogsConfirmation",
        "DialogsGalleries",
        "DialogsTimed",
        "DialogsWithForm",
        "LocationsDocumentReady",
        "addEmailToVirtualClassroomSendLessonLinkSelector",
        "addTagWithoutSuggestion",
        "addToTagsValue",
        "centerThis",
        "centerThisInContainer",
        "checkNoTagDuplicates",
        "closeGenericVideoComponentCutter",
        "closePlaylistMenuInLessonViewer",
        "createTagSpan",
        "disableTagsInputTooHigh",
        "enlightTextarea",
        "getDragPosition",
        "getLessonViewerCurrentSlide",
        "getMaximumZIndex",
        "getRelativePositionInImageEditor",
        "getUnivoqueClassForTag",
        "goToNextSlideInLessonViewer",
        "goToPrevSlideInLessonViewer",
        "hideArrowsInLessonViewer",
        "hideEverythingOutCurrentSlide",
        "hideExpandedNotification",
        "hideHelpButton",
        "hideHelpTooltip",
        "hideNewSlideChoice",
        "hideNotificationsButton",
        "hideNotificationsFumetto",
        "initLessonEditorPositions",
        "initMediaElementLoader",
        "initSearchTagsAutocomplete",
        "initTinymce",
        "initializeActionOfMediaTimeUpdater",
        "initializeActionOfMediaTimeUpdaterInAudioEditor",
        "initializeActionOfMediaTimeUpdaterInVideoEditor",
        "initializeAudioEditorCutter",
        "initializeAudioGalleryInAudioEditor",
        "initializeAudioGalleryInLessonEditor",
        "initializeDraggableVirtualClassroomLesson",
        "initializeHelp",
        "initializeImageGalleryInImageEditor",
        "initializeImageGalleryInLessonEditor",
        "initializeLessonViewer",
        "initializeMedia",
        "initializeMediaTimeUpdater",
        "initializeMediaTimeUpdaterInAudioEditor",
        "initializeMediaTimeUpdaterInVideoEditor",
        "initializeNotAvailableLessonsToLoadQuick",
        "initializeNotifications",
        "initializePlaylist",
        "initializeScrollPaneQuickLessonSelector",
        "initializeSortableNavs",
        "initializeVideoEditor",
        "initializeVideoGalleryInLessonEditor",
        "initializeVideoInVideoEditorPreview",
        "initializeVirtualClassroom",
        "isHorizontalMask",
        "loadSlideAndAdhiacentInLessonEditor",
        "loadSlideInLessonEditor",
        "makeDraggable",
        "offlightTextarea",
        "openPlaylistMenuInLessonViewer",
        "reInitializeSlidePositionsInLessonEditor",
        "removeFromTagsValue",
        "removeGalleryInLessonEditor",
        "removeURLParameter",
        "resetImageEditorCrop",
        "resetImageEditorOperationsChoice",
        "resetImageEditorTexts",
        "resetMediaElementChangeInfo",
        "resizeHeight",
        "resizeWidth",
        "resizedWidthForImageGallery",
        "saveCurrentSlide",
        "scrollPaneUpdate",
        "selectAudioComponentCutterHandle",
        "selectComponentInLessonViewerPlaylistMenu",
        "selectVideoComponentCutterHandle",
        "setCurrentTimeToMedia",
        "showEverythingOutCurrentSlide",
        "showGalleryInLessonEditor",
        "showHelpButton",
        "showHelpTooltip",
        "showLoadingMediaErrorPopup",
        "showNewSlideChoice",
        "showNotificationsButton",
        "showNotificationsFumetto",
        "showNotificationsTooltip",
        "slideError",
        "slideTo",
        "slideToInLessonViewer",
        "slideToInLessonViewerWithLessonSwitch",
        "stopAllMedia",
        "stopMedia",
        "stopMediaInCurrentSlide",
        "stopMediaInLessonViewer",
        "stopVideoInVideoEditorPreview",
        "submitCurrentSlideForm",
        "switchLessonInPlaylistMenuLessonViewer",
        "textAreaImageEditorContent",
        "tinyMceCallbacks",
        "tinyMceKeyDownCallbacks",
        "updateURLParameter",
        "uploadDone",
        "uploadMediaElementLoadeDoneRedirect",
        "uploadMediaElementLoaderError",
        "validSeek"
    ],
    "modules": [
        "administration",
        "ajax-loader",
        "audio-editor",
        "browsers",
        "buttons",
        "dashboard",
        "dialogs",
        "galleries",
        "general",
        "image-editor",
        "lesson-editor",
        "lesson-viewer",
        "locations",
        "media-element-editor",
        "media-element-loader",
        "notifications",
        "players",
        "profile",
        "search",
        "tags",
        "video-editor",
        "virtual-classroom"
    ],
    "allModules": [
        {
            "displayName": "administration",
            "name": "administration",
            "description": "Functions used in the Administration section: only for this section, it's generated a separate file which doesn't merge with the regular one. The only external module loaded is {{#crossLinkModule \"ajax-loader\"}}{{/crossLinkModule}}."
        },
        {
            "displayName": "ajax-loader",
            "name": "ajax-loader",
            "description": "Shows a loading image while page is loading, it handles ajax calls too."
        },
        {
            "displayName": "audio-editor",
            "name": "audio-editor",
            "description": "bla bla bla"
        },
        {
            "displayName": "browsers",
            "name": "browsers",
            "description": "bla bla bla"
        },
        {
            "displayName": "buttons",
            "name": "buttons",
            "description": "Lessons and Elements actions triggered via buttons."
        },
        {
            "displayName": "dashboard",
            "name": "dashboard",
            "description": "Dashboard is the welcome page of DESY where you find shared lessons and elements. This handles elements interaction events."
        },
        {
            "displayName": "dialogs",
            "name": "dialogs",
            "description": "Dialogs, model and popup interaction. Open, close content management. Uses jQueryUI _dialog_"
        },
        {
            "displayName": "galleries",
            "name": "galleries",
            "description": "Media element galleries, initialization."
        },
        {
            "displayName": "general",
            "name": "general",
            "description": "Generic shared javascript functions"
        },
        {
            "displayName": "image-editor",
            "name": "image-editor",
            "description": "Image editor functions, crop and textarea management."
        },
        {
            "displayName": "lesson-editor",
            "name": "lesson-editor",
            "description": "Lesson editor functions, it handles visual effects, CRUD actions on single slides and lessons, it handles tinyMCE editor too."
        },
        {
            "displayName": "lesson-viewer",
            "name": "lesson-viewer",
            "description": "Lesson viewer, it handles slides switching and playlist menu effects."
        },
        {
            "displayName": "locations",
            "name": "locations",
            "description": "bla bla bla"
        },
        {
            "displayName": "media-element-editor",
            "name": "media-element-editor",
            "description": "bla bla bla"
        },
        {
            "displayName": "media-element-loader",
            "name": "media-element-loader",
            "description": "New media element popup handler, form validation errors handling."
        },
        {
            "displayName": "notifications",
            "name": "notifications",
            "description": "Notification info and help assistant messages handler."
        },
        {
            "displayName": "players",
            "name": "players",
            "description": "Media elements players: initializer, play, stop, update frame."
        },
        {
            "displayName": "profile",
            "name": "profile",
            "description": "bla bla bla"
        },
        {
            "displayName": "search",
            "name": "search",
            "description": "bla bla bla"
        },
        {
            "displayName": "tags",
            "name": "tags",
            "description": "Tags autocomplete, _add_ and _remove_ from list."
        },
        {
            "displayName": "video-editor",
            "name": "video-editor",
            "description": "Provides video editor ajax actions."
        },
        {
            "displayName": "virtual-classroom",
            "name": "virtual-classroom",
            "description": "It's where users can share their lessons. It handles share lessons link and add to playlist actions."
        }
    ]
} };
});