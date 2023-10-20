#define IDD_MAIN              0
#define IDD_GAME              1
#define IDD_SINGLE_MISSION    2
#define IDD_OPTIONS           3
#define IDD_CONFIGURE         4
#define IDD_OPTIONS_VIDEO     5
#define IDD_OPTIONS_AUDIO     6
#define IDD_MULTIPLAYER       8
#define IDD_LOAD_AAR          9
#define IDD_MAIN_MAP          12
#define IDD_SAVE              13
#define IDD_END               14
#define IDD_SERVER            17
#define IDD_CLIENT            18
#define IDD_IP_ADDRESS        19
#define IDD_SERVER_SETUP      20
#define IDD_CLIENT_SETUP      21
#define IDD_CLIENT_WAIT       22
#define IDD_CHAT              24
#define IDD_CUSTOM_ARCADE     25
#define IDD_ARCADE_MAP        26
#define IDD_ARCADE_UNIT       27
#define IDD_ARCADE_WAYPOINT   28
#define IDD_TEMPLATE_SAVE     29
#define IDD_TEMPLATE_LOAD     30
#define IDD_LOGIN             31
#define IDD_INTEL             32
#define IDD_CAMPAIGN          33
#define IDD_CREDITS           34
#define IDD_INTEL_GETREADY    37
#define IDD_ARCADE_GROUP      40
#define IDD_ARCADE_SENSOR     41
#define IDD_NEW_USER          42
#define IDD_CAMPAIGN_LOAD     43
#define IDD_ARCADE_EFFECTS    44
#define IDD_ARCADE_MARKER     45
#define IDD_MISSION           46
#define IDD_INTRO             47
#define IDD_OUTRO             48
#define IDD_INTERRUPT         49
#define IDD_DEBRIEFING        50
#define IDD_SELECT_ISLAND     51
#define IDD_SERVER_GET_READY  52
#define IDD_CLIENT_GET_READY  53
#define IDD_INSERT_MARKER     54
#define IDD_VOICE_CHAT        55
#define IDD_DEBUG             56
#define IDD_HINTC             57
#define IDD_MISSION_END       58
#define IDD_SERVER_SIDE       59
#define IDD_CLIENT_SIDE       60
#define IDD_MULTIPLAYER_ROLE  61
#define IDD_AWARD             62
#define IDD_CHANNEL           63
#define IDD_PASSWORD          64
#define IDD_MP_PLAYERS        65
#define IDD_REVERT            66
#define IDD_PORT              69
#define IDD_MP_SETUP          70
#define IDD_FILTER            71
#define IDD_HINTC_EX          72
#define IDD_SELECT_PROFILE    73
#define IDD_CAMPAIGN_SELECT   74
#define IDD_PROFILE           75
#define IDD_PROFILE_NAME        76
#define IDD_PROFILE_FACE        77
#define IDD_PROFILE_VOICE       78
#define IDD_PROFILE_CONTROLLER  79
#define IDD_PROFILE_AUDIO       80
#define IDD_PROFILE_VIDEO       81
#define IDD_PROFILE_LIVE        82
#define IDD_MP_TYPE             83
#define IDD_MP_PASSCODE         84
#define IDD_OPTIMATCH_FILTER    86
#define IDD_QUICKMATCH          87
#define IDD_FRIENDS             88
#define IDD_FRIENDS_OPTIONS     89
#define IDD_XWIZARD_TEMPLATE    90
#define IDD_XWIZARD_INTEL       91
#define IDD_XWIZARD_NAME        92
#define IDD_XWIZARD_ISLAND      93
#define IDD_XWIZARD_WEATHER     94
#define IDD_XWIZARD_TIME        95
#define IDD_XWIZARD_UNIT        96
#define IDD_XWIZARD_MAP         97
#define IDD_XWIZARD_UNIT_SELECT 98
#define IDD_XWIZARD_UNIT_SELECT_CUSTOM  99
#define IDD_XWIZARD_WAYPOINT            100
#define IDD_DOWNLOAD_CONTENT            101
#define IDD_DOWNLOAD_CONTENT_DETAILS    102
#define IDD_XPLAYERS                    103
#define IDD_XPLAYERS_ACTIONS            104
#define IDD_XPLAYERS_FEEDBACK           105
#define IDD_GEAR                        106
#define IDD_EQUIP                       555
#define IDD_DOWNLOAD_CONTENT_INSTALL    108
#define IDD_SERVER_SETTINGS             109
#define IDD_SERVER_ADVANCED             110
#define IDD_SERVER_SELECT_PLAYER        112
#define IDD_DEDICATED_SERVER            114
#define IDD_FRIEND_MISSIONS             115
#define IDD_LIVE_STATS                  116
#define IDD_LIVE_STATS_BOARD            117
#define IDD_NETWORK_CONDITIONS          118
#define IDD_SEND_VOICE_MAIL             119
#define IDD_RECEIVE_VOICE_MAIL          120
#define IDD_SELECT_ISLAND_NEW           351

