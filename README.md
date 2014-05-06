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

1. Clone this repository:

  ```bash
  $ git clone https://github.com/leafac/ruby-tapas-downloader.git
  ```

2. Install dependencies:

  ```bash
  $ bundle install
  ```

If you really like this utility, please let me know so I can make it into a
gem!

Usage
-----

```bash
$ bin/ruby-tapas-downloader <email> <password> <download-path>
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
