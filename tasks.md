## Admin_Users

### Display Index of Users
- [x] Index action displays the index table  
- [x] The table contains the fields shown in the mockup  
- [x] Link to SHOW / EDIT / DELETE (not wired yet)  
- [x] Link to that user's orders (not wired yet)  
- [x] Button to create a new user  

### Show a User
- [x] The show page renders  
- [x] The users name is across the top  
- [x] The relevant information from the mockup is displayed  
- [x] Link to EDIT that user's information  
- [x] Link to DELETE that user (not wired)  
- [x] Link to view that user's ADDRESSES (not wired)  
- [x] Link to view that user's CART (not wired), only clickable if the user actually has a cart!  
- [x] Credit Card info is displayed (NOTE: DONT DO THIS IN THE REAL WORLD)  
- [x] Link to DESTROY the credit card entry functions with a confirmation. Re-renders the page  
- [x] Buttons for CREATE ORDER (not wired) and CREATE ADDRESS (not wired) link to the create pages for these resources but will make them scoped just to this user  
- [x] Order History is displayed with the fields shown.  
- [x] Order History links SHOW EDIT DELETE (not wired)  
- [x] Handles displaying a placeholder for shipping and billing addresses if none have been selected  
- [ ] Add telephone
- [ ] Refactor with presenter pattern

### Create a New User
- [x] New form displays user's name at top  
- [x] Displays demographic info as in the mockup  
- [x] Link to view that user's addresses (not wired)  
- [x] Button to save user  
- [x] Must include submission of first and last name and email  
- [x] fname, lname, email must be 1-64 characters  
- [x] email must have an @  
- [x] Address dropdowns come pre-populated with the user's addresses. For new users, no addresses will be available and this can be disabled.  
- [x] Success/failure flash messages  
- [x] Success renders the SHOW page  
- [x] Failure re-renders the form with errors  

### Edit a User
- [x] Edit displays the same form as new  
- [x] Shows user's name/id in the header  
- [x] All fields are editable as per the mockup  
- [x] Validations and other criteria are as per the NEW story  
- [x] Link to DELETE the user with confirm (not wired)  
- [x] Success/failure flashes  
- [x] success redirects to SHOW  
- [x] failure re-renders form with errors  

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





