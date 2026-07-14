# Python Style Rules

Priority-ordered rules for Python code quality. Reference for `python-quality` Branch B — Expert review.

## Correctness (CRITICAL)

### Mutable Default Arguments
```python
# Wrong
def add_item(item, items=[]):  # BUG: [] shared across calls
    items.append(item)

# Right
def add_item(item: str, items: list[str] | None = None) -> list[str]:
    if items is None:
        items = []
    items.append(item)
    return items
```

### Error Handling
```python
# Wrong
try:
    result = risky_operation()
except:
    pass

# Right
try:
    config = json.loads(config_file.read())
except json.JSONDecodeError as e:
    logger.error(f"Invalid JSON: {e}")
    config = get_default_config()
except FileNotFoundError:
    config = get_default_config()
```

## Type Safety (HIGH)

### Type Hints
```python
# Wrong
def get_user(id):
    return users.get(id)

# Right
def get_user(user_id: int) -> Optional[Dict[str, Any]]:
    return users.get(user_id)
```

### Dataclasses
```python
# Wrong — manual __init__, __repr__, __eq__
class User:
    def __init__(self, id, name, email): ...

# Right
@dataclass
class User:
    id: int
    name: str
    email: str
```

## Performance (HIGH)

### List Comprehensions
```python
# Wrong
squares = []
for x in range(10):
    squares.append(x ** 2)

# Right
squares = [x ** 2 for x in range(10)]
evens = [x for x in range(20) if x % 2 == 0]
```

### Context Managers
```python
# Wrong
f = open('file.txt')
data = f.read()
f.close()

# Right
with open('file.txt') as f:
    data = f.read()
```

## Style (MEDIUM)

### PEP 8
```python
# Wrong
def CalculateTotal(itemPrice,qty):
  return itemPrice*qty

# Right
def calculate_total(item_price: float, quantity: int) -> float:
    return item_price * quantity
```

### Docstrings
```python
def process_user_data(data: Dict[str, Any], config: ProcessConfig) -> ProcessResult:
    """Process user data according to configuration.

    Args:
        data: Raw user data with 'user_id' and 'email' keys.
        config: Processing configuration with transformations and rules.

    Returns:
        ProcessResult with transformed data and validation warnings.

    Raises:
        ValidationError: If required fields are missing.
    """
```
