Project: Viking Store Admin
========================

##To Get Going On This Assignment
- run `rake db:create`
- run `rake db:migrate`
- run `rake db:seed`

- take a look around the schema file to see how models were created

Link to solution info on the seeding of this lives [here](https://gist.github.com/betweenparentheses/0b6b325ceaaea76a521d)

### Entities (Tables):
(1) Address
(2) Category
(3) City
(4) Credit Card
(5) Order
(6) Product
(7) State
(8) User

#### Join Tables
(9) OrderContents

### Relations:
(1) Credit Card belongs_to User
(2) Order belongs_to User
(3) OrderContents belongs_to Order and belongs_to Product
(4) Product belongs_to Category

An Order is considered 'placed' once it has a 'checked_out' datetime.