#define IDD_EDIT_OBJECT                 121
#define IDD_MISSION_LOAD                122
#define IDD_MISSION_SAVE                123

#define IDD_EDIT_DIARY_RECORD           125

#define IDD_SERVER_VOTED                126
#define IDD_DEDICATED_SERVER_SETTINGS   127

#define IDD_MISSION_EDITOR              128

#define IDD_DIARY                       129

#define IDD_TEAM_SWITCH                 130

#define IDD_CONFIGURE_ACTION            131

#define IDD_HOST_SETTINGS               132

#define IDD_MINIMAP                     133
#define IDD_OVERLAY_CREATE              134
#define IDD_OVERLAY_LOAD                135

#define IDD_ESRB                        136

#define IDD_MISSION_EDITOR_REALTIME     137

//TODO: Has to be checked by Pete!
#define IDD_EDIT_BRIEFING               138
#define IDD_LIVE                        139

#define IDD_LASE                        141

#define IDD_LAYER_LOAD                  142

#define IDD_CONTROLS                    143
#define IDD_INTERRUPT_REVERT            144

#define IDD_PERFORMANCE                 145
#define IDD_XWIZARD_PARAMS              146
#define IDD_XWIZARD_PARAMETER           147

#define IDD_CONFIGURE_JOYSTICKS         148
#define IDD_CAPTURE                     149
#define IDD_CUSTOMIZE_CONTROLLER        150
#define IDD_GAMEOPTIONS                 151

//new editor dialog
#define IDD_ARCADE_MODULES              153
#define IDD_SELECT_SAVE                 154
#define IDD_DSINTERFACE                 155
#define IDD_ADDON_ACTIONS               156

// PhysX debug window
#define IDD_PHYSX_DEBUG                 157

// mod launcher dialog
#define IDD_MOD_LAUNCHER                157
#define IDD_NEW_MOD                     158

// joystick schemes mapping dialog
#define IDD_JOYSTICK_SCHEMES            159

//AV Terminal dialog - MUF
#define IDD_AV_TERMINAL                 160
//Field Manual
#define IDD_FIELD_MANUAL                162
//Dialogue for controls scheme selection
#define IDD_CONTROLS_SCHEME             163
//Dialogue for choosing layout of mission editor. NOTE: 161-163 are already in use, see A3\Ui_f\hpp\defineResincl.inc
#define IDD_EDITOR_LAYOUT               164
//Dialogue for publishing mission on Steam.
#define IDD_PUBLISH_MISSION             165
//Dialogue for selecting tags for mission on Steam.
#define IDD_PUBLISH_MISSION_TAGS 166
//Dialogue for selecting file from the hard drive
#define IDD_FILE_SELECT_DIALOG           167
//Idd reserved for debriefing            168
#define IDD_DLC_VEHICLEMSGBOX            169
#define IDD_DLC_PURCHASENOTIFICATION     170
#define IDD_BOOTCAMPMSGBOX               171
#define IDD_COMMUNITY_GUIDE              172
#define IDD_SLING_LOAD_ASSISTANT         173
#define IDD_DLC_CONTENTBROWSER           174
#define IDD_MP_SCORE_TABLE               175
#define IDD_CAMPAIGN_MP                  176
#define IDD_MP_QUICK_PLAY                177
#define IDD_MP_SERVER_SEARCH             178
#define IDD_MP_SERVER_FOUND              179
#define IDD_KEYMAPMSGBOX                 180

// MessageBoxes
#define IDD_MSG_DELETEPLAYER      200
#define IDD_MSG_DELETEGAME        201
#define IDD_MSG_CLEARTEMPLATE     202
#define IDD_MSG_EXITTEMPLATE      203
#define IDD_MSG_LAUNCHGAME        204 // ADDED IN PATCH 1.04

#define IDD_MSG_NEWACCOUNT        205

#define IDD_MSG_FRIENDS_REMOVE    206
#define IDD_MSG_FRIENDS_BLOCK     207
#define IDD_MSG_FRIENDS_INVITE    208

#define IDD_MSG_DELETEMISSION     209

#define IDD_MSG_XONLINE_CONNECTION_FAILED 210
#define IDD_MSG_XONLINE_UPDATE_REQUIRED   211
#define IDD_MSG_XONLINE_SERVER_BUSY       212
#define IDD_MSG_XONLINE_REQUIRED_MSG      213
#define IDD_MSG_XONLINE_RECOMMENDED_MSG   214
#define IDD_MSG_XONLINE_INVALID_USER      215
#define IDD_MSG_XONLINE_WRONG_PASSCODE    216

