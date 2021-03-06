---
title: List of helpful Blogdown & Hugo tutorials
author: Martina Sladekova
date: '2021-05-07'
slug: list-of-useful-blogdown-hugo-tutorials
categories: []
tags: ["hugo", "blogdown"]
subtitle: ''
summary: "This post contains a collection of tutorials I've been using to put this website together, including the initial blogdown set-up, creating a floating table of content, setting up and customising syntax highlighting, and customising the fonts."
authors: []
lastmod: '2021-05-07'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
toc: TRUE
---

This post contains a collection of tutorials I've been using to put this website together. These were originally just notes where I've saved a few links because I kept closing my tabs and then spending ages trying to locate them again. It always takes me a good while to sift through tutorials to find the one that works for my set up and is written at a technical level that I can understand. So I decided to publish this as post in case it someone else finds it helpful. 

Credit where it's due, the people below deserve a shout-out for informing how this website was built, in one way or another: 

- [Alison Hill](https://alison.rbind.io) has written a wealth of tutorials about Blogdown. 
- [Amber Thomas](https://amber.rbind.io) has a great tutorial on implementing syntax highlighting with highlight.js
- [Chris Lockard](https://www.chrislockard.net) writes about cybersecurity, and I used their tutorial for customising fonts. 
- [Daniel Quintana](https://www.dsquintana.com) whose tutorial on building websites with Hugo was my starting point.
- [Eric Fong](http://ericfong.ca) has written a tutorial on how to build a floating table of content. 
- [Geoff Ruddock](https://geoffruddock.com) has written a post on how to get maths and equations working in the latest version of Hugo.
- [Jenny Terry](https://jennyterry.co.uk) has a really cool website and gave me the necessary nudge towards building my own.
- [Tom Spencer](https://www.tomspencer.dev) explains how to debug syntax highlighting if the problem is the Netlify Hugo version

</br>

## Initial Blogdown set up

I followed the tutorial below when setting up this website: 

- [https://alison.rbind.io/post/new-year-new-blogdown/](https://alison.rbind.io/post/new-year-new-blogdown/)

Alternative approach (using visual studio) is described here: 

- [https://www.dsquintana.blog/create-an-academic-website-free-easy-2020/](https://www.dsquintana.blog/create-an-academic-website-free-easy-2020/)

I followed Daniel Quintana's tutorial at the start, but I kept coming across issues with admin access when working with Hugo and Go (this is the fault of my set up, not the fault of the tutorial - the user account I use on my computer is not an admin account, so I kept having to switch accounts back and forth). It is entirely possible that the website set up is functional because of some steps I completed in the tutorial above before moving on to Alison's tutorial, so it's worth revisiting if things suddenly break. 

</br>

## Floating table of content

The Academic theme has a default table of content functionality which can be toggled by setting `toc: true` in the `yaml` header of a post, but this table appears at the top of the post. The tutorial below explains specifically how to make a floating table of content work with the Academic theme. 

- [http://ericfong.ca/post/floatingtoc/#solution](http://ericfong.ca/post/floatingtoc/#solution)

Note that the table of content doesn't appear on phones (or any narrow screens). The headers in the table of content on this page highlight dynamically as you scroll through the page. I genuinely don't know if this was a random bug, but it wasn't working at the beginning, then I spent half a day googling and unsuccessfully looping over the same tutorials, and then it started working without me making any changes. Go figure. 

</br>

## Syntax highlighting:

Hugo version **0.82.0** uses `chroma` highlighting by default. This is set in `config.yaml`, but there seems to be a clash with the Academic theme where only some parts of the code get highlighted, and only some `chroma` themes will work. 

A lot of tutorials point to `pygments` which need Python to run. I wasn't able to get `pygments` into a functional state, because frankly, I know very little about Python, and while the `pip` command amuses me (I don't know why), I'm still determined to keep avoiding Python for at least another couple of months.[^1]

`highlight.js` worked, after a small amount of swearing. This tutorial is very detailed and contains helpful troubleshooting: 

- [https://amber.rbind.io/2017/11/15/syntaxhighlighting/](https://amber.rbind.io/2017/11/15/syntaxhighlighting/) 

There's a small typo to look out for which probably wouldn't befuddle anyone apart from me: 

> One of these should be highlight.js. Copy only this file to the js folder for your theme (it should be located in themes/name-of-your-theme/static/js).

The file is actually called `highlight.pack.js`. Instead of the more logical approach of copying the most likely file and moving on with the tutorial, I copied it and renamed it to `highlight.js`, which then broke the follow-up code. Don't do that, just copy the file as is. 

Regarding the snippet of code provided in Amber's tutorial: 


```js
<link rel="stylesheet" href="{{"css/github-gist.css" | absURL}}" rel="stylesheet" id="theme-stylesheet">
<script src="{{ "js/highlight.pack.js" | absURL }}"></script>
<script>hljs.initHighlightingOnLoad();</script>
```

for Hugo **0.82.0**, this needs to go into `layouts/partials/page_header.html`. It needs to be inserted **before** the line with the last `{end}`. Obviously. This is an obvious thing that one should not spend two hours trying to figure out while repeatedly breaking one's website. 

Additional tutorial for syntax highlighting which also signposts to Amber Thomas's approach and seems to contain minor code updates:  

- [https://www.r-bloggers.com/2019/07/adding-syntax-highlight/](https://www.r-bloggers.com/2019/07/adding-syntax-highlight/) 

One thing worth pointing out is that both of these tutorials advise editing and overwriting files in the `website_name/themes/...` directory. All Hugo and Academic tutorials recommend against this as it's too easy to mess things up to a point of no return. A safer approach when overwriting any default settings is to locate the relevant **.html** or **.css** file in the directory of the theme, then copy it into a folder in the root directory. For example, for the `page_header.html`, I copied a file located here: 

```
website_name/themes/github.com/wowchemy/wowchemy-hugo-modules/wowchemy/layouts/partials/page_header.html
```

into this directory:

```
website_name/layouts/partials/page_header.html
```

**If the syntax is highlighting on a local preview but not after deployment** there might be a problem either with the Hugo version that Netlify uses to build the website (likely if you build your website a while back). This tutorial explains how to set the Hugo version: 

- [https://www.tomspencer.dev/blog/2018/08/03/deploying-a-hugo-powered-site-to-netlify-with-source-code-syntax-highlighting/](https://www.tomspencer.dev/blog/2018/08/03/deploying-a-hugo-powered-site-to-netlify-with-source-code-syntax-highlighting/)

It turns out that my issue was with the file path to `highlight.pack.js` and the corresponding css file. After following Amber Thomas's tutorial, the code snippet I added was the one below: 


```js
<link rel="stylesheet" href="{{"css/mono-blue-modified.css" | absURL}}" id="theme-stylesheet">
<script src="{{ "js/highlight.pack.js" | absURL }}"></script>
<script>hljs.initHighlightingOnLoad();</script>
```

but it was missing a "/" in the file path to the css file and the js file. So the two paths should have been `/css/mono-blue-modified.css` and `/js/highlight.pack.js`: 


```js
<link rel="stylesheet" href="{{"/css/mono-blue-modified.css" | absURL}}" id="theme-stylesheet">
<script src="{{ "/js/highlight.pack.js" | absURL }}"></script>
<script>hljs.initHighlightingOnLoad();</script>
```

This might be a quirk of the Academic theme, or it might be the result of copying into `partials` instead of directly editing the original theme files. More discussion and possible solutions here: 

- [https://stackoverflow.com/questions/40728554/resource-blocked-due-to-mime-type-mismatch-x-content-type-options-nosniff/41319855](https://stackoverflow.com/questions/40728554/resource-blocked-due-to-mime-type-mismatch-x-content-type-options-nosniff/41319855)

Moving on before this turns into a Hugo tutorial which I'm highly unqualified to write. 

View different `highlight.js` theme here: 

- [https://highlightjs.org/static/demo/](https://highlightjs.org/static/demo/)

and `chroma` themes here: 

- [https://xyproto.github.io/splash/docs/all.html](https://xyproto.github.io/splash/docs/all.html) 

This page uses a mixed approach - `highlight.js` for basic code highlighting and `chroma` highlighting (set in `config.yaml`) for fences. `highlight.js` wasn't picking up the fences, and this worked surprisingly well.

Finally, the comments in the discussion post below contain pointers for highlighting in-text syntax in back-ticks: 

- [https://discourse.gohugo.io/t/distinguish-between-single-backtick-and-triple-backticks/18131](https://discourse.gohugo.io/t/distinguish-between-single-backtick-and-triple-backticks/18131)

In case the post gets deleted, as they sometimes do, this:


```css
code {
  /* will target single backtick */
}
```


<style type="text/css">
code {
  /* will target single backtick */
}
</style>

needs to be added into the **.css** for the theme from `highlight.js` with `color` and `background` attributes.

## Set custom fonts

The guidance on this provided by Hugo is fairly clear: 

- [https://wowchemy.com/docs/getting-started/customization/#custom-theme](https://wowchemy.com/docs/getting-started/customization/#custom-theme)

However, I wanted to use different Google fonts with specific configurations for the page and for the code snippets. This part of the code: 

`google_fonts = "family=Open+Sans:wght@300&display=swap"`

in the custom `my_theme.toml` file sets the font for the whole website and overwrites the unique font for code snippets. The tutorial below gets around the problem:

- [https://www.chrislockard.net/posts/using-local-fonts-hugo-academic-theme/](https://www.chrislockard.net/posts/using-local-fonts-hugo-academic-theme/)

Chris also makes a very good point of storing and reading the font files locally, instead of directly from Google fonts, to prevent Google from tracking users on your page.  

## Display equations

Section **Adapted for MathJax 3** in the post below has a fairly straightforward explanation on how to get equations working if you're knitting in markdown: 

- [https://geoffruddock.com/math-typesetting-in-hugo/](https://geoffruddock.com/math-typesetting-in-hugo/)

</br>


</br>

</br>

That's it for now - I aim to keep this post active and add more tutorials as I come across them. 


</br>

[^1]: At which point I'm bitterly expecting to hit a wall with my [NLP project](/project_info/proj_nlp) in R and will be begrudgingly forced to switch. 
