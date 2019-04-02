README - DisplayContent (DisplayContent Plugin)
================================

DisplayContent is a plugin to allow the user adds a block where you could choose any of your content for display it.

The DisplayContent block will be available for all layout columns of communities, peole, enterprises and environments.

All the articles choosen are displayed as a list with a link for the title and the lead content.

If a Blog or a Folder is choosen the block will display all articles inside the blog or the folder.

Galleries are not displayed in this block.

INSTALL
=======

Enable Plugin
-------------

Also, you need to enable DisplayContent Plugin at you Noosfero:

cd <your_noosfero_dir>
./script/noosfero-plugins enable display_content

Active Plugin
-------------

As a Noosfero administrator user, go to administrator panel:

- Click on "Enable/disable plugins" option
- Click on "Display Content Plugin" check-box

DEVELOPMENT
===========

Noosfero uses jQuery 1.5.1 and the jsTree doesn't works fine with this jQuery version.
Until Noosfero upgrade its JQuery version to a newer one is necessary to load jQuery 1.8.3 inside plugin and apply some changes in jsTree to avoid jQuery conflit.

Get the Display Content (Noosfero with Display Content Plugin) development repository:

$ git clone https://gitorious.org/+noosfero/noosfero/display_content

Running DisplayContent tests
--------------------

$ rake test:noosfero_plugins:display_content


Get Involved
============

If you found any bug and/or want to collaborate, please send an e-mail to leandronunes@gmail.com

LICENSE
=======

Copyright (c) The Author developers.

See Noosfero license.


AUTHORS
=======

 Leandro Nunes dos Santos (leandronunes at gmail.com)

ACKNOWLEDGMENTS
===============

The author have been supported by Serpro
