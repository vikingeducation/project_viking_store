## Admin_Users

### Display Index of Users
- [ ] Index action displays the index table  
- [ ] The table contains the fields shown in the mockup  
- [ ] Link to SHOW / EDIT / DELETE (not wired yet)  
- [ ] Link to that user's orders (not wired yet)  
- [ ] Button to create a new user  

### Show a User
- [ ] The show page renders  
- [ ] The users name is across the top  
- [ ] The relevant information from the mockup is displayed  
- [ ] Link to EDIT that user's information  
- [ ] Link to DELETE that user (not wired)  
- [ ] Link to view that user's ADDRESSES (not wired)  
- [ ] Link to view that user's CART (not wired), only clickable if the user actually has a cart!  
- [ ] Credit Card info is displayed (NOTE: DONT DO THIS IN THE REAL WORLD)  
- [ ] Link to DESTROY the credit card entry functions with a confirmation. Re-renders the page  
- [ ] Buttons for CREATE ORDER (not wired) and CREATE ADDRESS (not wired) link to the create pages for these resources but will make them scoped just to this user  
- [ ] Order History is displayed with the fields shown.  
- [ ] Order History links SHOW EDIT DELETE (not wired)  
- [ ] Handles displaying a placeholder for shipping and billing addresses if none have been selected  

### Create a New User
- [ ] New form displays user's name at top  
- [ ] Displays demographic info as in the mockup  
- [ ] Link to view that user's addresses (not wired)  
- [ ] Button to save user  
- [ ] Must include submission of first and last name and email  
- [ ] fname, lname, email must be 1-64 characters  
- [ ] email must have an @  
- [ ] Address dropdowns come pre-populated with the user's addresses. For new users, no addresses will be available and this can be disabled.  
- [ ] Success/failure flash messages  
- [ ] Success renders the SHOW page  
- [ ] Failure re-renders the form with errors  

### Edit a User
- [ ] Edit displays the same form as new  
- [ ] Shows user's name/id in the header  
- [ ] All fields are editable as per the mockup  
- [ ] Validations and other criteria are as per the NEW story  
- [ ] Link to DELETE the user with confirm (not wired)  
- [ ] Success/failure flashes  
- [ ] success redirects to SHOW  
- [ ] failure re-renders form with errors  

### Delete a User
- [ ] DELETE links are wired up to destroy the user with CONFIRMATION  
- [ ] Deleting does NOT destroy historical records of orders  
- [ ] Deleting DOES destroy current shopping cart  
- [ ] Deleting DOES destroy credit card info associated with the user  


## FKs on Models

### Addresses
id | user_id | city_id | state_id | ... |

### Credit_cards
id | user_id | ...

### Orders 
id | user_id | shipping_id | billing_id | ...

### Order_contents
id | product_id | order_id | ...

### Products
id | category_id | ...

### Users
id | billing_id | shipping_id | ...

### Categories
id | name 

### Cities
id | name

### States
id | name





