We decided to add a new  _Deploy Java Archive_ step type.

The alternative was to modify the existing _Deploy a Package_ step to work with Java packages.  

The benefits of adding a new step type:

- Discoverability: It is immediately obvious that it will work with Java packages. 
- We are free to add conventions and features relevant to Java archives without concern as to how the will impact existing packages.
- It fits with our direction of more specific steps, rather than fewer generic steps.