Its a vending machine, which you need to load item and coin inventory first. After that you can select anything from the menu and enter the no. of quauntities you want. You have to tender exact amount in denominations of indian coins of 1,2,5,10. It will deliver your desired quantiy of product(s).

It will rollback your transaction and exit if you have entered invalid item name or item quantity or fake coins or any invalid data after 3 failed attempts.

Pre-requisite: Use ruby 2.4 as sum method used work slightly different than previous versions of ruby.

To run the app command is 
`ruby start_machine.rb`

To run test suite install gem rspec with below command:
`gem install rspec`

Tests cases are lying in spec folder. To run the test suite:
` rspec ` 
