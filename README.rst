edX Credentials Themes
=================================

This repository holds themes for the edX Credentials Service.

Credentials-Themes contains styles and overrides for the rendering of Program Certificates awarded through edX.org.
It does not control any styles or overrides for anything except for rendered Program Certificates.

Updates
-------

Credentials-Themes updates from automated processes such as `renovate` may require manual steps, because we build
assets statically and commit them to the repository.

For renovate or Python requirements update PRs:

1. Ensure that the credentials-themes version in __init__.py is bumped before approving / merging.
2. PRs might fail because they do a diff on the built static assets. If they do::
 
        git checkout # put branchname of PR
        npm i; pip install -r requirements/base.txt  # update your packages so that they match the PRs
        make build
        git add # put names of changed static files
        vim edx_credentials_themes/__init__.py  # or editor of choice to bump the version number as above
        git add edx_credentials_themes/__init__.py
        git commit
        git push


Building
--------

Build the assets by running ``make build``. Compiled assets should be *committed* to the repository so that they are
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
