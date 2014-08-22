Hubble Gateway Blog
===================

This is the source code for the official blog of Hubble, the first trusted U.S.
gateway for the stellar network. You can find us online at
[hubblegateway.com](http://www.hubblegateway.com).

You can learn more about stellar on [stellar.org](http://stellar.org).

Installation
------------


First install external dependencies

```
brew install libxml2 libxslt
brew link libxml2 libxslt
```

Also requires ruby, rubygems, and bundler. If you don't have these, install them
before continuing.

Install needed gems with:
```
bundle install
```

Make sure everything works with:
```
rake preview
```

If there were no errors, it worked! (Warnings are okay)
You can visit the site at http://localhost:4000


Creating New Posts
------------------

Create a skeleton for the post by running:
```
rake new_post["the name of your post"]
```
(The actual title displayed on the blog will automatically be title-cased)

Octopress will automatically add a special section to the top of the blog post,
called yaml frontmatter, which contains some metadata about the post. You should
add the following yaml frontmatter to the top of the blog post:

| Name         | Meaning                                                                                                                      |
|--------------|------------------------------------------------------------------------------------------------------------------------------|
| author       | The first and last name of the author (a.k.a. you!)                                                                          |
| author_email | Your email address. Don't worry, it won't actually be displayed on the page, but is used for getting a nifty gravatar image. |
| header_image | (optional) The url for the header image for the post, starting at public. You should put the actual image in source/images.   |

Here's an example of the entire frontmatter section (including auto-generated info):

```
layout: post
title: "example blog post"
date: 2014-08-21 20:03:43 -0400
comments: true
categories: 
author: "Alex Browne"
author_email: "stephenalexbrowne@gmail.com"
header_image: /blog/images/blogpost5.png
```

NOTE: You will need to prefix the path to your header_image with `/blog/images`.
the header_image url can also be non-local, but this is not recommended, since
we would be relying on a 3rd party to keep the image up.