edX Credentials Themes  |Travis|_
=================================
.. |Travis| image:: https://travis-ci.com/edx/credentials-themes.svg?branch=master
.. _Travis: https://travis-ci.com/edx/credentials-themes

This repository holds themes for the edX Credentials Service.

This information is NOT LICENSED for usage by others.

Building
--------

Build the assets by running `make build`. Compiled assets should be *committed* to the repository so that they are
accessible by the Credentials Service when the package is installed.

i18n
-----

Run `make base_requirements` to install dependencies necessary for running i18n commands. Note: this will install
Django and is best done from within a Python virtualenv.

To mark strings in templates/partials for translation, simply wrap them in one of Django's built-in translation functions.
See https://docs.Djangoproject.com/en/1.11/topics/i18n/translation/#internationalization-in-template-code for more details.

Extract strings that have been marked for translation by running `make extract_translations`. This command will produce
a gettext .po file, ./conf/locale/en/LC_MESSAGES/django.po, which may be uploaded to Transifex (or another translation
provider) where the strings can be translated.

Compile translated strings by running `make compile_translations`. This will produce a .mo file for each .po in the repo.
The .mo files are read by Django and are used to provide translations in the running application.

Testing credentials-themes changes in devstack
----------------------------------------------
See instructions_ on the OpenEdX Wiki.

.. _instructions: https://openedx.atlassian.net/wiki/spaces/SOL/pages/608698737/Testing+WL+themes+in+devstack
