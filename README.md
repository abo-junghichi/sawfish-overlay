# Sawfish Overlay

This is a Gentoo portage [overlay](https://wiki.gentoo.org/wiki/Ebuild_repository)
for the [Sawfish window manager][sawfish],
based on [the overlay written by teika](https://gitlab.com/teika-gentoo/sawfish-overlay).
It is modified to directly use GIT Repositories of [the upstream][sawfish].

## Ebuild description

### *-9999.ebuild
These ebuilds follow [live ebuild scheme](https://wiki.gentoo.org/wiki/Live_ebuilds) which invokes "git clone".

### *-9998.ebuild
They simply download the upstream snapshot zip-file to store it as "*-9998.zip" into distfiles-directory.
This means you should invoke "ebuild *-9998.ebuild digest" each time
when upsteam modifies the repository.

The ebuilds can be used at boxes without good connection to the internet
which fail to complete "git clone".

[sawfish]: https://github.com/SawfishWM
