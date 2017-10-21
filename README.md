# Project Viking Store - Admin
========================



Viking Store Admin is rails web application designed for shop owners. It is the back office, administration view into the e-store. This way, the owner can see users who signed up, their addresses, orders, can edit their data or order details (ie. when customer called to change the order he already placed, the owner can add additional products to their orders, cancel them, change shipping or billing address). There are two types of addresses - billing and shipping and although user can add many addresses to the database, there is only one default shipping and default billing address. The store owner can also add products, categories if his store gets new products in. The Dashboard holds statistics about all orders in the past month or a year (or revenue or average value of orders), all users who signed up and basic demographic data about them, or number of orders on prticular days.

## About the author
[Dariusz Biskupski](http://dariuszbiskupski.com/)

## Getting Started

Live version of the app available on Heroku -> here:
[Viking Store Admin Portal](https://sheltered-sea-58865.herokuapp.com/)

If you like to play around you can set up your own account. If you use your real email, you will receive welcome email an notifications whenever someone else commented any of your posts. If you want to see all the users in the network - just press enter in the search bar on the top.


### Overview

<img src="viking_store_users.png" height="300" width="600" >

**All the customers that shop owner can view, check details of their profile, their orders, edit their profile or even delete... **

<img src="viking_store_add_user.png" height="300" width="600" >
**      **

<img src="viking_store_addresses.png" height="300" width="600" >
**      **

<img src="viking_store_analytics.png" height="300" width="600" >
**      **

<img src="viking_store_categories.png" height="300" width="600" >
**      **

<img src="viking_store_edit_order.png" height="500" width="600" >
**      **

<img src="viking_store_orders.png" height="300" width="600" >
**      **

![Upload Photo Page](https://github.com/Visiona/project_danebook/blob/master/public/assets/Danebook1.png)
***Upload photos to your Danebook account. You can mark one as your profile prhoto or/wallpaper photo.**
***

![View your photos](https://github.com/Visiona/project_danebook/blob/master/public/assets/Danebook4.png)
**Check your photo or photos of your friends. Like them, comment them or even like comments**
***

![See your friends or other users friends](https://github.com/Visiona/project_danebook/blob/master/public/assets/Danebook13.png)
**Check your friends of your or your friends if you click their name. Here you can also unfriend some of them if you changed your mind**
***

![Newsfeed](https://github.com/Visiona/project_danebook/blob/master/public/assets/Danebook12.png)
**Here you can see activity of your friends. You can check your posts and posts of your friends, comment them, like or unlike, and even see who liked them!**
***

![Edit your profile](https://github.com/Visiona/project_danebook/blob/master/public/assets/Danebook9.png)
**Here you can add of change about your profile**
***

![Timeline](https://github.com/Visiona/project_danebook/blob/master/public/assets/Danebook14.png)
**Here you see all your posts, comments - you can like any of other comments or comment them. Here is also small preview of your photos and friends.**
***

![Search for friends](https://github.com/Visiona/project_danebook/blob/master/public/assets/Danebook5.png)
**Here you can search for other people who are on Dnebook. You can check basic info of people in search results and friend or unfriend them.**
***

### Installing

To get the app started locally you'll need to:

1. Clone the repo with `git clone REPO_URL`
1. `cd` into the project
1. Run
  - `$ bundle install`
  - `$ bundle exec rake db:migrate`
  - `$ bundle exec rake db:seed`
(# take a look around the schema file to see how models were created)

1. Start up the server with `rails s` command and visit `http://localhost:3000` in your browser

## Running the tests

A big part of the functionality is covered by rspec tests which can be run with following command:
```
bundle exec rspec
```

## Acknowledgments

* I would like to thank to The Viking Code School for big help in advancing with this application, as well as to my mentor Holman Gao who helped me with stumbling challenges on the way. Last, but not the least - big thank you to [https://stackoverflow.com](https://enigmatic-earth-17108.herokuapp.com).
