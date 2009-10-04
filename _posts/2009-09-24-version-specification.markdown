---
layout:     post
title:      FLTK.pm's Version Number
permalink:  /like-a-version
categories: [version, fltk.pm]
---
If you're thinking FLTK.pm's versioning scheme is a little convoluted, you're
right.

Historically, the FLTK perl module has been based on the experimental 2.0.x
branch and I have decided to continue working with the 2.0.x branch under the
FLTK namespace. The previous maintainer released a single distribution with
$VERSION set to 0.52 so, despite the project being only around 30% complete,
my version numbers will begin with 0.530.

## fltk 2.0.x vs. fltk 1.3.x vs. fltk ???

To clarify... and by 'clarify', I mean 'confuse further'...

* The current stable release of fltk is v1.1.10rc1.
* The 1.2.x branch was an early attempt to bring many of 2.0.x's features to
  1.1.x. The 1.2.x branch has since been abandoned.
* The 1.3.x branch is the current feature branch. It's the recommended branch
  for new development and the only branch under active development. It was
  <em>not</em> derived from the code in the 1.2.x branch but does include many
  of the features of 2.0.x including utf8 and new widgets.
* Branch 1.4.x is a reserved branch for future development based on 1.3.x.
* The 2.0.x branch was a rewrite to make the interfaces to each widget more
  consistent, to use C++ more correctly, including the ability (but not the
  requirement) to support function style callbacks, exceptions, and a
  namespace, and to support theming of the GUI without having to set the color
  of every widget.

  The 2.0.x branch predates both the 1.2.x and 1.3.x branches but is still
  considered experimental.
* A new 3.0.x branch will soon (according to chatter) unify the 1.3.x  and
  2.0.x branches, borrowing features from both, and reducing confusion for
  new users.

  The FLTK-Perl project will be following this branch as it develops. For more
  on the goals of the 3.0.x branch of fltk, see
  [Easy as 1, 2, 3](http://fltk.org/newsgroups.php?s20445+gfltk.general+v20449+T0)
  by Matthias Melcher.
