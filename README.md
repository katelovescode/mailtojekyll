# mailtojekyll

## Motivation

`mailtojekyll` was written in order to allow clients to post to `jekyll` blogs via email, rather than manually creating markdown files, running `jekyll`, and uploading the generated static files themselves.

## What it does

`mailtojekyll` connects to a dedicated email account using POP3, downloads all the emails, processes them into markdown, saves the attachments, and replaces image references with markdown-safe image links.

## How it works



## How to use it

Users email a post to their dedicated email account for their `jekyll` blog.  Most formatting will be stripped out.  If the user wants to include images in the post, they should use the following syntax:

```
#image-filename.png#
```

`mailtojekyll` will replace that tag with the correct markdown image tag, including a reference to the relative image path so `jekyll` processes it correctly

### External Dependencies

## Reference implementation

### Managing services

#### [OS]

#### [Web Server]

#### [Logging]

### Production Implementation

#### Where is this thing?

## For developers

Best practices  
1. Set up a dedicated email account only for this purpose
2. Clone `mailtojekyll` to your server
3. `cd mailtojekyll` - this should create a new gemset if you're using `rvm`
4. 

### Deployment

## Contributors

 * **M**anager: Ian Reynolds
 * **O**wner:
 * **C**onsulted:
 * **H**elper:
 * **A**pprover:

## ATTRIBUTION

mailtojekyll is based heavily on the concepts of [JekyllMail](https://github.com/masukomi/JekyllMail), and is essentially a ground-up refactor of that existing app.  It has been gemified for ease of use, and updated to work with the most recent versions of `mail`, `nokogiri`, `reverse_markdown`, and `rinku`

I developed this as a standalone because development on JekyllMail is 4 years old, so I wanted to make sure it was available as an app/gem
