                            Debian Policy
                            =============

Author: Manoj Srivastava And Russ Allbery <srivasta@debian.org>
Date: 2009-09-15 15:48:35 CDT


Infrastructure 
~~~~~~~~~~~~~~~

+ Website:: [http://www.debian.org/doc/devel-manuals#policy]
+ Mailing list:: debian-policy@lists.debian.org lists
+ Source Code::
  * git clone git://git.debian.org/git/dbnpolicy/policy.git
  * Browser: [http://git.debian.org/?p=dbnpolicy/policy.git] 
+ Unix group:: dbnpolicy
+ Alioth Project:: [http://alioth.debian.org/projects/dbnpolicy] (exists
  to manage the repository but not otherwise used)

Interacting with the team 
==========================

+ Email contact:: [mailto:debian-policy@lists.debian.org]
+ Request tracker:: [http://bugs.debian.org/src:debian-policy]

Debian Policy uses a formal procedure and a set of user tags to manage
the lifecycle of change proposals. For definitions of those tags and
proposal states and information about what the next step is for each
phase, see [Policy changes process].

Once the wording for a change has been finalized, please send a patch
against the current Git master branch to the bug report, if you're not
familiar with Git, the following commands are the basic process:

  git clone git://git.debian.org/git/dbnpolicy/policy.git
  git checkout -b <local-branch-name>
  
  # edit files, but don't make changes to upgrading-checklist or debian/changelog
  git add <files>
  git commit
  # repeat as necessary
  
  # update your branch against the current master
  git checkout master
  git pull
  
  # If there are changes in master that make the branch not apply cleanly:
   git checkout -b temp master; git merge <local-branch-name>
  # If error, reset temp, merge master into local; else skip these three lines
   git reset --hard HEAD;
   git checkout <local-branch-name>; 
   git merge master
  # get rid of the temp branch:
   git branch -D temp
  
  # Checkout the local branch, to create the patch to send to the policy
  git checkout <local-branch-name>
  dir=$(mktemp -d)
  git format-patch -o $dir -s master
  # check out the patches created in $dir
  git send-email --from "you <your@email>"             \
                 --to debian-policy@lists.debian.org   \
                 $dir/


<local-branch-name> is some convenient name designating your local
changes. You may want to use some common prefix like local-. You can
use git format-patch and git send-email if you want, but usually it's
overkill.


[Policy changes process]: Process.txt

Usual Roles 
~~~~~~~~~~~~

The Debian Policy team are official project delegates (see the DPL
delegation). All of the Policy team members do basically the same
work: shepherd proposals, propose wording, and merge changes when
consensus has been reached. The current delegates are:

+ Russ Allbery
+ Bill Allombert
+ Andrew McMillan
+ Manoj Srivastava
+ Colin Watson (cjwatson) 

The special tasks of Policy delegates are:

+ Commit access to the Git repository and uploads of the debian-policy
  package itself, which makes them responsible for debian-policy as a
  package in Debian and for making final decisions about when a new
  version is released and what bits go into it.
+ Rejecting proposals. Anyone can argue against a proposal, but only
  Policy delegates can formally reject it.
+ Counting seconds and weighing objections to proposals to determine
  whether the proposal has sufficient support to be included.

Everything else can be done by anyone, or any DD (depending on the
outcome of the discussion about seconding). We explicitly want any
Debian DD to review and second or object to proposals. The more
participation, the better. Many other people are active on the Policy
mailing list without being project delegates.

Task description 
~~~~~~~~~~~~~~~~~

The Debian Policy team is responsible for maintaining and coordinating
updates to the technical Policy manuals for the project. The primary
output of the team is the Debian Policy Manual and the assorted
subpolicies, released as the debian-policy Debian package and also
published at [http://www.debian.org/doc/].

In addition to the main technical manual, the team currently also maintains:

+ [Debian Menu sub-policy]
+ [Debian Perl Policy]
+ [Debian MIME support sub-policy]
+ [Debconf Specification]
+ [Authoritative list of virtual package names ]

These documents are maintained using the [Policy changes process], and
the current state of all change proposals is tracked using the
[debian-policy BTS].


[Debian Menu sub-policy]: http://www.debian.org/doc/packaging-manuals/menu-policy/
[Debian Perl Policy]: http://www.debian.org/doc/packaging-manuals/perl-policy/
[Debian MIME support sub-policy]: http://www.debian.org/doc/packaging-manuals/mime-policy/
[Debconf Specification]: http://www.debian.org/doc/packaging-manuals/debconf_specification.html
[Authoritative list of virtual package names ]: http://www.debian.org/doc/packaging-manuals/virtual-package-names-list.txt
[Policy changes process]: Process.txt
[debian-policy BTS]: http://bugs.debian.org/src:debian-policy

Get involved 
~~~~~~~~~~~~~

The best way to help is to review the [current open bugs], pick a bug
that no one is currently shepherding (ask on
[debian-policy@lists.debian.org] if you're not sure if a particular bug
is being shepherded), and help it through the change process. This
will involve guiding the discussion, seeking additional input
(particularly from experts in the area being discussed), possibly
raising the issue on other mailing lists, proposing or getting other
people to propose specific wording changes, and writing diffs against
the current Policy document. All of the steps of [Policy changes process] 
can be done by people other than Policy team members except
the final acceptance steps and almost every change can be worked on
independently, so there's a lot of opportunity for people to help.

There are also some other, larger projects:

+ Policy is currently maintained in DebianDoc-SGML, which is no longer
  very actively maintained and isn't a widely used or understood
  format. The most logical replacement would be DocBook. However,
  DocBook is a huge language with many tags and options, making it
  rather overwhelming. We badly need someone with DocBook experience
  to write a style guide specifying exactly which tags should be used
  and what they should be used for so that we can limit ourselves to
  an easy-to-understand and documented subset of the language.
+ Policy contains several appendices which are really documentation of
  how parts of the dpkg system works rather than technical
  Policy. Those appendices should be removed from the Policy document
  and maintained elsewhere, probably as part of dpkg, and any Policy
  statements in them moved into the main document. This project will
  require reviewing the current contents of the appendices and feeding
  the useful bits that aren't currently documented back to the dpkg
  team as documentation patches.
+ Policy has grown organically over the years and suffers from
  organizational issues because of it. It also doesn't make use of the
  abilities that a current XML language might give us, such as being
  able to extract useful portions of the document (all *must*
  directives, for example). There has been quite a bit of discussion
  of a new format that would allow for this, probably as part of
  switching to DocBook, but as yet such a reorganization and reworking
  has not been started.

If you want to work on any of these projects, please mail
[debian-policy@lists.debian.org ] for more information. We'll be happy to
help you get started.


[current open bugs]: http://bugs.debian.org/src:debian-policy
[debian-policy@lists.debian.org]: mailto:debian-policy@lists.debian.org
[Policy changes process]: Process.txt
[debian-policy@lists.debian.org ]: mailto:debian-policy@lists.debian.org

Maintenance procedures 
=======================

Repository layout 
==================

The Git repository used for Debian Policy has the following branches:

+  master:: the current accepted changes that will be in the next release
+  bug<number>-<user>:: changes addressing bug <number>, shepherded by <user>
+  rra:: old history of Russ's arch repository, now frozen
+  srivasta:: old history of Manoj's arch repository 

Managing a bug 
===============

The process used by Policy team members to manage a bug, once there is
proposed wording, is:

+ Create a bug<number>-<user> branch for the bug, where <number> is
  the bug number in the BTS and <user> is a designator of the Policy
  team member who is shepherding the bug.
+ Commit wording changes in that branch until consensus is
  achieved. Do not modify debian/changelog or upgrading-checklist.html
  during this phase. Use the BTS to track who proposed the wording and
  who seconded it.
+ git pull master to make sure you have the latest version.
+ Once the change has been approved by enough people, git merge the
  branch into master immediately after making the final commit adding
  the changelog entry to minimize conflicts.
+ add the debian/changelog and upgrading-checklist.html changes, and
  commit to master.
+ Push master out so other people may merge in their own bug branches
  without conflicts.
+ Tag the bug as pending and remove other process tags.
+ Delete the now-merged branch.

The Git commands used for this workflow are:
  git checkout -b bug12345-rra master
  # edit files
  # git add files
  git commit
  git push origin bug12345-rra
  # iterate until good
  # update your local master branch
  git checkout master
  git pull
  # If there are changes in master that make the branch not apply cleanly:
  git checkout -b temp master; git merge bug12345-rra
  # If error;
  git reset --hard HEAD;
  git checkout bug12345-rra; git branch -D temp
  git merge master
  git checkout master
  git merge bug12345-rra
  # edit debian/changelog and upgrading-checklist.html
  git add debian/changelog upgrading-checklist.html
  git commit
  git push origin master
  git branch -d bug12345-rra
  git push origin :bug12345-rra


For the debian/changelog entry, use the following format:
  * <document>: <brief change description>
    Wording: <author of wording>
    Seconded: <seconder>
    Seconded: <seconder>
    Closes: <bug numbers>


For example:
  * Policy: better document version ranking and empty Debian revisions
    Wording: Russ Allbery <rra@debian.org>
    Seconded: Raphaël Hertzog <hertzog@debian.org>
    Seconded: Manoj Srivastava <srivasta@debian.org>
    Seconded: Guillem Jover <guillem@debian.org>
    Closes: #186700, #458910


Updating branches 
==================

After commits to master have been pushed, either by you or by another
Policy team member, you will generally want to update your working bug
branches. The equivalent of the following commands should do that:

  for i in `git show-ref --heads | awk '{print $2}'`; do
      j=$(basename $i)
      if [ "$j" != "master" ]; then
          git checkout $j && git merge master
      fi
  done
  git push --all origin


assuming that you haven't packed the refs in your repository.

Making a release 
=================

For a final Policy release, change UNRELEASED to unstable in
debian/changelog and update the timestamp to match the final release
time (dch -r may be helpful for this), update the release date in
upgrading-checklist.html, update Standards-Version in debian/control,
and commit that change. Then do the final release build and make sure
that it builds and installs.

Then, tag the repository and push the final changes to Alioth:

  git tag -s v3.8.0.0
  git push origin
  git push --tags origin


replacing the version number with the version of the release, of course.

Finally, announce the new Policy release on debian-devel-announce,
including in the announcement the upgrading-checklist section for the
new release.

Setting release goals 
======================

Policy has a large bug backlog, and each bug against Policy tends to
take considerable time and discussion to resolve. I've found it
useful, when trying to find a place to start, to pick a manageable set
of bugs and set as a target resolving them completely before the next
Policy release. Resolving a bug means one of the following:

+ Proposing new language to address the bug that's seconded and approved by
  the readers of the Policy list following the [Policy changes process] (or
  that's accepted by one of the Policy delegates if the change isn't
  normative; i.e., doesn't change the technical meaning of the document).
+ Determining that the bug is not relevant to Policy and closing it.
+ Determining that either there is no consensus that the bug indicates
  a problem, that the solutions that we can currently come up with are
  good solutions, or that Debian is ready for the change. These bugs
  are tagged wontfix and then closed after a while. A lot of Policy
  bugs fall into this category; just because it would be useful to
  have a policy in some area doesn't mean that we're ready to make
  one, and keeping the bugs open against Policy makes it difficult to
  tell what requires work. If the problem is worth writing a policy
  for, it will come up again later when hopefully the project
  consensus is more mature.

Anyone can pick bugs and work resolve them. The final determination to
accept a wording change or reject a bug will be made by a Policy
delegate, but if a patch is already written and seconded, or if a
summary of why a bug is not ready to be acted on is already written,
the work is much easier for the Policy delegate.

One of the best ways to help out is to pick one or two bugs (checking
on the Policy list first), say that you'll make resolving them a goal
for the next release, and guide the discussion until the bugs can
reach one of the resolution states above.

[Policy changes process]: ./Progress.org

