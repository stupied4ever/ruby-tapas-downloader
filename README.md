Ruby Tapas Downloader
=====================

[Ruby Tapas][ruby-tapas] is a great series of screencasts by
[Avdi Grimm][avdi-grimm]. You should totally check it out if you don't already
know it!

There's only one problem with Ruby Tapas, in my opinion: there's no way to
watch it via straming. One can only download episodes, which soon becomes
tedious.

Enters Ruby Tapas Downloader! It downloads all episodes and attachments,
organizes them for later use and keeps an easy to use index of episodes.

Installation
------------

```bash
$ gem install ruby-tapas-downloader
```

Usage
-----

```bash
$ ruby-tapas-downloader download -e <email> -p <password> -l <path>
```

If you prefer, you can pre-configure, in that way you dont need authenticate
every download.

```bash
$ ruby-tapas-downloader configure -e <email> -p <password> -l <path>
```

One other alternative is to pass/export env vars:

```bash
$ export RUBY_TAPAS_DOWNLOADER_EMAIL=someone@example.com
$ export RUBY_TAPAS_DOWNLOADER_PASSWORD=123
$ export RUBY_TAPAS_DOWNLOADER_PATH=.

$ ruby-tapas-downloader download
```

Warning
-------

Except for a few episodes, Ruby Tapas is a paid screencast. Therefore, assert
that you don't redistribute the downloaded material. Ruby Tapas Downloader is
only an utility tool and doesn't substitute the subscription.

You should do no evil!

Thanks
------

Thanks Avdi Grimm for putting all this great material out the door!

I learn a lot from you.

[ruby-tapas]: http://www.rubytapas.com/
[avdi-grimm]: http://devblog.avdi.org/
