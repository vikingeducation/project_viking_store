Project: Viking Store Admin
========================

##To Get Going On This Assignment
- run `rake db:create`
- run `rake db:migrate`
- run `rake db:seed`

- take a look around the schema file to see how models were created

Link to solution info on the seeding of this lives [here](https://gist.github.com/betweenparentheses/0b6b325ceaaea76a521d)


select count(*), DATE(created_at) from
orders
group by DATE(created_at)

select count(*), DATE(created_at) from orders
where DATE(created_at) between current_date and current_date-7
group by DATE(created_at)