# Examples for modules

TODO: Add lots of examples for the `alb`, `asg-rolling-deploy`, `mysql`, and `hello-world-app` modules

## Notes on best practice

A great practice to follow when developing a new module is to write the example code first, before you write even a line of module code.

- If you begin with the implementation, it’s too easy to become lost in the implementation details, and by the time you resurface and make it back to the API, you end up with a module that is unintuitive and difficult to use.
- On the other hand, if you begin with the example code, you’re free to think through the ideal user experience and come up with a clean API for your module and then work backward to the implementation.
- Because the example code is the primary way of testing modules anyway, this is a form of Test-Driven Development (TDD)
