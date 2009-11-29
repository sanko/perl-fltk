---
layout:     post
title:      FLTK::AlignGroup
abstract:   Align layout manager
permalink:  /docs/FLTK-AlignGroup
categories: [documentation, page]
---
The [AlignGroup](/docs/FLTK-AlignGroup) <!--[Page: FLTK::AlignGroup | Section:  | Ident:  | LinkText: AlignGroup]--> overrides all group's children's label alignments to it's own [`align()`](/docs/FLTK-Group#align) <!--[Page: FLTK::Group | Section:  | Ident: align | LinkText: `align()`]--> value, tiles and [`resize()`](/docs/FLTK-Group#resize) <!--[Page: FLTK::Group | Section:  | Ident: resize | LinkText: `resize()`]-->s the children to fit in the space not required by the (outsize) labels.

## Constructor

Creates a new `FLTK::AlignGroup` object. This constructor expects integers for `$x, $y, $w, $h` and accepts an optional string for `$label`. Other optional arguments include:

* `$n_to_break`

  Default value is an empty string.

* `$vertical`

  A boolean who's default value is a true value.

* `$align`

  [FLTK::Flags](/docs/FLTK-Flags) <!--[Page: FLTK::Flags | Section:  | Ident:  | LinkText: FLTK::Flags]--> value which defaults to [FLTK::ALIGN_LEFT](/docs/FLTK-Flags#FLTK::ALIGN_LEFT) <!--[Page: FLTK::Flags | Section:  | Ident: FLTK::ALIGN_LEFT | LinkText: FLTK::ALIGN_LEFT]-->

* `$dw`

* `$dh`

### Usage

{%highlight perl%}

my $group_1 = FLTK::AlignGroup->new( $x, $y, $w, $h, $label );
my $group_2 = FLTK::AlignGroup->new( 40, 40, 150, 40);

{%endhighlight%}

## Methods

### `$group_1->layout( )`

### `$v = $group_1->vertical( )`

### `$group_1->vertical( $value )`

### `my $n = $group_1->n_to_break( )`

### `$group_1->n_to_break( $value )`
