# Writing Ansible Modules in Bash

### Introduction

Ansible is a great tool for automating the configuration of servers. However on occasion you may find the server you want to configure doesn't have Python installed.

This repo contains a guide to writing Ansible modules in bash, which is installed on almost every Linux server.

### Ansible Modules

An Ansible module *MUST* be a single executable script.

It only takes 1 argument, the name of a file containing the module arguments.

If the module is called as follows:

```yaml
- name: Hello World
  module-name:
    action: hello_world
    user_name: Bob
```

The arguments file will contain the following:

```
action=hello_world user_name=Bob
```

The module MUST return a JSON string containing the following variables:

```json
{
    "changed": true, // Has the module made any changes to the target
    "failed": false, // Was the module successful
    "msg": "Hello, world!" // A message to display to the caller
}
```

The module MAY return any other variables, which will become metadata for the caller.

###  Testing via Ansible

You can use the `ansible` command to run your module. If your module outputs anything other than JSON, it will be treated as a failure. 

```sh
$ ansible -c local -i 'localhost,'  -M . -m module-name -a 'action=ping' all
localhost | SUCCESS => {
    "changed": false,
    "msg": "",
    "rc": 0,
    "stderr": "",
    "stderr_lines": [],
    "stdout": "pong",
    "stdout_lines": [
        "pong"
    ]
}
```

### Testing in Bash

You can execute your module directly. This can be handy if you want to debug the module.
 
```sh
$ echo 'action=ping' > args
$ bash module-name args
{"changed":false,"failed":false,"msg":"pong"}
```

Try run module with `bash -x` option to trace its execution. 

```sh
$ bash -x module-name args
```
