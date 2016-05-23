[![](https://ci.solanolabs.com:443/maxmal/simple-todo/badges/branches/master?badge_token=11c2b817887f1c6350f95c1a542ddbee8230676f)](https://ci.solanolabs.com:443/maxmal/simple-todo/suites/452368)

## README

Used Ruby 2.3.0, Rails 4.2.0, AngularJS 1.4.8, Bootstrap 3

Devise used for authorization, RSpec + Capybara for tests

[Try out demo on Heroku](https://young-stream-5505.herokuapp.com/#/todo).

**Keep in mind, that files you upload (comments attachments), will be deleted in a short term, or will not be saved at all, if they are large, because of Heroku file system settings, and you probably will not be able download these files.**

**I recommend using small txt files for testing uploading and downloading.**

To run tests just run (you need installed firefox in your system)
```
rake spec
```
There are 112 tests at the moment
![tests](https://pp.vk.me/c628527/v628527426/bf9e/5pIQRQ82t9I.jpg)
