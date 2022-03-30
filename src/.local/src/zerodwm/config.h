/*
//         .             .              .		  
//         |             |              |           .	  
// ,-. ,-. |-. ,-. . ,-. |  ,_, ,-. ,-. |-. ,-,-. . |- ,_, 
// | | ,-| | | |   | |-' |   /  `-. |   | | | | | | |   /  
// `-| `-^ ^-' '   ' `-' `' '"' `-' `-' ' ' ' ' ' ' `' '"' 
//  ,|							  
//  `'							  
// GITHUB:https://github.com/gabrielzschmitz		  
// INSTAGRAM:https://www.instagram.com/gabrielz.schmitz/   
// DOTFILES:https://github.com/gabrielzschmitz/dotfiles/
*/
/* See LICENSE file for copyright and license details. */
#define TERMINAL "st"
#define TERMCLASS "st"

/* appearance */
static const unsigned int borderpx  = 4;        /* border pixel of windows */
static const unsigned int snap      = 10;       /* snap pixel */
static const unsigned int gappih    = 8;        /* horiz inner gap between windows */
static const unsigned int gappiv    = 8;        /* vert inner gap between windows */
static const unsigned int gappoh    = 10;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 10;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int user_bh            = 32;       /* 0 means that dwm will calculate bar height, >= 1 means dwm will user_bh as bar height */
static const int vertpad            = 0;       /* vertical padding of bar */
static const int sidepad            = 0;       /* horizontal padding of bar */
// static const char *fonts[]          = { "Terminus:size=12:antialias=true:autohint=false" };
static const char *fonts[]          = { "Iosevka Nerd Font:size=12.5:antialias=true:autohint=false" };
static char normbgcolor[]           = "#1E1E2E";
static char normbordercolor[]       = "#1E1E2E";
static char normfgcolor[]           = "#D9E0EE";
static char selfgcolor[]            = "#1E1E2E";
static char selbordercolor[]        = "#D9E0EE";
static char selbgcolor[]            = "#D9E0EE";
static char *colors[][3] = {
       /*               fg           bg           border   */
       [SchemeNorm] = { normfgcolor, normbgcolor, normbordercolor },
       [SchemeSel]  = { selfgcolor,  selbgcolor,  selbordercolor  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      		instance    title       tags mask     isfloating   monitor */
	{ "Deadbeef",     	NULL,       NULL,       0,            1,           -1 },
	{ "Gcolor3",     	NULL,       NULL,       0,            1,           -1 },
	{ "Pavucontrol", 	NULL,       NULL,       0,            1,           -1 },
	{ "Sxiv", 	 	NULL,       NULL,       0,            0,           -1 },
	{ "Pcmanfm", 	 	NULL,       NULL,       0,            1,           -1 },
	{ "Zathura", 	 	NULL,       NULL,       0,            0,           -1 },
	{ "blueman-manager",  	NULL,       NULL,       0,            1,           -1 },
	{ "cpomosai", 		NULL,       NULL,       0,            1,           -1 },
	{ "nnn", 		NULL,       NULL,       0,            1,           -1 },
	{ "packagesupgrade", 	NULL,       NULL,       0,            1,           -1 },
	{ "weatherreport", 	NULL,       NULL,       0,            0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.5;  /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
/* symbol     arrange function */
{ "[T]",      tile },			/* 0 first entry is default */
{ "[M]",      monocle },		/* 1 */
{ "[S]",      spiral },			/* 2 */
{ "[DW]",     dwindle },		/* 3 */
{ "[D]",      deck },			/* 4 */
{ "[BS]",     bstack },			/* 5 */
{ "[BSH]",    bstackhoriz },		/* 6 */
{ "[G]",      grid },			/* 7 */
{ "[RG]",     nrowgrid },		/* 8 */
{ "[HG]",     horizgrid },		/* 9 */
{ "[GG]",     gaplessgrid },		/* 10 */
{ "[C]",      centeredmaster },		/* 11 */
{ "[CF]",     centeredfloatingmaster },	/* 12 */
{ "[F]",      NULL },			/* 13 no layout function means floating behavior */
{ NULL,       NULL },			/* 14 */
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[] = { "dmenu_run", NULL };
/*static const char *flavorsel[] = { "flavorsel", NULL };*/
static const char *emojicmd[] = { "emojimenu", NULL };
static const char *chrscmd[] = { "chrs", NULL };
static const char *termcmd[] = { "st", NULL };
static const char *layoutmenu_cmd = "layoutmenu.sh";
static const char *webcmd[] = { "chromium", NULL };
static const char *filescmd[] = { "pcmanfm", NULL };
static const char *nnncmd[] = { "nnnfloat", NULL };
static const char *powermenu[] = { "powermenu", NULL };
static const char *shotmenu[] = { "shotmenu", NULL };
static const char *sysinfo[] = { "sysinfo", NULL };
static const char *walle[] = { "walle", NULL };
static const char *dispset[] = { "dispset", NULL };
static const char *dispfix[] = { "dispfix", NULL };
static const char *audiocontrolcmd[] = { "pavucontrol", NULL };

#include <X11/XF86keysym.h>
static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_d,      spawn,          {.v = dmenucmd } },
	{ MODKEY,             		XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,             		XK_w, 	   spawn,          {.v = webcmd } },
	{ MODKEY,             		XK_e, 	   spawn,          {.v = emojicmd } },
	{ MODKEY|ShiftMask,           	XK_f, 	   spawn,          {.v = nnncmd } },
	{ MODKEY|ControlMask,          	XK_f, 	   spawn,          {.v = filescmd } },
	{ MODKEY|ShiftMask,           	XK_m, 	   spawn,          {.v = audiocontrolcmd } },
	{ MODKEY,             		XK_0, 	   spawn,          {.v = powermenu } },
	{ MODKEY|ShiftMask,             XK_w, 	   spawn,          {.v = walle } },
	{ MODKEY|Mod1Mask,              XK_w, 	   spawn,          {.v = chrscmd } },
	{ MODKEY|ShiftMask,             XK_d, 	   spawn,          {.v = dispset } },
	{ MODKEY|Mod1Mask,              XK_d, 	   spawn,          {.v = dispfix } },
	{ MODKEY,			XK_F2,	   spawn,	   SHCMD("groff -mom $HOME/.local/share/dwm/gzdots.mom -T pdf | zathura -") },
	{ MODKEY|ShiftMask,		XK_t,	   spawn,	   SHCMD(TERMINAL " -c cpomosai -e cpomosai") },
	{ MODKEY,             		XK_b, 	   spawn,          {.v = sysinfo } },
	{ MODKEY|ShiftMask,             XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY|ControlMask,           XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY|ControlMask,           XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
	{ MODKEY,			XK_y,	   incrgaps,	   {.i = +3 } },
	{ MODKEY,			XK_x,	   incrgaps,	   {.i = -3 } },
	{ MODKEY,	                XK_a,      togglegaps,     {0} },
	{ MODKEY|ShiftMask,    		XK_a,      defaultgaps,    {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,                       XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_s,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_c,      setlayout,      {.v = &layouts[11]} },
	{ MODKEY,                       XK_space,  setlayout,      {.v = &layouts[13]} },
	{ MODKEY|ControlMask,		XK_comma,  cyclelayout,    {.i = -1 } },
	{ MODKEY|ControlMask,           XK_period, cyclelayout,    {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,             		XK_f,      togglefullscr,  {0} },
	{ MODKEY,             		XK_s,		togglesticky,  {0} },
	{ MODKEY|ControlMask,           XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_Left,   focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_Right,  focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_Left,   tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_Right,  tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_F1,     xrdb,           {.v = NULL } },
	/*{ MODKEY|Mod2Mask,              XK_f, 	   spawn,          {.v = flavorsel } },*/
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ 0,			        XK_Print,  spawn,          SHCMD("scrot ~/pic/allmon-$(date +%H:%M:%S).png --quality 100 --freeze") },
	{ MODKEY,			XK_Print,  spawn,          {.v = shotmenu } },
        { 0, XF86XK_AudioMute,			   spawn,	   SHCMD("pamixer -t") },
	{ 0, XF86XK_AudioLowerVolume,		   spawn,	   SHCMD("pamixer --allow-boost -d 5") },
	{ 0, XF86XK_AudioRaiseVolume,		   spawn,	   SHCMD("pamixer --allow-boost -i 5") },
	{ MODKEY,			XK_F10,	   spawn,	   SHCMD("mpc volume 0") },
	{ MODKEY,			XK_F11,	   spawn,	   SHCMD("mpc volume -5") },
	{ MODKEY,			XK_F12,	   spawn,	   SHCMD("mpc volume +5") },
	{ MODKEY|ShiftMask,             XK_l,      spawn,          SHCMD("lofi") },
	{ 0, XF86XK_AudioPrev,			   spawn,	   SHCMD("mpc prev && disccover") },
	{ 0, XF86XK_AudioNext,			   spawn,	   SHCMD("mpc next && disccover") },
	{ 0, XF86XK_AudioPlay,			   spawn,	   SHCMD("mpc toggle && disccover") },
	{ 0, XF86XK_AudioStop,			   spawn,	   SHCMD("mpc stop && disccover") },
	{ MODKEY,			XK_F5,	   spawn,	   SHCMD(TERMINAL " -e ncmpcpp") },
	{ 0, XF86XK_Calculator,			   spawn,	   SHCMD(TERMINAL " -e bc -l") },
	{ 0, XF86XK_MonBrightnessUp,		   spawn,	   SHCMD("xbacklight -inc 15") },
	{ 0, XF86XK_MonBrightnessDown,		   spawn,	   SHCMD("xbacklight -dec 15") },
	{ MODKEY|ShiftMask,             XK_c,      quit,           {0} },

	/* { MODKEY|Mod4Mask,              XK_h,      incrgaps,       {.i = +1 } }, */
	/* { MODKEY|Mod4Mask,              XK_l,      incrgaps,       {.i = -1 } }, */
	/* { MODKEY|Mod4Mask|ShiftMask,    XK_h,      incrogaps,      {.i = +1 } }, */
	/* { MODKEY|Mod4Mask|ShiftMask,    XK_l,      incrogaps,      {.i = -1 } }, */
	/* { MODKEY|Mod4Mask|ControlMask,  XK_h,      incrigaps,      {.i = +1 } }, */
	/* { MODKEY|Mod4Mask|ControlMask,  XK_l,      incrigaps,      {.i = -1 } }, */
	/* { MODKEY|Mod4Mask|ShiftMask,    XK_0,      defaultgaps,    {0} }, */
	/* { MODKEY,                       XK_y,      incrihgaps,     {.i = +1 } }, */
	/* { MODKEY,                       XK_o,      incrihgaps,     {.i = -1 } }, */
	/* { MODKEY|ControlMask,           XK_y,      incrivgaps,     {.i = +1 } }, */
	/* { MODKEY|ControlMask,           XK_o,      incrivgaps,     {.i = -1 } }, */
	/* { MODKEY|Mod4Mask,              XK_y,      incrohgaps,     {.i = +1 } }, */
	/* { MODKEY|Mod4Mask,              XK_o,      incrohgaps,     {.i = -1 } }, */
	/* { MODKEY|ShiftMask,             XK_y,      incrovgaps,     {.i = +1 } }, */
	/* { MODKEY|ShiftMask,             XK_o,      incrovgaps,     {.i = -1 } }, */
};


/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        layoutmenu,     {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
