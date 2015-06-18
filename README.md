# mailtojekyll

## Motivation

`mailtojekyll` was written in order to allow clients to post to `jekyll` blogs via email, rather than manually creating markdown files, running `jekyll`, and uploading the generated static files themselves.

## What it does

`mailtojekyll` connects to a dedicated email account using POP3, downloads all the emails, processes them into markdown, saves the attachments, and replaces image references with markdown-safe image links.

## How it works


## How to use it

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
1. Set up a dedicated gmail account only for this purpose
2. `TODO: CONFIG THIS`
3. Clone `mailtojekyll` to your server
4. `cd mailtojekyll` - this should create a new gemset if you're using `rvm`
5. 

### Deployment

## Contributors

 * Manager:
 * Owner:
 * Consulted:
 * Helper:
 * Approver:
(Manager, Owner, Consulted, Helper, Approver)

## ATTRIBUTION

mailtojekyll is based heavily on the concepts of [JekyllMail](https://github.com/masukomi/JekyllMail), and is essentially a ground-up refactor of that existing app.  It has been gemified for ease of use, and updated to work with the most recent versions of `mail`, `nokogiri`, `reverse_markdown`, and `rinku`
