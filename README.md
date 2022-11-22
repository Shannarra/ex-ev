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

For exaple, say that in the command line you've entered the expression: `((11*22+33-44)**5)/((6**7)*8+9**9)*(69/420)`
and are running the REPL using `--showTree`, the output of the expression will be consist of the AST of the given expression and below that, the evaluated result:

```
> ((11*22+33-44)**5)/((6**7)*8+9**9)*(69/420)
└───BinaryExpression
    ├───BinaryExpression
    │   ├───ParenthesizedExpression
    │   │   ├───OpenParenthesisToken
    │   │   ├───BinaryExpression
    │   │   │   ├───ParenthesizedExpression
    │   │   │   │   ├───OpenParenthesisToken
    │   │   │   │   ├───BinaryExpression
    │   │   │   │   │   ├───BinaryExpression
    │   │   │   │   │   │   ├───BinaryExpression
    │   │   │   │   │   │   │   ├───
    │   │   │   │   │   │   │   │   └───NumberToken 11
    │   │   │   │   │   │   │   ├───StarToken
    │   │   │   │   │   │   │   └───
    │   │   │   │   │   │   │       └───NumberToken 22
    │   │   │   │   │   │   ├───PlusToken
    │   │   │   │   │   │   └───
    │   │   │   │   │   │       └───NumberToken 33
    │   │   │   │   │   ├───MinusToken
    │   │   │   │   │   └───
    │   │   │   │   │       └───NumberToken 44
    │   │   │   │   └───CloseParenthesisToken
    │   │   │   ├───DoubleStarToken
    │   │   │   └───
    │   │   │       └───NumberToken 5
    │   │   └───CloseParenthesisToken
    │   ├───SlashToken
    │   └───ParenthesizedExpression
    │       ├───OpenParenthesisToken
    │       ├───BinaryExpression
    │       │   ├───BinaryExpression
    │       │   │   ├───ParenthesizedExpression
    │       │   │   │   ├───OpenParenthesisToken
    │       │   │   │   ├───BinaryExpression
    │       │   │   │   │   ├───
    │       │   │   │   │   │   └───NumberToken 6
    │       │   │   │   │   ├───DoubleStarToken
    │       │   │   │   │   └───
    │       │   │   │   │       └───NumberToken 7
    │       │   │   │   └───CloseParenthesisToken
    │       │   │   ├───StarToken
    │       │   │   └───
    │       │   │       └───NumberToken 8
    │       │   ├───PlusToken
    │       │   └───BinaryExpression
    │       │       ├───
    │       │       │   └───NumberToken 9
    │       │       ├───DoubleStarToken
    │       │       └───
    │       │           └───NumberToken 9
    │       └───CloseParenthesisToken
    ├───StarToken
    └───ParenthesizedExpression
        ├───OpenParenthesisToken
        ├───BinaryExpression
        │   ├───
        │   │   └───NumberToken 69
        │   ├───SlashToken
        │   └───
        │       └───NumberToken 420
        └───CloseParenthesisToken

 277.3142857142857

```
