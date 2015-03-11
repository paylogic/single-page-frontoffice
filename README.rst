Paylogic single page frontoffice
================================

A single page application that uses the Paylogic Shopping Service API. A
simple and fast way to buy tickets!

The application was built using `AngularJS`_ and `UIkit`_.

Wondering how easy it can be? Just **4 steps**!

-  Select an event
-  Select products
-  Select payment / shipping methods
-  Provide personal information

And click confirm! You have just completed the easiest purchasing
process of your life!

Running it locally
------------------

::

    # Clone the git repository.
    git clone git@github.com:paylogic/single-page-frontoffice.git

    # Install requirements and run the application.
    # npm install will also run bower install.
    # If not, after npm install, run bower install manually.
    cd single-page-frontoffice
    npm install

Configure application
~~~~~~~~~~~~~~~~~~~~~

In order for the application to communicate properly with the Paylogic
Shopping Service API, you must provide the correct credentials. Only
Paylogic can provide you with valid credentials.

Place the credentials in the coffeescript file responsible for the
application’s configuration ``/src/scripts/app.coffee``. The ``baseUrl``
will be provided to you along with the credentials.

::

    paylogicShoppingServiceConfigProvider.set
      apiKey: "YOUR_API_KEY"
      apiSecret: "YOUR_API_SECRET"
      baseUrl: "BASE_URL"

Enjoy
~~~~~

Run ``node_modules/.bin/gulp`` in your project’s root folder and open
the application in your favorite browser ``http://localhost:8080``.

Translations
------------

Static strings
~~~~~~~~~~~~~~

For translating static strings we use `angular-gettext`_.

Steps for translating static strings:

1. Annotate the strings you wish to translate. Follow the `documentation
   here`_.
2. While in your project’s root folder, run
   ``node_modules/.bin/gulp extract-trans``. A ``.pot`` file will be
   created in the folder ``/src/translations``, containing all the
   annotated strings available for translation.
3. Following the `documentation
   here <https://angular-gettext.rocketeer.be/dev-guide/translate/>`__
   and using the ``.pot`` file that was created in the previous step,
   you can create files for every language you want to use.
   **Important!** You must save the language files in the
   ``/src/translations`` folder, where your ``.pot`` file exists.
4. Add the languages in the application’s configuration file
   ``/src/scripts/app.coffee``, at ``app.constant "languages"``
5. You should see the extra languages in the dropdown list selection in
   the application.

Each time you annotate more strings, you must run the
``node_modules/.bin/gulp extract-trans`` command to update the ``.pot``
file.

API Resources
~~~~~~~~~~~~~

For translating the API resources, we use the **localize** filter.

Provide the filter with the resource you wish to translate and
everything will be done automatically.

::

    # Example
    # Resource: event.content.title = { en: 'Test Event', nl: 'Testevenement' }

    event.

Contact
-------

If you have questions, bug reports, suggestions, etc. please create an issue on
the `GitHub project page`_.

License
-------

This software is licensed under the `MIT license`_

See `License`_

© 2015 Paylogic International.

.. _AngularJS: https://angularjs.org/
.. _UIkit: http://getuikit.com/
.. _angular-gettext: https://angular-gettext.rocketeer.be/
.. _documentation here: https://angular-gettext.rocketeer.be/dev-guide/annotate/
.. _GitHub project page: http://github.com/paylogic/single-page-frontoffice
.. _MIT license: http://en.wikipedia.org/wiki/MIT_License
.. _License: https://github.com/paylogic/single-page-frontoffice/blob/master/LICENSE
