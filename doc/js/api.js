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
        "GalleriesAccessories",
        "GalleriesDocumentReady",
        "GalleriesInitializers",
        "GeneralCentering",
        "GeneralDocumentReady",
        "GeneralMiscellanea",
        "GeneralUrls",
        "ImageEditorDocumentReady",
        "ImageEditorGraphics",
        "ImageEditorImageScale",
        "ImageEditorTexts",
        "LessonEditorCurrentSlide",
        "LessonEditorDocumentReady",
        "LessonEditorForms",
        "LessonEditorGalleries",
        "LessonEditorImageResizing",
        "LessonEditorJqueryAnimations",
        "LessonEditorSlideLoading",
        "LessonEditorSlidesNavigation",
        "LessonEditorTinyMCE",
        "LessonViewerDocumentReady",
        "LessonViewerGeneral",
        "LessonViewerGraphics",
        "LessonViewerPlaylist",
        "LessonViewerSlidesNavigation",
        "MediaElementEditorCache",
        "MediaElementEditorDocumentReady",
        "MediaElementEditorForms",
        "MediaElementEditorHorizontalTimelines",
        "MediaElementLoaderDocumentReady",
        "MediaElementLoaderDone",
        "MediaElementLoaderErrors",
        "MediaElementLoaderGeneral",
        "NotificationsAccessories",
        "NotificationsDocumentReady",
        "NotificationsGraphics",
        "PlayersAudioEditor",
        "PlayersCommon",
        "PlayersDocumentReady",
        "PlayersGeneral",
        "PlayersVideoEditor",
        "ProfilePrelogin",
        "ProfileUsers",
        "SearchDocumentReady",
        "TagsAccessories",
        "TagsDocumentReady",
        "TagsInitializers",
        "VideoEditorAddComponents",
        "VideoEditorComponents",
        "VideoEditorCutters",
        "VideoEditorDocumentReady",
        "VideoEditorGalleries",
        "VideoEditorGeneral",
        "VideoEditorPreview",
        "VideoEditorPreviewAccessories",
        "VideoEditorReplaceComponents",
        "VideoEditorScrollPain",
        "VideoEditorTextComponentEditor",
        "addEmailToVirtualClassroomSendLessonLinkSelector",
        "getMaximumZIndex",
        "initializeDraggableVirtualClassroomLesson",
        "initializeNotAvailableLessonsToLoadQuick",
        "initializePlaylist",
        "initializeScrollPaneQuickLessonSelector",
        "initializeVirtualClassroom"
    ],
    "modules": [
        "administration",
        "ajax-loader",
        "audio-editor",
        "buttons",
        "dashboard",
        "dialogs",
        "galleries",
        "general",
        "image-editor",
        "lesson-editor",
        "lesson-viewer",
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