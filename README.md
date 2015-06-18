# mailtojekyll

## Motivation

`mailtojekyll` was written in order to allow clients to post to `jekyll` blogs via email, rather than manually creating markdown files, running `jekyll`, and uploading the generated static files themselves.

## What it does

`mailtojekyll` searches a pop3 mail account, downloads all the emails, processes them into markdown, saves the attachments, and replaces image references with markdown-safe image links

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

### Deployment

## Contributors

 * M:
 * O:
 * C:
 * H:
 * A:
(Manager, Owner, Consulted, Helper, Approver)

Example (doesn’t track exactly, but close in intent):

# mdAPI (The Melissa Data API)

This application is written in Python using 
[The Pyramid Web Application Development Framework](http://docs.pylonsproject.org/projects/pyramid/en/latest/).

## What it does

This application presents a web API for the purpose of verifying address
data using Melissa Data as a backend.  There are 2 available methods for
verification.  The **Lookup** method is meant to provide backwards 
compatibility with applications that used the FirstLogic API.  The 
**Verify** method is put together in a way that mimics the simplest use
of the Melissa Data Python Wrapper and is the preferred method of use.

Queries may be made to:

    /lookup/?...

    /address/?...

    /verify/?...

## How it works

The URL path indicates which *view callable* is utilized and, therefore,
which function is called to manipulate the data.  Both available 
*view callables* are functions that return json rendered with the 
*jsonp* renderer from the *json* module.

The input data is used with a call to a function (mdVerify) that uses
the *mdAddrPythonWrapper* module.  This module hooks into Melissa Data.
All data available is returned from this function to the view.

## How to use it

### Lookup

The parameters that are accepted for ``/lookup/`` mode are: 

 * line1
 * line2
 * name (not implemented, ignored)

Here's an example of the returned JSON:

    {
      city: "WASHINGTON",
      first_name: "",
      last_name: "",
      middle_name: "",
      addr: "430 S CAPITOL ST SE",
      zip: "20003",
      plus4: "4024",
      house_number: "430",
      gender: "",
      street_name: "CAPITOL",
      title: "",
      county_fips: "11001",
      cd: "01",
      county: "DISTRICT OF COLUMBIA",
      apt_type: "",
      state: "DC",
      street_type: "ST",
      suffix: "",
      street_prefix: "S",
      street_postfix: "SE",
      apt_num: ""
    }


### Address
This path is used exactly as the `/lookup/` path except that the name
parameter is ignored and there is an extra requirement that requests
come from a referer of either www.democrats.org or my.democrats.org or
www.barackobama.com or my.barackobama.com OR that the request comes from
127.0.0.1.

### Verify

The parameters that are accepted for ``/verify/`` mode are:

 * company
 * address
 * address2
 * city
 * state
 * zip
 * plus4
 * lastName

The parameters that are returned (in JSON format) are:

    {
      parsedSuiteRange: "",
      deliveryPointCheckDigit: "2",
      parsedLockBox: "",
      rbdi: "",
      countryCode: "US",
      eLotOrder: "X",
      results: "AC01,AC11,AC12,AS01",
      expirationDate: "11-30-2013",
      result: 0,
      parsedPostDirection: "SE",
      zipType: " ",
      eLotNumber: "-1",
      parsedSuffix: "St",
      cmra: "N",
      city: "Washington",
      zip: "20003",
      databaseDate: "2013-08-15",
      parsedStreetName: "Capitol",
      parsedGarbage: "",
      dpvFootnotes: "AABB",
      suiteLinkReturnCode: "",
      urbanization: "",
      cityAbbreviation: "Washington",
      state: "DC",
      suite: "",
      congressionalDistrict: "01",
      address2: "",
      msa: "",
      deliveryPointCode: "30",
      timeZoneCode: "05",
      privateMailbox: "",
      countyName: "District Of Columbia",
      company: "",
      parsedRouteService: "",
      ewsFlag: " ",
      parsedSuiteName: "",
      buildNumber: "2225",
      address: "430 S Capitol St SE",
      parsedDeliveryInstallation: "",
      addressKey: "20003402430",
      plus4: "4024",
      countyFips: "11001",
      parsedPrivateMailboxName: "",
      carrierRoute: "C005",
      parsedPreDirection: "S",
      addressTypeCode: "S",
      parsedAddressRange: "430",
      pmsa: "",
      timeZone: "Eastern Time",
      addressTypeString: "Street",
      lacsLinkReturnCode: " ",
      lacsLinkIndicator: " "
    }


### Reference implementation

The Melissa Data API app is installed into the ``/dnc/app/mdAPI``
folder.  It is run with its own ``virtualenv`` and separate INI files
for each environment (development, staging, production).

### Managing services

The Python application is run using upstart to simplify management of 
the gunicorn wsgi http server.  Nginx is used as a reverse proxy in 
front of that to provide better performance (as recommended here 
http://gunicorn.org/#deployment).  In order to manage these services, 
you can use the following commands:

#### gunicorn:

    $ start mdAPI
    $ stop mdAPI
    $ restart mdAPI

#### nginx:

    $ service nginx start
    $ service nginx stop
    $ service nginx restart
    $ service nginx reload

#### Logs

Logs for gunicorn, nginx, and the app itself are collected, separately, 
under the ``/dnc/app/mdAPI/var/log/`` folder.

    /dnc/app/mdAPI/var/log/nginx.log
    /dnc/app/mdAPI/var/log/gunicorn.log
    /dnc/app/mdAPI/var/log/mdAPI.log



## For developers

### Integrating an application

This API is exposed via web, simply make a GET request to the 
appropriate URL and path to get the address normalized.

### Deployment

This application uses Fabric for deployment and other things.  To see a
list of the available fabric commands, use:

    fab -l

The deployment method is, basically, to produce a basic source 
distribution / egg file using ``python setup.py sdist`` and to install
that on the target servers.  However, this necessitates the creation and
maintenance of appropriate ``virtualenv`` folders on the target machines
as well.  The process of setting up the environment needs to be carried
out before the source distribution is compiled and installed on the
target server.  This is streamlined, using Fabric, with the command:

    fab -R dev setup

In order to deploy to the preferred environment (after the auth keys
have been sorted out), use:

    fab -R dev deploy

If it becomes necessary to wipe the target server, there is a ``wipe`` 
task available for use in the fabfile:

    fab -R dev wipe

This works for *dev*, *stage*, and *prod*. (NOTE: prod not set up yet).

-------------------------

**Author**: Sunil K Chopra <schopra@misdepartment.com>


