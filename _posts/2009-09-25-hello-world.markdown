---
layout:     post
title:      Hello, World!
categories: [tutorial, basic]
header:     /~images/posts/HelloWorld.png
blurb:      Ah, the classics...
---
Here is a very brief example program based on the
"[Basic FLTK Program](http://fltk.org/doc-2.0/html/example1.html)" found in
the fltk2 docs:
{%highlight perl linenos%}
use strict;
use warnings;
use FLTK;

my $window = FLTK::Window->new(300, 180);
$window->begin();
my $box = FLTK::Widget->new(20, 40, 260, 100, "Hello, World!");
$box->box(UP_BOX);
$box->labelfont(HELVETICA_BOLD_ITALIC);
$box->labelsize(36);
$box->labeltype(SHADOW_LABEL);
$window->end();
$window->show();
exit run();
{%endhighlight%}

When run, the program will display the window below. You can quit the program
by closing the window or pressing the ESCape key.

<image class="center noborder" src="/~images/posts/HelloWorld.png" />

## Using FLTK

The basic way to use FLTK is simply:

{%highlight perl%}use FLTK;{%endhighlight%}

This sample program uses Window and Widget. Being class-based, the objects are
created using typical OO syntax.

Additionally, several non-class functions and symbols may be imported directly
or with their related tag. As a rule, I only export functions a user requests,
but FLTK has a very small group of default exports. This <code>:default</code>
tag includes <code>run( )</code> as it will be used by most programs.

## Creating the Widgets

To get things started, the program creates a window:

{%highlight perl%}my $window = FLTK::Window->new(300,180);{%endhighlight%}

It then calls "begin" on it, which indicates that all widgets constructed
after this should be "children" of this window:

{%highlight perl%}$window->begin();{%endhighlight%}

It then creates a box with the "Hello, World!" string in it, this new widget
is made a "child" of the window we just created:

{%highlight perl%}
my $box = FLTK::Widget->new(20, 40, 260, 100, "Hello, World!");
{%endhighlight%}

For most widgets the arguments to the constructor are:

{%highlight perl%}
FLTK::Widget->new( x, y, width, height, label )
{%endhighlight%}

* x and y are the location of the upper-left corner of
  the widget, measured in pixels. For windows this is measured from the
  upper-left corner of the screen, for widgets it is measured from the
  upper-left corner of the window.
* width and height are the size of the widget.
* label is an optional pointer to a string.

  This string is not copied, FLTK assumes it resides in static storage. This
  is true of almost all interfaces in FLTK that take string constants, and
  greatly speeds up FLTK. (You can use <code>Widget::copy_label( )</code> if
  you want FLTK to manage the memory the label is in).

  Note that...
  * For widgets, label defaults to an empty string.
  * For windows, label defaults to the filename of the perl script.

## Get/Set Methods

Next we set several "attributes" of the box:
{%highlight perl%}
$box->box(UP_BOX);
$box->labelfont(HELVETICA_BOLD_ITALIC);
$box->labelsize(36);
$box->labeltype(SHADOW_LABEL);
{%endhighlight%}

First, we set the type of box the box widget draws, changing it from the
default of <code>DOWN_BOX</code> to <code>UP_BOX</code>, which means that a
raised button border will be drawn around the widget. There is a large
selection of built-in boxes and you can define your own by subclassing
FLTK::Symbol.

FLTK uses combined mutators for get/set methods so you can examine the boxtype
with <code>$box->box( )</code>.

In the underlying library, almost all of these mutators are very fast and
short inline functions and thus very efficient. However, "set" methods do not
call <code>redraw( )</code>, you have to call it yourself. This greatly
reduces code size and execution time. The only common exception is
<code>value( )</code>, this does <code>redraw( )</code> if necessary. But
we'll get into that in a future tutorial.

## Begin/End of Groups and Windows

Then we indicate we are done adding widgets to the window:

{%highlight perl%}$window->end();{%endhighlight%}

The method <code>Group::end( )</code> (FLTK::Window is a subclass of
FLTK::Group) restores the "current group" to the parent of itself, in this
case it is set to null because the window has no parent. You may also find it
useful to call <code>Group::current( 0 )</code> to turn this off completely.

## Showing the Window

Then we cause the window to appear on the screen:

{%highlight perl%}$window->show();{%endhighlight%}

On some systems the window does not actually appear until
<code>FLTK::run()</code> is called, which flushes the cached instructions to
the window server.

## The Main Event Loop

{%highlight perl%}exit run();{%endhighlight%}

This will repeatedly wait for and then process events from the user.
<code>FLTK::run()</code> does not return until all of the windows under FLTK
control are closed (either by the user or your program).

When the user attempts to close the window, the callback for the window is
called. If you don't change it, the callback will remove the window from the
screen.

You can replace this callback with your own code, so you can prevent the
window from closing, or pop up a confirmation, or create another window, or
you can call <code>exit;</code> if you want to exit when the user closes the
"main" window even if other windows are still open.

### Roll Your Own Event Loop

You don't <em>have</em> to give FLTK control over the main event loop. Instead
you can repeated call <code>FLTK::wait()</code>, which will pause until
"something happens" and then return. A program can call
<code>FLTK::wait()</code> repeatedly or mix it with other calculations. You
can do this if there are no windows displayed (useful if you used
<code>FLTK::add_fd()</code>). The <code>FLTK::run()</code> method is
equivalent to:

{%highlight perl%}
FLTK::wait() while (FLTK::Window::first());
return 0;
{%endhighlight%}
