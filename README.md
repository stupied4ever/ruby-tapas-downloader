Ruby Tapas Downloader
=====================

[Ruby Tapas][1] is a great series of screencasts by [Avdi Grimm][2]. You should
totally check it out if you don't already know it!

There's only one problem with Ruby Tapas, in my opinion: there's no way to
watch it via straming. One can only download episodes, which soon becomes
tedious.

Enters Ruby Tapas Downloader! It downloads all episodes and attachments,
organizes them for later use and keeps an easy to use index of episodes.

Usage
-----

Clone this repository:

```bash
$ git clone git://github.com/leafac/ruby-tapas-downloader.git
```

Change to the newly created directory:

```bash
$ cd ruby-tapas-downloader
```

Install dependencies:

```bash
$ bundle install
```

Run it:

```bash
$ env USERNAME='<username>' PASSWORD='<password>' ruby ruby_tapas_downloader.rb
```

Pretty regular Ruby application, huh?

An optional `VERBOSE` environment variable is available. When set to `true`,
it logs the hell out of operations, which is useful for debugging.

Episodes and code are downloaded to a directory called `episodes` in the
current folder.

An `index.yml` is kept under `episodes` as well for referencing and preventing
future repetitive requests.

Warning
-------

Except for a few episodes, Ruby Tapas is a paid screencast. Therefore, assert
that you don't redistribute the downloaded material. Ruby Tapas Downloader is
only an utility tool and doesn't substitute the subscription.

You should do no evil!

License
-------

               DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                       Version 2, December 2004

    Copyright (C) 2013 Leandro Facchinetti <leafac@gmail.com>

    Everyone is permitted to copy and distribute verbatim or modified
    copies of this license document, and changing it is allowed as long
    as the name is changed.

               DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
      TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

     0. You just DO WHAT THE FUCK YOU WANT TO.


[1]: http://www.rubytapas.com/
[2]: http://devblog.avdi.org/
