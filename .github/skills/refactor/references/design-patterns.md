# Design Patterns for Refactoring

Reference for structural patterns useful when the refactoring goal involves replacing conditional logic or restructuring validation flows. Use these after identifying which pattern fits the code shape.

## Strategy Pattern

Replace conditional chains with polymorphic dispatch. Each branch becomes a strategy object.

```diff
# Before: Conditional logic
- function calculateShipping(order, method) {
-   if (method === 'standard') {
-     return order.total > 50 ? 0 : 5.99;
-   } else if (method === 'express') {
-     return order.total > 100 ? 9.99 : 14.99;
+   } else if (method === 'overnight') {
+     return 29.99;
+   }
+ }

# After: Strategy pattern
+ interface ShippingStrategy {
+   calculate(order: Order): number;
+ }
+
+ class StandardShipping implements ShippingStrategy {
+   calculate(order: Order) {
+     return order.total > 50 ? 0 : 5.99;
+   }
+ }
+
+ class ExpressShipping implements ShippingStrategy {
+   calculate(order: Order) {
+     return order.total > 100 ? 9.99 : 14.99;
+   }
+ }
+
+ class OvernightShipping implements ShippingStrategy {
+   calculate(order: Order) {
+     return 29.99;
+   }
+ }
+
+ function calculateShipping(order: Order, strategy: ShippingStrategy) {
+   return strategy.calculate(order);
+ }
```

## Chain of Responsibility

Replace nested validation or branching with a chain of validators. Each handler passes or short-circuits.

```diff
# Before: Nested validation
- function validate(user) {
-   const errors = [];
-   if (!user.email) errors.push('Email required');
+   else if (!isValidEmail(user.email)) errors.push('Invalid email');
+   if (!user.name) errors.push('Name required');
+   if (user.age < 18) errors.push('Must be 18+');
+   if (user.country === 'blocked') errors.push('Country not supported');
+   return errors;
+ }

# After: Chain of responsibility
+ abstract class Validator {
+   abstract validate(user: User): string | null;
+   setNext(validator: Validator): Validator {
+     this.next = validator;
+     return validator;
+   }
+   validate(user: User): string | null {
+     const error = this.doValidate(user);
+     if (error) return error;
+     return this.next?.validate(user) ?? null;
+   }
+ }
+
+ class EmailRequiredValidator extends Validator {
+   doValidate(user: User) {
+     return !user.email ? 'Email required' : null;
+   }
+ }
+
+ class EmailFormatValidator extends Validator {
+   doValidate(user: User) {
+     return user.email && !isValidEmail(user.email) ? 'Invalid email' : null;
+   }
+ }
+
+ // Build the chain
+ const validator = new EmailRequiredValidator()
+   .setNext(new EmailFormatValidator())
+   .setNext(new NameRequiredValidator())
+   .setNext(new AgeValidator())
+   .setNext(new CountryValidator());
```
