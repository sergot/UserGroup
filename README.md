UserGroup
=========

Small users and groups system. Many to many relation.


Description
===========

Only member of the group can add another user.


To run:
    rake db:migrate
    rails s

* to add a group, go to /groups/new
* to add an user, go to /users/new

* to add initial user-group connections, go to /groups/new_groups_users
* to add someone to group as particular user, go to /users/:id
