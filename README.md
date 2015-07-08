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
