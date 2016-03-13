Project: Viking Store Admin
By Steven Chang
========================

##To Get Going On This Assignment
- run `rake db:create`
- run `rake db:migrate`
- run `rake db:seed`

- take a look around the schema file to see how models were created

Link to solution info on the seeding of this lives [here](https://gist.github.com/betweenparentheses/0b6b325ceaaea76a521d)

1. Thanks for working so hard on your seeds file. For consistency's sake, you will need to use ours from now on. Start by forking and cloning this repo to continue your development work. This allows you to compare your results against ours and those of your classmates.

2. Read through the new seeds file so you get a good idea of how the data model is structured. It's probably different in some key ways than the one you designed yourself. Specifically think through:

a. How shopping carts are represented
- It's in the Order table, if an order object has NULL for the checked_out date, then it means it's a shopping cart.

b. How we know whether an order has been placed or not
- As above, if an order object has NULL for the checked_out date, then it means it's a shopping cart.
