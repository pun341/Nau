# Nau
The cimple config wrapper for APT

# Syntax

## Basic
```
# The '@' symbol is used to start and close an instruction #
@print{hello!!}@
@pkgs{nano, lua, luajit}
```
You can write comments anywhere even without a '#'

```
This is a comment
@print{This is not a comment}@
```

# Instruction list
```
@var{name:value}@ 
Do not put space before the ':' for example: @var{name :value}@

@print{string}@

@pkgs{pkg1, pkg2, pkg3}@
Can be seperated by a ',' or ' '
```
