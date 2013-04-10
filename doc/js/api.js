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
        "JqueryPatchesBrowsers",
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
        "VirtualClassroomDocumentReady",
        "VirtualClassroomJavaScriptAnimations",
        "VirtualClassroomMultipleLoading",
        "VirtualClassroomSendLink"
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
        "jquery-patches",
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
            "description": "Here it's defined the general <b>ajax loader</b> of the application."
        },
        {
            "displayName": "audio-editor",
            "name": "audio-editor",
            "description": "This module contains javascript functions used to animate the Audio Editor. The editing of an audio consists in cutting and connecting together different elements of type audio (referred to as <b>audio components</b>): each component has a unique <b>identifier</b>, to be distinguished by the ID in the database of the corresponding audio.\n<br/><br/>\nEach audio component contains a <b>cutter</b> (used to select a portion of the original audio), the standard player controls, and a <b>sorting handle</b>. To use the controls of a component, first it must be <b>selected</b> (using the function {{#crossLink \"AudioEditorComponents/selectAudioEditorComponent:method\"}}{{/crossLink}}): if a component is not selected, it's shown with opacity and without the player controls. The functionality of sorting components is handled in {{#crossLink \"AudioEditorDocumentReady/audioEditorDocumentReadyGeneral:method\"}}{{/crossLink}}; the functionalities of player commands, together with the most important functionalities of the cutter, are located in the module {{#crossLinkModule \"players\"}}{{/crossLinkModule}} (class {{#crossLink \"PlayersAudioEditor\"}}{{/crossLink}}); the only functionalities of the cutter located in this module are found in the class {{#crossLink \"AudioEditorCutters\"}}{{/crossLink}} and in the method {{#crossLink \"AudioEditorDocumentReady/audioEditorDocumentReadyCutters:method\"}}{{/crossLink}} (functionality of precision arrows).\n<br/><br/>\nOn the top of the right column are positioned the time durations (updated with {{#crossLink \"AudioEditorComponents/changeDurationAudioEditorComponent:method\"}}{{/crossLink}}), ad the button 'plus' used to open the audio gallery (see the class {{#crossLink \"AudioEditorGalleries\"}}{{/crossLink}} and the method {{#crossLink \"AudioEditorDocumentReady/audioEditorDocumentReadyGeneral:method\"}}{{/crossLink}}).\n<br/><br/>\nOn the bottom of the right column are positioned the controls for the <b>global preview</b> (which plays all the components globally). Similarly to the module {{#crossLinkModule \"video-editor\"}}{{/crossLinkModule}}, before playing the global preview the system must enter in <b>preview mode</b>: the difference is that in the Audio Editor this mode is switched automatically by the system, whereas in the Video Editor it's the user who decides to enter and leave the preview mode. To enter in preview mode we use the method {{#crossLink \"AudioEditorPreview/enterAudioEditorPreviewMode:method\"}}{{/crossLink}}, which calls {{#crossLink \"AudioEditorPreview/switchAudioComponentsToPreviewMode:method\"}}{{/crossLink}} or each component. A component in preview mode can be <b>selected</b> (using a differente method respect to the normal component selection: see {{#crossLink \"AudioEditorPreview/selectAudioEditorComponentInPreviewMode:method\"}}{{/crossLink}}). Each component in the global preview is played using the method {{#crossLink \"AudioEditorPreview/startAudioEditorPreview:method\"}}{{/crossLink}} (to which we pass the component to start with); the main part of the functionality of passing from a component to the next one during the global preview is handled in the module {{#crossLinkModule \"players\"}}{{/crossLinkModule}} (more specificly, in the method {{#crossLink \"PlayersAudioEditor/initializeActionOfMediaTimeUpdaterInAudioEditor:method\"}}{{/crossLink}}.\n<br/><br/>\nAs for the other Element Editors ({{#crossLinkModule \"image-editor\"}}{{/crossLinkModule}}, {{#crossLinkModule \"video-editor\"}}{{/crossLinkModule}}) the core of the process of committing changes is handled in the module {{#crossLinkModule \"media-element-editor\"}}{{/crossLinkModule}} (more specificly in the class {{#crossLink \"MediaElementEditorForms\"}}{{/crossLink}}); the part of this functionality specific for the Audio Editor is handled in {{#crossLink \"AudioEditorDocumentReady/audioEditorDocumentReadyCommit:method\"}}{{/crossLink}}."
        },
        {
            "displayName": "buttons",
            "name": "buttons",
            "description": "Lessons and Elements actions triggered via buttons."
        },
        {
            "displayName": "dashboard",
            "name": "dashboard",
            "description": "The dashboard is the home page of DESY: the page is divided in two sections, one for <b>suggested elements</b> and one for <b>suggested lessons</b>. Each of these two sections is split into three pages of lessons and elements. When the server loads the dashboard, all the six pages (three for lessons, three for elements) are loaded together, and all the operations are handled with javascript functions.\n<br/><br/>\nThere are two simple functions that switch between the pages for lessons and elements (see both methods of {{#crossLink \"DashboardGeneral\"}}{{/crossLink}}). A bit more complicated are the functions to pass from a page to another (all contained in the class {{#crossLink \"DashboardPagination\"}}{{/crossLink}}): the core of such an asynchronous pagination is the method {{#crossLink \"DashboardPagination/getHtmlPagination:method\"}}{{/crossLink}} that reconstructs the normal pagination without calling the corresponding partial in <i>views/shared/pagination.html.erb</i>: this pagination is unique for both elements and lessons, and it is reloaded each time the user changes page using the functions {{#crossLink \"DashboardPagination/reloadLessonsDashboardPagination:method\"}}{{/crossLink}} and {{#crossLink \"DashboardPagination/reloadMediaElementsDashboardPagination:method\"}}{{/crossLink}}."
        },
        {
            "displayName": "dialogs",
            "name": "dialogs",
            "description": "This module contains the javascript functions that use JQueryUi dialogs. Some of them are closed with a time delay (class {{#crossLink \"DialogsTimed\"}}{{/crossLink}}), other are closed with buttons by the user (class {{#crossLink \"DialogsConfirmation\"}}{{/crossLink}}), and other ones contain a form to be filled in by the user (class {{#crossLink \"DialogsWithForm\"}}{{/crossLink}})."
        },
        {
            "displayName": "galleries",
            "name": "galleries",
            "description": "The galleries are containers of media elements, used at any time the user needs to pick an element of a specific type.\n<br/><br/>\nThere are three kinds of gallery, each of them has specific features depending on where it's used. Each instance of a gallery is provided of its specific url route, that performs the speficic javascript actions it requires. For instance, in the image gallery contained inside the {{#crossLinkModule \"video-editor\"}}{{/crossLinkModule}}, to each image popup (see also {{#crossLink \"DialogsGalleries/showImageInGalleryPopUp:method\"}}{{/crossLink}}) is attached additional HTML code that contains the input for inserting the duration of the image component. Each gallery is also provided of infinite scroll pagination, which is initialized in the methods of {{#crossLink \"GalleriesInitializers\"}}{{/crossLink}}. The complete list of galleries is:\n<br/>\n<ul>\n  <li>\n    <b>audio gallery</b>, whose occurrences are\n    <ul>\n      <li>in Audio Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeAudioGalleryInAudioEditor:method\"}}{{/crossLink}}</li>\n      <li>in Lesson Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeAudioGalleryInLessonEditor:method\"}}{{/crossLink}}</li>\n      <li>in Video Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeAudioGalleryInVideoEditor:method\"}}{{/crossLink}}</li>\n    </ul>\n  </li>\n  <li>\n    <b>image gallery</b>, whose occurrences are\n    <ul>\n      <li>in Image Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeImageGalleryInImageEditor:method\"}}{{/crossLink}}</li>\n      <li>in Lesson Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeImageGalleryInLessonEditor:method\"}}{{/crossLink}}</li>\n      <li>in the mixed gallery of Video Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeMixedGalleryInVideoEditor:method\"}}{{/crossLink}}</li>\n    </ul>\n  </li>\n  <li>\n    <b>video gallery</b>, whose occurrences are\n    <ul>\n      <li>in Lesson Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeVideoGalleryInLessonEditor:method\"}}{{/crossLink}}</li>\n      <li>in the mixed gallery of Video Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeMixedGalleryInVideoEditor:method\"}}{{/crossLink}}</li>\n    </ul>\n  </li>\n</ul>"
        },
        {
            "displayName": "general",
            "name": "general",
            "description": "Generic javascript functions user throughout the application."
        },
        {
            "displayName": "image-editor",
            "name": "image-editor",
            "description": "The Image Editor can perform two kinds of operations on an image: <b>crop selection</b>, and <b>insertion of texts</b>.\n<br/><br/>\nThe editor is structured as follows: in the center of the screen is located the image under modification, scaled to fit the available space but conserving its original proportions (the coordinates are extracted using the method {{#crossLink \"ImageEditorImageScale/getRelativePositionInImageEditor:method\"}}{{/crossLink}}); the column on the left contains the icons for both available actions.\n<br/><br/>\nClicking on the icon 'crop', the user enters in the <b>crop mode</b>: the image is sensible to the action of clicking and dragging, and reacts showing a selected area with the rest of the image shadowed (see the initializer {{#crossLink \"ImageEditorDocumentReady/imageEditorDocumentReadyCrop:method\"}}{{/crossLink}}). Similarly, clicking on the icon 'texts', the user enters in <b>texts insertion mode</b>: this means that clicking on the image he can create small editable text areas that will be added on the image (see the initializer {{#crossLink \"ImageEditorDocumentReady/imageEditorDocumentReadyTexts:method\"}}{{/crossLink}} and the class {{#crossLink \"ImageEditorTexts\"}}{{/crossLink}}). While the user is in crop mode or texts insertion mode, he can come back to the initial status of the editor clicking on one of the two buttons on the bottom right corner of the image: <b>cancel</b> resets the mode without applying the modifications, and <b>apply</b> does the same but saving the image first (the graphics of these operations is handled in the class {{#crossLink \"ImageEditorGraphics\"}}{{/crossLink}}).\n<br/><br/>\nThe image in editing is conserved in a temporary folder, together with the version of the image before the last step of editing. Each time a new operation is performed, the temporary image is saved in the place of its old version: this way it's always possible to undo the last operation (there is a specific route for this, initialized in the method {{#crossLink \"ImageEditorDocumentReady/imageEditorDocumentReadyUndo:method\"}}{{/crossLink}}).\n<br/><br/>\nAs for the other Element Editors ({{#crossLinkModule \"audio-editor\"}}{{/crossLinkModule}}, {{#crossLinkModule \"video-editor\"}}{{/crossLinkModule}}) the core of the process of committing changes is handled in the module {{#crossLinkModule \"media-element-editor\"}}{{/crossLinkModule}} (more specificly in the class {{#crossLink \"MediaElementEditorForms\"}}{{/crossLink}}); the part of this functionality specific for the Image Editor is handled in {{#crossLink \"ImageEditorDocumentReady/imageEditorDocumentReadyCommit:method\"}}{{/crossLink}}."
        },
        {
            "displayName": "jquery-patches",
            "name": "jquery-patches",
            "description": "bla bla bla (dire che devono venire caricati prima di document ready, e che a momento c'è solamente la classe per detectare i browsers)"
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
            "description": "bla bla bla -- dire dove è situato il bottone di commit in tutti gli editors."
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