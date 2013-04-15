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
        "admin",
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
            "displayName": "admin",
            "name": "admin",
            "description": "Functions used in the Administration section: only for this section, <b>it's generated a separate file</b> which doesn't merge with the regular one. The only external module loaded is {{#crossLinkModule \"ajax-loader\"}}{{/crossLinkModule}}."
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
            "description": "The Lesson Editor is used to add and edit slides to a private lesson.\n<br/><br/>\nWhen opening the Editor on a lesson, all its slides are appended to a queue, of which it's visible only the portion that surrounds the <b>current slide</b> (the width of such a portion depends on the screen resolution, see {{#crossLink \"LessonEditorSlidesNavigation/initLessonEditorPositions:method\"}}{{/crossLink}}, {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadyResize:method\"}}{{/crossLink}} and {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadyGeneral:method\"}}{{/crossLink}}). The current slide is illuminated and editable, whereas the adhiacent slides are covered by a layer with opacity that prevents the user from editing them: if the user clicks on this layer, the application takes the slide below it as new current slide and moves it to the center of the screen (see {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadySlidesNavigator:method\"}}{{/crossLink}} and the methods in {{#crossLink \"LessonEditorSlidesNavigation\"}}{{/crossLink}}): only after this operation, the user can edit that particular slide. To avoid overloading when there are many slides containing media, the slides are instanced all together but their content is loaded only when the user moves to them (see the methods in {{#crossLink \"LessonEditorSlideLoading\"}}{{/crossLink}}).\n<br/><br/>\nOn the right side of each slide the user finds a list of <b>buttons</b> (initialized in {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadySlideButtons:method\"}}{{/crossLink}}): each button corresponds either to an action that can be performed on the slide, either to an action that can be performed to the whole lesson (for instance, save and exit, or edit title description and tags).\n<br/><br/>\nThe <b>tool to navigate the slides</b> is located on the top of the editor: each small square represents a slide (with its position), and passing with the mouse over it the Editor shows a miniature of the corresponding slide (these functionalities are initialized in {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadySlidesNavigator:method\"}}{{/crossLink}}). Clicking on a slide miniature, the application moves to that slide using the function {{#crossLink \"LessonEditorSlidesNavigation/slideTo:method\"}}{{/crossLink}}. The slides can be sorted dragging with the mouse (using the JQueryUi plugin, initialized in {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadyJqueryAnimations:method\"}}{{/crossLink}} and {{#crossLink \"LessonEditorJqueryAnimations/initializeSortableNavs:method\"}}{{/crossLink}}).\n<br/><br/>\nInside the Editor, there are two operations that require hiding and replacement of the queue of slides: <b>adding a media element to a slide</b> and <b>choosing a new slide</b>. In both these operations, an HTML div is extracted from the main template (where it was hidden), and put in the place of the current slide, hiding the rest of the slides queue, buttons, and slides navigation (operations performed by {{#crossLink \"LessonEditorCurrentSlide/hideEverythingOutCurrentSlide:method\"}}{{/crossLink}}). For the galleries, the extracted div must be filled by an action called via Ajax (see the module {{#crossLinkModule \"galleries\"}}{{/crossLinkModule}}), whereas the div with the list of available slides is already loaded with the Editor (see {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadyNewSlideChoice:method\"}}{{/crossLink}}).\n<br/><br/>\nTo add a media element to a slide, the user picks it from its specific gallery: when he clicks on the button 'plus', the system calls the corresponding subfunction in {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadyAddMediaElement:method\"}}{{/crossLink}}. To avoid troubles due to the replacement of JQuery plugins, video and audio tags, etc, this method always replaces the sources of <b>audio</b> and <b>video</b> tags and calls <i>load()</i>.\n<br/><br/>\nIf the element added is of type <b>image</b>, the user may drag it inside the slide, using {{#crossLink \"LessonEditorJqueryAnimations/makeDraggable:method\"}}{{/crossLink}}. A set of methods (in the class {{#crossLink \"LessonEditorImageResizing\"}}{{/crossLink}}) is available to resize the image and the alignment chosen by the user; more specificly, the method {{#crossLink \"LessonEditorImageResizing/isHorizontalMask:method\"}}{{/crossLink}} is used to understand, depending on the type of slide and on the proportions of the image, if the image is <b>vertical</b> (and then the user can drag it vertically) or <b>horizontal</b> (the user can drag it horizontally).\n<br/><br/>\nEach slide contains a form linked to the action that updates it, there is no global saving for the whole lesson. The slide is automaticly saved (using the method {{#crossLink \"LessonEditorForms/saveCurrentSlide:method\"}}{{/crossLink}}) <i>before moving to another slide</i>, <i>before showing the options to add a new slide</i>, and <i>before changing position of a slide</i>. The same function is called by the user when he clicks on the button 'save' on the right of each slide; the buttons <b>save and exit</b> and <b>edit general info</b> are also linked to slide saving, but in this case it's performed with a callback (see again the buttons initialization in {{#crossLink \"LessonEditorDocumentReady/lessonEditorDocumentReadySlideButtons:method\"}}{{/crossLink}}).\n<br/><br/>\nThe text slides are provided of <b>TinyMCE</b> text editor, initialized in the methods of {{#crossLink \"LessonEditorTinyMCE\"}}{{/crossLink}}."
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
            "description": "This module contains the initialization methods for <b>profiling</b> and <b>registration</b> of new users."
        },
        {
            "displayName": "search",
            "name": "search",
            "description": "Collection of initializers for the graphical effects of the <b>search engine</b>."
        },
        {
            "displayName": "tags",
            "name": "tags",
            "description": "The functions in this module handle two different functionalities of <b>autocomplete</b> for tags: suggestions for a research (<b>search autocomplete</b>), and suggestions for tagging lessons and media elements (<b>tagging autocomplete</b>). Both modes use the same JQuery plugin called <i>JQueryAutocomplete</i> (the same used in {{#crossLink \"AdminAutocomplete/initNotificationsAutocomplete:method\"}}{{/crossLink}}).\n<br/><br/>\nThe <b>search</b> autocomplete mode requires a simple initializer (method {{#crossLink \"TagsInitializers/initSearchTagsAutocomplete:method\"}}{{/crossLink}}), which is called for three different keyword inputs of the search engine (the general one, the one for elements and the one for lessons, see {{#crossLink \"TagsDocumentReady/tagsDocumentReady:method\"}}{{/crossLink}}).\n<br/><br/>\nThe <b>tagging</b> autocomplete mode is slightly more complicated, because it must show to the user a friendly view of the tags he added (small boxes with an 'x' to remove it) and at the same time store a string value to be send to the rails backend. The implemented solution is a <b>container</b> div that contains a list of tag <b>boxes</b> (implemented with span, see {{#crossLink \"TagsAccessories/createTagSpan:method\"}}{{/crossLink}}) and an <b>tag input</b> where the user writes; when he inserts a new tag and presses <i>enter</i> or <i>comma</i>, the tag is added to the previous line in the container; if such a line is full, the tag input is moved to the next line; when the lines in the container are over, the tag input gets disabled (see {{#crossLink \"TagsAccessories/disableTagsInputTooHigh:method\"}}{{/crossLink}}). During this whole process, a <b>hidden input</b> gets updated with a string representing the current tags separated by comma ({{#crossLink \"TagsAccessories/addToTagsValue:method\"}}{{/crossLink}}, {{#crossLink \"TagsAccessories/removeFromTagsValue:method\"}}{{/crossLink}}).\n<br/><br/>\nThe system also checks if the inserted tag is not repeated (using {{#crossLink \"TagsAccessories/checkNoTagDuplicates:method\"}}{{/crossLink}}), and assigns a different color for tags already in the database and for new ones ({{#crossLink \"TagsAccessories/addTagWithoutSuggestion:method\"}}{{/crossLink}}).\n<br/><br/>\nThe <b>tagging autocomplete mode</b> is initialized for six standard forms (see initializers in the class {{#crossLink \"TagsDocumentReady\"}}{{/crossLink}})."
        },
        {
            "displayName": "video-editor",
            "name": "video-editor",
            "description": "The Video Editor is structured as follows: centered in the middle of the Editor is located the <b>preview screen</b>, below it the <b>components timeline</b> and the <b>audio track</b>, and on the right the <b>preview column</b> which contains also global statistics about the video.\n<br/><br/>\nA video created with the Video Editor can be composed by <b>three types of components</b> (and optionally an <b>audio track</b>):\n<ul>\n  <li>a <b>video component</b> is an element of type video extracted from the user's gallery, associated to an <b>initial</b> and <b>final point</b></li>\n  <li>a <b>image component</b> is an element of type image extracted from the user's gallery, associated to a <b>duration</b> in seconds (the image is held in the video for a number of seconds equal to the component's duration); the image is centered and cropped maintaining its original proportions, to make it fit in the video screen (which has proportions 16/9)</li>\n  <li>a <b>text component</b> is a centered title for which the user chooses a <b>background color</b>, a <b>font color</b> and a <b>duration</b> (which has the same interpretation as for image components).</li>\n</ul>\nThe resulting video will be the concatenation of all the components inside the timeline, with optionally the chosen audio track as background audio. On the <b>timeline</b> the user may perform the following actions:\n<ul>\n  <li><b>add</b> a new component (see class {{#crossLink \"VideoEditorAddComponents\"}}{{/crossLink}}) or <b>replace</b> an existing one, even without maintaining its original type (see class {{#crossLink \"VideoEditorReplaceComponents\"}}{{/crossLink}}): these functionalities are initialized in {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyAddComponent:method\"}}{{/crossLink}}</li>\n  <li><b>remove</b> a component from the timeline (initialized in {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyRemoveComponent:method\"}}{{/crossLink}})</li>\n  <li><b>sort</b> and change the order of the components (initialized in {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyInitialization:method\"}}{{/crossLink}})</li>\n  <li><b>cut</b> a video component (change its initial and final point) or <b>change duration</b> of an image or text compoent (both these functionalities are initialized in {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyCutters:method\"}}{{/crossLink}} and implemented in the class {{#crossLink \"VideoEditorCutters\"}}{{/crossLink}}).</li>\n</ul>\nEach component is provided of its own <b>identifier</b> (the same used in {{#crossLinkModule \"audio-editor\"}}{{/crossLinkModule}}), that is unique and doesn't change on any operation performed by the user. Moreover, regardless of its type, a component is strictly linked with two <b>external accessories</b>:\n<ul>\n  <li>a <b>cutter</b> (whose HTML id is <i>video component [identifier] cutter</i>): this item is normally hidden, when requested it appears below the timeline and is used to cut a video component or change the duration of an image or text component (class {{#crossLink \"VideoEditorCutters\"}}{{/crossLink}})</li>\n  <li>a <b>preview clip</b> (whose HTML id is <i>video component [identifier] preview</i>): this item is hidden inside the <b>preview screen</b>, and it's used\n    <ul>\n      <li>to provide the user of a big clip of the component while handling it (functionality initialized in {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyComponentsCommon:method\"}}{{/crossLink}})</li>\n      <li>to play a video component while cutting it (initialized in the method {{#crossLink \"PlayersDocumentReady/playersDocumentReadyVideoEditor:method\"}}{{/crossLink}} in the module {{#crossLinkModule \"players\"}}{{/crossLinkModule}})</li>\n      <li>to be shown in the <b>global preview</b> (see class {{#crossLink \"VideoEditorPreview\"}}{{/crossLink}}).</li>\n    </ul>\n  </li>\n</ul>\nThe method that <b>extracts the identifier from a component</b> is {{#crossLink \"VideoEditorGeneral/getVideoComponentIdentifier:method\"}}{{/crossLink}} (it works receiving as parameter either the component or its cutter or preview clip).\n<br/><br/>\nWhile the user is working, the <b>preview clip</b> visible in the preview screen corresponds to the last component <b>selected</b> by the user. A component gets selected either if the user keeps the mouse on it for more than half a second (using the method {{#crossLink \"VideoEditorComponents/startVideoEditorPreviewClipWithDelay:method\"}}{{/crossLink}}, which avoids compulsive changes inside the preview screen when the user passes with the mouse over the timeline), or immediately on the actions of <b>sorting</b> and <b>cutting</b> (using the method {{#crossLink \"VideoEditorCutters/startVideoEditorPreviewClip:method\"}}{{/crossLink}}): both behaviors are initialized in {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyComponentsCommon:method\"}}{{/crossLink}}. To the <b>preview clip</b> of a video component is also associated a method ({{#crossLink \"VideoEditorGeneral/loadVideoComponentIfNotLoadedYet:method\"}}{{/crossLink}}) that loads the HTML5 video tag only when necessary: this, similarly to {{#crossLinkModule \"audio-editor\"}}{{/crossLinkModule}}, avoids overloading of the HTML.\n<br/><br/>\nThe <b>component gallery</b> used inside the Video Editor (initialized in {{#crossLink \"GalleriesInitializers/initializeMixedGalleryInVideoEditor:method\"}}{{/crossLink}}) is the only gallery in the application which contains mixed types of elements. It's divided into three sections, one for each kind of component: the sections for <b>video</b> and <b>image</b> components have the same external behavior of normal image and video galleries (see the module {{#crossLinkModule \"galleries\"}}{{/crossLinkModule}}), whereas the section for <b>text</b> components is a peculiar text editor (see the class {{#crossLink \"VideoEditorTextComponentEditor\"}}{{/crossLink}}). The component gallery (together with the regular audio gallery for the <b>audio track</b>) is initialized in {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyGalleries:method\"}}{{/crossLink}}, and its functionality defined in the methods of {{#crossLink \"VideoEditorGalleries\"}}{{/crossLink}} (for instance, the method to switch from a section to another).\n<br/><br/>\nThe method {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyAddComponent:method\"}}{{/crossLink}} initializes the general procedure to <b>add or replace a component</b>. The system sets a HTML <i>data</i> that records if the component gallery was opened to <b>replace</b> or <b>add</b> a component: depending on this data, when the user picks a component from the gallery it's called the corresponding method in {{#crossLink \"VideoEditorAddComponents\"}}{{/crossLink}} or in {{#crossLink \"VideoEditorReplaceComponents\"}}{{/crossLink}}.\n<br/><br/>\nWhen the user adds a component, the system makes a copy of an <b>empty hidden component</b> and fills it with the new data. This behavior is quite similar to the one in {{#crossLinkModule \"audio-editor\"}}{{/crossLinkModule}}, but in the case of Video Editor the procedure is slightly more complicated, due to the following reasons:\n<ul>\n  <li>there are <b>three empty items</b> (empty component, empty cutter, empty preview clip) for each type of component, <b>for a total of nine</b></li>\n  <li>unlike {{#crossLinkModule \"audio-editor\"}}{{/crossLinkModule}}, in the Video Editor each component needs a <b>miniature</b>, that necessarily must be inserted in the empty component <b>together with the rest of the data</b>. For text components, the miniature is built in the moment of the component's creation (there is an <b>empty text miniature</b> hidden in the template of text component editor, see {{#crossLink \"VideoEditorTextComponentEditor\"}}{{/crossLink}}); for video and image components, the miniatures are loaded together with the <b>mixed gallery</b> and stored <b>in the popup of each element</b> (see module {{#crossLinkModule \"galleries\"}}{{/crossLinkModule}}, and especially the <i>js.erb</i> templates associated to the routes of the mixed gallery)\n  <li>in the Video Editor it's possible to <b>replace</b> a component: when the system does this, it's not enough to fill the inputs of the previous component (with {{#crossLink \"VideoEditorComponents/fillVideoEditorSingleParameter:method\"}}{{/crossLink}}): it's additionally necessary to <b>reset the inputs</b> of the previous component, thing done by the method {{#crossLink \"VideoEditorComponents/clearSpecificVideoEditorComponentParameters:method\"}}{{/crossLink}}. Moreover, when replacing a component, the duration is updated using {{#crossLink \"VideoEditorComponents/changeDurationVideoEditorComponent:method\"}}{{/crossLink}}.</li>\n</ul>\nBesides the durations, two graphical details are peculiar to each component: the <b>position</b>, handled by {{#crossLink \"VideoEditorComponents/reloadVideoEditorComponentPositions:method\"}}{{/crossLink}}; and the <b>transition</b>, a small icon representing the <b>fade transition</b> of one second between a component and the following, that must be visible <i>after all components except for the last one</i> (see {{#crossLink \"VideoEditorComponents/resetVisibilityOfVideoEditorTransitions:method\"}}{{/crossLink}}). The operations in which callback it's necessary to reset transitions and positions are <b>sorting</b> ({{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyInitialization:method\"}}{{/crossLink}}) and <b>removing</b> ({{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyRemoveComponent:method\"}}{{/crossLink}}).\n<br/><br/>\nA video component cutter (or simply <b>cutter</b>) is an instrument used to change the initial and final second of a component of type video: it's very similar to the audio cutter, and its functionalities (JQueryUi sliders, players, etc) are defined in {{#crossLink \"PlayersVideoEditor/initializeVideoInVideoEditorPreview:method\"}}{{/crossLink}} and {{#crossLink \"PlayersDocumentReady/playersDocumentReadyVideoEditor:method\"}}{{/crossLink}}. A property that is worth mentioning is the <b>automatic return to the previous integer second</b> when pausing: this is a functionality of both cutters and global reproduction (see {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyPreview:method\"}}{{/crossLink}} and {{#crossLink \"VideoEditorPreview\"}}{{/crossLink}}), necessary to set with precision the current time of the <b>preview screen</b>, in order to simulate faithfully the effect of transitions and the correspondance with the optional audio track.\n<br/><br/>\nFor image and text components, a cutter is simply a small form where the user may insert a new duration (the associated callback is {{#crossLink \"VideoEditorComponents/changeDurationVideoEditorComponent:method\"}}{{/crossLink}}. Since it doesn't fit the whole timeline, this paraticular cutter must be aligned to the JScrollPain: this is done with the functions of the class {{#crossLink \"MediaElementEditorHorizontalTimelines\"}}{{/crossLink}}.\n<br/><br/>\nAll the cutters are initialized in {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyCutters:method\"}}{{/crossLink}}, and their functionalities included in the class {{#crossLink \"AudioEditorCutters\"}}{{/crossLink}}.\n<br/><br/>\nThe <b>text component editor</b> can be opened clicking on the icon 'T' in the header of the component editor (see method {{#crossLink \"VideoEditorGalleries/switchToOtherGalleryInMixedGalleryInVideoEditor:method\"}}{{/crossLink}}). The user can insert a text and choose background and text color: the functionality is initialized in {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyTextComponentEditor:method\"}}{{/crossLink}}, and the main methods are contained in the class {{#crossLink \"VideoEditorTextComponentEditor\"}}{{/crossLink}}. Notice that, unlike image and video components, the <b>miniature</b> of a text component is created in the moment of the insertion of the compoent (see both {{#crossLink \"VideoEditorAddComponents/addTextComponentInVideoEditor:method\"}}{{/crossLink}} and {{#crossLink \"VideoEditorReplaceComponents/replaceTextComponentInVideoEditor:method\"}}{{/crossLink}}).\n<br/><br/>\n\n\n<br/><br/>\nAs for the other Element Editors ({{#crossLinkModule \"image-editor\"}}{{/crossLinkModule}}, {{#crossLinkModule \"audio-editor\"}}{{/crossLinkModule}}) the core of the process of committing changes is handled in the module {{#crossLinkModule \"media-element-editor\"}}{{/crossLinkModule}} (more specificly in the class {{#crossLink \"MediaElementEditorForms\"}}{{/crossLink}}); the part of this functionality specific for the Video Editor is handled in {{#crossLink \"VideoEditorDocumentReady/videoEditorDocumentReadyCommit:method\"}}{{/crossLink}}."
        },
        {
            "displayName": "virtual-classroom",
            "name": "virtual-classroom",
            "description": "It's where users can share their lessons. It handles share lessons link and add to playlist actions."
        }
    ]
} };
});