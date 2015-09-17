# mailtojekyll

TODO: Update rspec tests

## Motivation

`mailtojekyll` was written in order to allow clients to post to `jekyll` blogs via email, rather than manually creating markdown files, running `jekyll`, and uploading the generated static files themselves.

## What it does

Converts emailed blog posts into markdown and saves them inside a jekyll structure

## How it works

`mailtojekyll` connects to a dedicated email account using POP3; downloads all the emails; validates for content, secret word, and subject line; processes the emails into markdown; saves the attachments; and replaces image references with markdown-safe image links.

## How to use it

Users email a post to their dedicated email account for their `jekyll` blog.  

The subject must be in this format: `Post Title || secret: secretword`

The secret word must match the one set in `_config.yml`

Most formatting will be stripped out.  If the user wants to include images in the post, they should attach the images to the email and use the following syntax in the body of the email:

```
#image-filename.png#
```

This must match the exact file name of the attachment.

`mailtojekyll` will replace that tag with the correct markdown image tag, including a reference to the relative image path so `jekyll` processes it correctly

### External Dependencies
- `jekyll` [http://www.jekyllrb.com/](http://www.jekyllrb.com)
- `mail` gem
- `nokogiri` gem
- `reverse_markdown` gem
- `rinku` gem

## Reference implementation
One option:
- `jekyll` installed locally
- `mailtojekyll` installed locally as an executable gem
- cron job to run `mailtojekyll`
- cron job to build `jekyll` site
- cron job to transfer `_site/` directory to server (i.e. FTP or sync)
- cron job to update and push `git` branches

### Managing services

#### [OS]

Ubuntu/Linux

#### [Libraries/Apps]

- `ruby`
- `rvm`
- `git`

#### [Web Server]

Hosting (dedicated or shared)

### Production Implementation

#### Where is this thing?

**TODO: Update this with our production stack (AWS, etc.)**

## For developers

Best practices  
1. Set up a dedicated email account only for this purpose
2. Clone `mailtojekyll` to your local machine
3. 
```
cd mailtojekyll
```
(this should create a new gemset if you're using `rvm`)

4. `rake install` to install gem executable
5. Install jekyll and create a new blog: [http://jekyllrb.com/docs/quickstart/](http://jekyllrb.com/docs/quickstart/)
6. Send a few emails to your dedicated email account
7. ```
mailtojekyll -j /home/user/repo -s pop.example.com -u example@example.com -p x123456789x -S secretword -i imgdir -P postdir
```
8. View your repo to see the created files.

### CRON JOB SETUP

Add required `rvm` path variables to the top of your crontab file:
```
rvm cron setup
```
Set up cron job
```
crontab -e
```

##### CRON JOB W/ POP
```
* * * * * /home/user/.rvm/gems/ruby-2.2.0@mailtojekyll/bin/mailtojekyll -j /home/user/repo -s pop.example.com -u example@example.com -p x123456789x -S secretword -i imgdir -P postdir >> /tmp/cron_debug_log.log 2>&1
```

##### CRON JOB W/ TEST EMAILS
```
* * * * * /home/user/.rvm/gems/ruby-2.2.0@mailtojekyll/bin/mailtojekyll -t /path/to/emails -j /home/user/repo -S secretword -i imgdir -P postdir >> /tmp/cron_debug_log.log 2>&1
```

### Deployment

Run `mailtojekyll` on your own machine with cron, or on a server with cron to gather emails.  Manually build and upload your site, Deploy `jekyll` according to recommendations: [http://jekyllrb.com/docs/deployment-methods/](http://jekyllrb.com/docs/deployment-methods/)

## Contributors

 * **M**anager: Ian Reynolds
 * **O**wner: Kate Klemp
 * **C**onsulted: Sunil Chopra
 * **H**elper: Sunil Chopra
 * **A**pprover: Sunil Chopra

## ATTRIBUTION

mailtojekyll is based heavily on the concepts of [JekyllMail](https://github.com/masukomi/JekyllMail), and is essentially a ground-up refactor of that existing app.  It has been gemified for ease of use, and updated to work with the most recent versions of `mail`, `nokogiri`, `reverse_markdown`, and `rinku`

I developed this as a standalone because development on JekyllMail is 4 years old, so I wanted to make sure it was available as an app/gem
