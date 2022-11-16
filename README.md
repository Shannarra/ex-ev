# EX-EV
A fully functional expression evaluator writtien in Ruby.

### Usage
#### 1. Prerequisites
- Ruby, 3.0 and later, older versions might work.
- A terminal (any would do so long as you've got Ruby installed)

Before you can run the project you must do
```
bundle install
```
In the root directory to install the needed gems

#### 2. Running
To run in REPL mode you can just do
```
./main.rb
```

##### 2.1 CLI arguments
1. Turn the printing of the AST (abstract syntax tree) on for debugging purposes:
```
# You can use any of te following arguments to turn the AST printing on:
# --showTree, -st, --debugPrint, -dp
# So the command would look like so:

./main.rb --showTree
```

#### 3. Testing
To start the tests you just do:
```
bundle exec rspec
```
In the root directory of the project

#### 4. Linting
```
bundle exec rubocop
```
