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
            "description": "The galleries are containers of media elements, used at any time the user needs to pick an element of a specific type.\n<br/><br/>\nThere are three kinds of gallery, each of them has specific features depending on where it's used. Each instance of a gallery is provided of its specific url route, that performs the speficic javascript actions it requires. For instance, in the image gallery contained inside the {{#crossLinkModule \"video-editor\"}}{{/crossLinkModule}}, to each image popup (see also {{#crossLink \"DialogsGalleries/showImageInGalleryPopUp:method\"}}{{/crossLink}}) is attached additional HTML code that contains the input for inserting the duration of the image component. Each gallery is also provided of infinite scroll pagination, which is initialized in the methods of {{#crossLink \"GalleriesInitializers\"}}{{/crossLink}}. The complete list of galleries is:\n<br/>\n<ul>\n  <li>\n    <b>audio gallery</b>, whose occurrences are\n    <ul>\n      <li>in Audio Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeAudioGalleryInAudioEditor:method\"}}{{/crossLink}}</li>\n      <li>in Lesson Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeAudioGalleryInLessonEditor:method\"}}{{/crossLink}}</li>\n      <li>in Video Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeAudioGalleryInVideoEditor:method\"}}{{/crossLink}}</li>\n    </ul>\n  </li>\n  <li>\n    <b>image gallery</b>, whose occurrences are\n    <ul>\n      <li>in Image Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeImageGalleryInImageEditor:method\"}}{{/crossLink}}</li>\n      <li>in Lesson Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeImageGalleryInLessonEditor:method\"}}{{/crossLink}}</li>\n      <li>in the mixed gallery of Video Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeMixedGalleryInVideoEditor:method\"}}{{/crossLink}}</li>\n    </ul>\n  </li>\n  <li>\n    <b>video gallery</b>, whose occurrences are\n    <ul>\n      <li>in Lesson Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeVideoGalleryInLessonEditor:method\"}}{{/crossLink}}</li>\n      <li>in the mixed gallery of Video Editor, initialized by {{#crossLink \"GalleriesInitializers/initializeMixedGalleryInVideoEditor:method\"}}{{/crossLink}}.</li>\n    </ul>\n  </li>\n</ul>"
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
            "description": "This module contains all the patches for JQuery. Notice that the methods listed here sometimes are defined using anonimous functions fired in this same file: this is because in the javascript loading tree these functions can be loaded where the application needs, rather than in the file <i>document_ready.js</i>.\n<br/><br/>\nSo far the only class present in the module is {{#crossLink \"JqueryPatchesBrowsers\"}}{{/crossLink}}, used to detect browsers. The functions in this class differ by {{#crossLink \"AdminDocumentReady/adminBrowsersDocumentReady:method\"}}{{/crossLink}} and {{#crossLink \"GeneralDocumentReady/browsersDocumentReady:method\"}}{{/crossLink}} because instead of adding a class to the HTML tag they create an attribute for a JQuery object."
        },
        {
            "displayName": "lesson-editor",
            "name": "lesson-editor",
            "description": "The Lesson Editor is used to add and edit slides to a private lesson.\n<br/><br/>\nWhen opening the Editor on a lesson, all its slides are appended to a queue, of which it's visible only the portion that surrounds the <b>current slide</b> (the width of such a portion depends on the screen resolution, see {{#crossLink \"LessonEditorSlidesNavigation/initLessonEditorPositions:method\"}}{{/crossLink}}, {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadyResize:method\"}}{{/crossLink}} and {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadyGeneral:method\"}}{{/crossLink}}). The current slide is illuminated and editable, whereas the adhiacent slides are covered by a layer with opacity that prevents the user from editing them: if the user clicks on this layer, the application takes the slide below it as new current slide and moves it to the center of the screen (see {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadySlidesNavigator:method\"}}{{/crossLink}} and the methods in {{#crossLink \"LessonEditorSlidesNavigation\"}}{{/crossLink}}): only after this operation, the user can edit that particular slide. To avoid overloading when there are many slides containing media, the slides are instanced all together but their content is loaded only when the user moves to them (see the methods in {{#crossLink \"LessonEditorSlideLoading\"}}{{/crossLink}}).\n<br/><br/>\nOn the right side of each slide the user finds a list of <b>buttons</b> (initialized in {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadySlideButtons:method\"}}{{/crossLink}}): each button corresponds either to an action that can be performed on the slide, either to an action that can be performed to the whole lesson (for instance, save and exit, or edit title description and tags).\n<br/><br/>\nThe tool to navigate the slides is located on the top of the editor: each small square represents a slide (with its position), and passing with the mouse over it the Editor shows a miniature of the corresponding slide (these functionalities are initialized in {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadySlidesNavigator:method\"}}{{/crossLink}}). Clicking on a slide miniature, the application moves to that slide using the function {{#crossLink \"LessonEditorSlidesNavigation/slideTo:method\"}}{{/crossLink}}. The slides can be sorted dragging with the mouse (using the JQueryUi plugin, initialized in {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadyJqueryAnimations:method\"}}{{/crossLink}} and {{#crossLink \"LessonEditorJqueryAnimations/initializeSortableNavs:method\"}}{{/crossLink}}).\n<br/><br/>\nInside the Editor, there are two operations that require hiding and replacement of the queue of slides: <b>adding a media element to a slide</b> and <b>choosing a new slide</b>. In both these operations, an HTML div is extracted from the main template (where it was hidden), and put in the place of the current slide, hiding the rest of the slides queue, buttons, and slides navigation (operations performed by {{#crossLink \"LessonEditorCurrentSlide/hideEverythingOutCurrentSlide:method\"}}{{/crossLink}}). For the galleries, the extracted div must be filled by an action called via Ajax (see the module {{#crossLinkModule \"galleries\"}}{{/crossLinkModule}}), whereas the div with the list of available slides is already loaded with the Editor (see {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadyNewSlideChoice:method\"}}{{/crossLink}}).\n<br/><br/>\nTo add a media element to a slide, the user picks it from its specific gallery: when he clicks on the button 'plus', the system calls the corresponding subfunction in {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadyAddMediaElement:method\"}}{{/crossLink}}. To avoid troubles due to the replacement of JQuery plugins, video and audio tags, etc, this method always replaces the sources of <b>audio</b> and <b>video</b> tags and calls <i>load()</i>.\n<br/><br/>\nIf the element added is of type <b>image</b>, the user may drag it inside the slide, using {{#crossLink \"LessonEditorJqueryAnimations/makeDraggable:method\"}}{{/crossLink}}. A set of methods (in the class {{#crossLink \"LessonEditorImageResizing\"}}{{/crossLink}}) is available to resize the image and the alignment chosen by the user; more specificly, the method {{#crossLink \"LessonEditorImageResizing/isHorizontalMask:method\"}}{{/crossLink}} is used to understand, depending on the type of slide and on the proportions of the image, if the image is <b>vertical</b> (and then the user can drag it vertically) or <b>horizontal</b> (the user can drag it horizontally).\n<br/><br/>\nEach slide contains a form linked to the action that updates it, there is no global saving for the whole lesson. The slide is automaticly saved (using the method {{#crossLink \"LessonEditorForms/saveCurrentSlide:method\"}}{{/crossLink}}) <i>before moving to another slide</i>, <i>before showing the options to add a new slide</i>, and <i>before changing position of a slide</i>. The same function is called by the user when he clicks on the button 'save' on the right of each slide; the buttons <b>save and exit</b> and <b>edit general info</b> are also linked to slide saving, but in this case it's performed with a callback (see again the buttons initialization in {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadySlideButtons:method\"}}{{/crossLink}}).\n<br/><br/>\nThe text slides are provided of TinyMCE text editor, initialized in the methods of {{#crossLink \"LessonEditorTinyMCE\"}}{{/crossLink}}."
        },
        {
            "displayName": "lesson-viewer",
            "name": "lesson-viewer",
            "description": "The Lesson Viewer is the instrument to reporoduce single and multiple lessons (playlists). The Viewer provides the user of a screen containing the current slide with <b>two arrows</b> to switch to the next one. If the lesson is being reproduced inside a playlist, it's additionally available a <b>playlst menu</b> (opened on the bottom of the current slide).\n<br/><br/>\nThe main methods of this module are {{#crossLink \"LessonViewerSlidesNavigation/slideToInLessonViewer:method\"}}{{/crossLink}} (moves to a given slide) and {{#crossLink \"LessonViewerPlaylist/switchLessonInPlaylistMenuLessonViewer:method\"}}{{/crossLink}} (moves to the first slide of a given lesson and updates the selected lesson in the menu). The first method can be used separately if there is no playlist, or together with the second one if there is one (they are called together inside {{#crossLink \"LessonViewerSlidesNavigation/slideToInLessonViewerWithLessonSwitch:method\"}}{{/crossLink}}).\n<br/><br/>\nAdditionally, {{#crossLink \"LessonViewerPlaylist/switchLessonInPlaylistMenuLessonViewer:method\"}}{{/crossLink}} can be provided of a callback that is passed to {{#crossLink \"LessonViewerPlaylist/selectComponentInLessonViewerPlaylistMenu:method\"}}{{/crossLink}} and executed after the animation of the scroll inside the lesson menu: the callback is used when the user selects a lesson directly from the menu, and {{#crossLink \"LessonViewerSlidesNavigation/slideToInLessonViewer:method\"}}{{/crossLink}} is executed to get to the cover of the selected lesson after that the menu has been closed.\n<br/><br/>\nThere are <b>three known bugs</b> due to the bad quality of the plugin <b>JScrollPain</b>:\n<ul>\n  <li>When the user passes from <i>the first slide of the third lesson</i> to <i>the last slide of the second lesson</i>, the scroll doesn't follow the selection of the new lesson</li>\n  <li>Same problem when the user passes from <i>the last slide of the last lesson</i> to <i>the first slide of the first lesson</i></li>\n  <li>If, after having opened <b>for the first time</b> (and only for that time) the playlist menu, I click before two seconds on a lesson, the menu gets broken</li>\n</ul>"
        },
        {
            "displayName": "media-element-editor",
            "name": "media-element-editor",
            "description": "This module contains javascript functions common to all the editors ({{#crossLinkModule \"audio-editor\"}}{{/crossLinkModule}}, {{#crossLinkModule \"image-editor\"}}{{/crossLinkModule}}, {{#crossLinkModule \"video-editor\"}}{{/crossLinkModule}})."
        },
        {
            "displayName": "media-element-loader",
            "name": "media-element-loader",
            "description": "Javascript functions used in the media element loader."
        },
        {
            "displayName": "notifications",
            "name": "notifications",
            "description": "Javascript functions used to handle notifications."
        },
        {
            "displayName": "players",
            "name": "players",
            "description": "This module contains the javascript functions and initializers used in the <b>media players</b> all over the application. The model can be divided into three main classes:\n<ul>\n  <li>{{#crossLink \"PlayersGeneral\"}}{{/crossLink}}, used in the generic players, for instance in {{#crossLinkModule \"lesson-editor\"}}{{/crossLinkModule}} and {{#crossLinkModule \"lesson-viewer\"}}{{/crossLinkModule}}</li>\n  <li>{{#crossLink \"PlayersAudioEditor\"}}{{/crossLink}}, used in the players of the module {{#crossLinkModule \"audio-editor\"}}{{/crossLinkModule}} (only players of kind <b>audio</b>)</li>\n  <li>{{#crossLink \"PlayersVideoEditor\"}}{{/crossLink}}, used in the players of the module {{#crossLinkModule \"video-editor\"}}{{/crossLinkModule}} (mainly players of kind <b>video</b>, but also of kind <b>audio</b> for the background audio track).</li>\n</ul>"
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
            "description": "Provides video editor ajax actions. TODO per quanto riguarda la fase di commit, copiare il paragrafo da audio e image editor e adattarlo"
        },
        {
            "displayName": "virtual-classroom",
            "name": "virtual-classroom",
            "description": "It's where users can share their lessons. It handles share lessons link and add to playlist actions."
        }
    ]
} };
});