#define IDD_MSG_CANCEL_SUBSCRIPTION       217
#define IDD_MSG_SUBSCRIBE                 218
#define IDD_MSG_PURCHASE                  219
#define IDD_MSG_INSTALL_ABORT             220
#define IDD_MSG_INSTALL_RESULT            221

#define IDD_MSG_DECLINE_INVITATION        222
#define IDD_MSG_REVOKE_INVITATION         223
#define IDD_MSG_BLOCK_REQUEST             224
#define IDD_MSG_DECLINE_REQUEST           225
#define IDD_MSG_CANCEL_REQUEST            226
#define IDD_MSG_KICK_OFF                  227
#define IDD_MSG_TERMINATE_SESSION         228
#define IDD_MSG_NETWORK_CONDITIONS        229

#define IDD_MSG_STATS_NOT_UPLOADED        230

#define IDD_MSG_LOAD_FAILED               231
#define IDD_MSG_DELETESAVE                232

#define IDD_MSG_DISK_FULL                 233

#define IDD_MSG_RESTART_MISSION           234
#define IDD_MSG_SAVE_MISSION              235
#define IDD_MSG_SIGN_OUT                  236
#define IDD_MSG_LOAD_MISSION              237
#define IDD_MSG_NEGATIVE_FEEDBACK         238
#define IDD_MSG_PENDING_INVITATION        239
#define IDD_MSG_HOST_SESSION              240
#define IDD_MSG_ROLES_LOST                241
#define IDD_MSG_ACCEPT_INVITATION         242
#define IDD_MSG_MP_PLAYER_COUNT           243
#define IDD_MSG_GAME_JOIN                 244
#define IDD_MSG_EDITOR_WIZARD_NONAME_MISSION  245

#define IDD_MSG_RESTART_NEEDED    246

// new editor
#define IDD_MSG_COMMIT_OVERLAY    247
#define IDD_MSG_CLEAR_OVERLAY     248
#define IDD_MSG_LOAD_OVERLAY      249
#define IDD_MSG_EXIT_OVERLAY      250
#define IDD_MSG_CREATE_OVERLAY    251
#define IDD_MSG_CLOSE_OVERLAY     252
#define IDD_MSG_LOAD_AAR          253
#define IDD_MSG_CLEAR_MISSION     254
#define IDD_MSG_RETRY_MISSION     255
#define IDD_MSG_DELETE_DIARY_RECORD 256

// XBOX 360 profile and save messages
#define IDD_MSG_XBOX_NO_SIGN_IN      257
#define IDD_MSG_XBOX_NO_STORAGE      258
#define IDD_MSG_XBOX_STORAGE_CHANGED 259
#define IDD_MSG_XBOX_SAVE_FAILED     260
#define IDD_MSG_XBOX_NO_STORAGE_ON_INVITE    261

#define IDD_OPTIONS_AUDIO_ADJUST_MIC         262

//MUF-MessageBox for restarting mission editor during layout change
#define IDD_MSG_RESTART_EDITOR               263

#define IDD_PROGRESS_MESSAGE                 264

//Message box for confirming deleting published mission
#define IDD_MSG_DELETE_STEAM_MISSION         265
//Message box for confirming updating published mission
#define IDD_MSG_UPDATE_STEAM_MISSION         266
//Message box for confirming saving current mission before the publish dialog is opened
#define IDD_MSG_SAVE_MISSION_BEFORE_PUBLISH  267
//Message box for asking user to agree with Battleye licence.
#define IDD_MSG_BATTLEYE_LICENCE             268
#define IDD_MSG_UPNP_ACTIVATION              269
//#define IDD_MSG_ACCOUNT_LOGIN_GUIDE        270 - Reserved

// InGameUI
#define IDD_UNITINFO              300
#define IDD_HINT                  301
#define IDD_TASKHINT              302
#define IDD_STANCEINFO            303
#define IDD_AVCAMERA              304
#define IDD_STAMINA_BAR           305

//Custom Info
#define IDD_CUSTOMINFO          			310
#define IDD_CUSTOMINFO_MINIMAP         		311
#define IDD_CUSTOMINFO_SLA          		312
#define IDD_CUSTOMINFO_CREW        			313
#define IDD_CUSTOMINFO_SENS         		314
#define IDD_CUSTOMINFO_FEEDUAV      		315
#define IDD_CUSTOMINFO_FEEDDRIVER   		316
#define IDD_CUSTOMINFO_FEEDPRIMARYGUNNER    317
#define IDD_CUSTOMINFO_FEEDCOMMANDER        318
#define IDD_CUSTOMINFO_FEEDMISSILE	        319
#define IDD_CUSTOMINFO_MINEDETECT	        320


// Futura ui
#define IDD_FUTURAGEAR            602
