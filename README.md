# DITA Bootstrap

A plug-in for [DITA Open Toolkit][1] that extends the default HTML5 output with a basic [Bootstrap][2] template.

<!-- MarkdownTOC levels="2,3" -->

- [Installing](#installing)
- [Using](#using)
- [Customizing](#customizing)
  - [Bootswatch themes](#bootswatch-themes)
  - [Custom CSS](#custom-css)
  - [Headers and footers](#headers-and-footers)
  - [Navigation menu](#navigation-menu)
  - [Common Bootstrap utility classes](#common-bootstrap-utility-classes)
  - [Bootstrap icons for DITA notes](#bootstrap-icons-for-dita-notes)
  - [Optional elements](#optional-elements)
- [Feedback](#feedback)
- [License](#license)

<!-- /MarkdownTOC -->

![Sample DITA Bootstrap output](images/default-bootstrap.png)

## Installing

Use the `dita` command to add this plug-in to your DITA Open Toolkit installation:

DITA-OT 3.5 and newer:

```console
dita install fox.jason.extend.css
dita install org.dita-bootstrap.html
```

DITA-OT 3.3 and newer:

```console
dita --install fox.jason.extend.css
dita --install org.dita-bootstrap.html
```

DITA-OT 3.2 and older:

```console
dita --install \
       https://github.com/jason-fox/fox.jason.extend.css/archive/master.zip
dita --install \
       https://github.com/dita-bootstrap/dita-bootstrap.html/archive/master.zip
```

## Using

Specify the `html5-bootstrap` format when building output with the `dita` command:

```console
dita --input=path/to/your.ditamap \
     --format=html5-bootstrap
```

## Customizing

### Bootswatch themes

Alternate Bootstrap themes can be downloaded directly from [Bootswatch][3].

To override the default appearance with a Bootswatch theme, pass a theme name to the `dita` command via the `--bootstrap.theme` parameter:

```console
dita --input=path/to/your.ditamap \
     --format=html5-bootstrap \
     --args.hdr=path/to/your-header.xml \
     --bootstrap.theme=<theme-name>
```

### Custom CSS

To extend the chosen theme, pass a custom CSS file to the `dita` command via the `--args.css` parameter.

For a complete override of the theme where the default Bootstrap CSS is no longer required, you can disable it by setting `--bootstrap.theme=none`:

```console
dita --input=path/to/your.ditamap \
     --format=html5-bootstrap \
     --args.hdr=path/to/your-header.xml \
     --bootstrap.theme=none \
     --args.css=<name-of-css>.css \
     --args.copycss=yes \
     --args.csspath=css \
     --args.cssroot=path/to/your/theme
```

> **Note**
> For more extensive customizations with [Sass][4], you may want to install the [dita-bootstrap.sass][5] plug-in.

### Headers and footers

The plug-in includes a default static navigation menu with a project name and global link placeholders.

The default header file `includes/hdr.navbar.default.xml` uses the Bootstrap primary (blue) background color for the [navbar component][6]. Bootstrap itself offers additional [header examples][7].

To change the color to a dark (black) background, replace the primary background color class `bg-primary` on the first line with the dark variant `bg-dark`:

```diff
- <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
+ <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
```

You can edit a copy of this file to adjust the content of the global navigation. To override the global navigation with your own header, pass a custom header file to the `dita` command via the `--args.hdr` parameter:

```console
dita --input=path/to/your.ditamap \
     --format=html5-bootstrap \
     --args.hdr=path/to/your-header.xml
```

The plug-in includes a sample [header alternative with a light navbar][8].

No footer is added by default, but the plug-in also includes a sample [footer file][9] and Bootstrap also offers additional [examples][10]. To add a footer to the generated output, pass a custom footer file to the `dita` command via the `--args.ftr` parameter:

```console
dita --input=path/to/your.ditamap \
     --format=html5-bootstrap \
     --args.ftr=path/to/your-footer.xml
```

### Navigation menu

The plug-in extends the standard HTML5 table of contents (ToC) [navigation parameter][11] `--nav-toc` to add styled list groups to the navigation menu. (The navigation is rendered as a sidebar in desktop browsers and above the content on smaller devices.)

By default, the plug-in uses the `partial` option to include the current topic in the ToC along with its parents, siblings and children. As with the default HTML5 plug-in, the `full` option can also be used to generate a complete ToC for the entire map, or `none` to disable the table of contents entirely.

As of version 5.3.1, the plug-in provides five new options to style the table of contents navigation with either the Bootstrap [list group][12] component, [nav-pills][13], or [collapsible][14] menus:

- `list-group-full` – Styled full ToC within a Bootstrap list group
- `list-group-partial` – Partial ToC with the current topic, parents, siblings, and children in a list group
- `nav-pill-full` – Styled full ToC using Bootstrap nav-pills
- `nav-pill-partial` – Partial ToC with the current topic, parents, siblings, and children using Bootstrap nav-pills
- `collapsible` – Styled full ToC with collapsible list elements

To use these options, pass the desired value to the `dita` command via the `--nav-toc` parameter:

```console
dita --input=path/to/your.ditamap \
     --format=html5-bootstrap \
     --nav-toc=list-group-partial
```

For an example of `collapsible` styling, see the output at [dita-bootstrap.org][15].

Additionally, the first-level navigation menu can be switched to a horizontal Bootstrap menu bar to reduce the depth of the ToC.

To use this option, add the `--menubar-toc.include=yes` parameter to the `dita` command:

```console
dita --input=path/to/your.ditamap \
     --format=html5-bootstrap \
     --nav-toc=list-group-partial  \
     --menubar-toc.include=yes
```

### Common Bootstrap utility classes

The HTML output for the following DITA elements can be annotated with common Bootstrap utility classes for borders, background, text, spacing, etc. using additional command line parameters:

- `bootstrap.css.accessibility.link` – Common Bootstrap utility classes for accessibility links
- `bootstrap.css.accessibility.nav` – Common Bootstrap utility classes for accessibility navigation
- `bootstrap.css.accordion` – Common utility classes for Bootstrap accordion components
- `bootstrap.css.card` – Common utility classes for Bootstrap card components
- `bootstrap.css.carousel` – Common utility classes for Bootstrap carousel components
- `bootstrap.css.carousel.caption` – Common utility classes for Bootstrap carousel captions
- `bootstrap.css.carousel.indicators` – Common utility classes for Bootstrap carousel indicators
- `bootstrap.css.codeblock` – Common Bootstrap utility classes for DITA `<codeblock>` elements
- `bootstrap.css.container.size` – Bootstrap container class for main layout and menubar-TOC. Options: `container`, `container-fluid`, `container-sm`, `container-md`, `container-lg`, `container-xl`, `container-xxl` (default)
- `bootstrap.css.dd` – Common utility classes for DITA `<dd>` elements
- `bootstrap.css.dl` – Common utility classes for DITA `<dl>` elements
- `bootstrap.css.dt` – Common utility classes for DITA `<dt>` elements
- `bootstrap.css.figure` – Common utility classes for DITA `<fig>` elements
- `bootstrap.css.figure.caption` – Common utility classes for DITA figure titles
- `bootstrap.css.figure.image` – Common utility classes for images within DITA`<fig>` elements
- `bootstrap.css.footer` – Common utility classes for the HTML `<footer>` element
- `bootstrap.css.nav.parent` – Common utility classes for ancestors of active nav-pill elements
- `bootstrap.css.pagination` – Common utility classes for Bootstrap pagination components
- `bootstrap.css.section.title` – Common Bootstrap utility classes for DITA `<section>` titles
- `bootstrap.css.shortdesc` – Common Bootstrap utility classes for DITA`<shortdesc>` elements
- `bootstrap.css.table` – Common utility classes for DITA `<table>` elements
- `bootstrap.css.tabs` – Common utility classes for Bootstrap horizontal tab components
- `bootstrap.css.tabs.vertical` – Common utility classes for Bootstrap vertical tabs
- `bootstrap.css.thead` – Common utility classes for DITA `<thead>` elements
- `bootstrap.css.topic.title` – Common Bootstrap utility classes for DITA `<topic>` titles

You can add your own XSLT customizations by creating a new plug-in that extends the DITA Bootstrap XSLT transforms. Just amend `args.xsl` to point to your own XSLT files. An [XSLT template][16] is included within this repository.

### Bootstrap icons for DITA notes

The default Bootstrap icons used for DITA `<note>` elements can be overridden using additional command line parameters:

- `bootstrap.icon.note` – Icon for standard notes
- `bootstrap.icon.attention` – Icon for attention notes
- `bootstrap.icon.caution` – Icon for caution notes
- `bootstrap.icon.danger` – Icon for danger notes
- `bootstrap.icon.fastpath` – Icon for fastpath notes
- `bootstrap.icon.important` – Icon for important notes
- `bootstrap.icon.notice` – Icon for notice notes
- `bootstrap.icon.remember` – Icon for remember notes
- `bootstrap.icon.restriction` – Icon for restriction notes
- `bootstrap.icon.tip` – Icon for tips
- `bootstrap.icon.trouble` – Icon for trouble notes
- `bootstrap.icon.warning` – Icon for warning notes

### Optional elements

Bootstrap icons, popovers, tooltips and the dark-mode toggler are enabled by default, but for performance reasons they can be disabled by setting the following command line parameters to `no`:

- `icons.include` – Enable Bootstrap icons
- `popovers.include` – Enable Bootstrap popover components and tooltip components
- `dark.mode.include` – Whether to include support for a [dark mode][14] toggler

Additionally, opt-in breadcrumbs and menu bars and other modifiers can be added using the following parameters

- `args.breadcrumbs` – Add Bootstrap breadcrumb components
- `menubar-toc.include` – Add a Bootstrap menubar
- `scrollspy-toc` – Add a Bootstrap [scrollspy][17] navigator
- `bidi.include` – Whether to force included support for RTL languages
- `toc-spacer.padding` – Vertical padding to add to the side menu

## Feedback

- If you find this useful and build something of your own on top of it, [let me know][18].

- If you find a bug or would like to suggest a change, [create an issue][19].
  _(If it’s a bug, provide steps to recreate the issue.)_

- If you know how to fix it yourself, [submit a pull request][20] with the proposed changes.

## License

[Apache 2.0](LICENSE) © 2017–2026 Roger W. Fienhold Sheen

The generated HTML created by this software includes the following additional software components which are obtained under license:

- Bootstrap – https://github.com/twbs/bootstrap – **MIT license**
- Bootstrap Icons – https://github.com/twbs/icons – **MIT license**
- Bootswatch Themes – https://github.com/thomaspark/bootswatch – **MIT license**

> [!NOTE]
> Within the sample documentation, where necessary, the texts describing the usage of each component have been copied
> directly from the official [Bootstrap 5.3 documentation][2], however DITA markup is used throughout the examples describing
> how to implement these components correctly using `outputclass`. The text is therefore a derivative of "Bootstrap 5.3 docs"
> by Twitter, Inc. and the Bootstrap Authors, and used under CC BY 3.0.

[1]: http://www.dita-ot.org
[2]: https://getbootstrap.com/docs/5.3
[3]: https://bootswatch.com
[4]: https://sass-lang.com
[5]: https://github.com/dita-bootstrap/dita-bootstrap.sass
[6]: https://getbootstrap.com/docs/5.3/examples/navbars/
[7]: https://getbootstrap.com/docs/5.3/examples/headers/
[8]: ./includes/hdr.navbar.example.xml
[9]: ./includes/ftr.content.example.xml
[10]: https://getbootstrap.com/docs/5.3/examples/footers/
[11]: https://www.dita-ot.org/dev/parameters/parameters-html5.html#html5__nav-toc
[12]: https://getbootstrap.com/docs/5.3/components/list-group/
[13]: https://getbootstrap.com/docs/5.3/components/collapse/
[14]: https://getbootstrap.com/docs/5.3/customize/color-modes/#dark-mode
[15]: https://dita-bootstrap.org
[16]: ./xsl/html5-bootstrap-template.xsl
[17]: https://getbootstrap.com/docs/5.3/components/scrollspy/
[18]: https://indieweb.social/@infotexture
[19]: https://github.com/dita-bootstrap/dita-bootstrap.html/issues/new
[20]: https://help.github.com/articles/using-pull-requests/
