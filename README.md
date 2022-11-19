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
ruby ./main.rb
```

##### 2.1 CLI arguments
1. Turn the printing of the AST (abstract syntax tree) on for debugging purposes:
```
# You can use any of te following arguments to turn the AST printing on:
# --showTree, -st, --debugPrint, -dp
# So the command would look like so:

ruby ./main.rb --showTree
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

#### 5. Debugging
When debugging you can print the current AST in a format similar to the linux `tree` command:

For exaple, say that in the command line you've entered the expression: `2+2+2+22+2+2*954-6**7+3/65`
and are running the REPL using `--showTree`, the output of the expression will be (rounded to the nearest Integer sinse we don't yet fully support floats):

```
> 2+2+2+22+2+2*954-6**7+3/65
└───BinaryExpression
    ├───BinaryExpression
    │   ├───BinaryExpression
    │   │   ├───BinaryExpression
    │   │   │   ├───BinaryExpression
    │   │   │   │   ├───BinaryExpression
    │   │   │   │   │   ├───BinaryExpression
    │   │   │   │   │   │   ├───
    │   │   │   │   │   │   │   └───NumberToken 2
    │   │   │   │   │   │   ├───PlusToken
    │   │   │   │   │   │   └───
    │   │   │   │   │   │       └───NumberToken 2
    │   │   │   │   │   ├───PlusToken
    │   │   │   │   │   └───
    │   │   │   │   │       └───NumberToken 2
    │   │   │   │   ├───PlusToken
    │   │   │   │   └───
    │   │   │   │       └───NumberToken 22
    │   │   │   ├───PlusToken
    │   │   │   └───
    │   │   │       └───NumberToken 2
    │   │   ├───PlusToken
    │   │   └───BinaryExpression
    │   │       ├───
    │   │       │   └───NumberToken 2
    │   │       ├───StarToken
    │   │       └───
    │   │           └───NumberToken 954
    │   ├───MinusToken
    │   └───BinaryExpression
    │       ├───
    │       │   └───NumberToken 6
    │       ├───DoubleStarToken
    │       └───
    │           └───NumberToken 7
    ├───PlusToken
    └───BinaryExpression
        ├───
        │   └───NumberToken 3
        ├───SlashToken
        └───
            └───NumberToken 65
-277998

```
