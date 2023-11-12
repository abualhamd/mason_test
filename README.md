# mason_test

This is a test project for exploring mason

## Mason Commands
- dart pub global activate mason_cli
    - used to intialize mason
- mason init
  - intializes mason
- mason add <mason_brick>
  - add bricks from brickshub to mason.yaml
- mason add <mason_brick> --path <brick/path>
  - add a brick locally 
- mason get
  - gets your registered bricks
- mason make <brick_name> -o <./your/custom/path> --\<variable> \<value>
  - generates the template you've specified
- mason make <brick_name> -c config.json 
  - to get your variables form a configuration file


## Conditionals
    {{#condition}}file.dart{{/condition}}
  - use it to create files conditionally