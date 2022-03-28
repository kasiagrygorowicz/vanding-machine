# vanding-machine
To run program type:
```Ruby
ruby main.rb
```

Main menu
```
> help
Menu:
  help - shows main menu
  exit/quit/close/ - quits program
  A - show snacks in the machine
  B - shows what and how many coins are in the machine
  C - shows how much money you already put in the machine 
  D - return all put in money
  1c - puts in 1 cents
  5c - puts in 5 cent
  10c - puts in 10 cents
  25c - puts in 25 cents
  1$ - puts in 1 dollar
  5$ - puts in 5 dollars
  To buy a snack insert enough coins into the vending machine and enter number reprezenting chosen snack
> 
```

To see items in the vending machine press A:
```
> A
1 - 3 Juicy Fruit 0.65 $
2 - 2 Lays 1.00 $
3 - 4 Pepsi 1.50 $
> 
```
Insert coins and see that they are in the machine:
```
> 25c
> 1$
> C
Sum in the machine 1.25 $
```
Get money back from the machine (enter D):

```
> D
Your change:
1$
25c
```
Buy a snack and get change:

```
> 1
Your change:
10c
10c
10c
5c
Bought snack: Juicy Fruit
```
