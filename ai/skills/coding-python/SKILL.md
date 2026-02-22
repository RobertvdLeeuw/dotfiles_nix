---
name: coding-python
description: Python coding style guide with functional patterns, dataclasses, type hints, logging best practices, and clean code principles
license: MIT
compatibility: opencode
metadata:
  language: python
  category: style-guide
---

# Core Philosophy

- Functional approach by default; use OOP only when you need multiple stateful instances
- Self-documenting code over comments - limit comments to TODOs, why explanations, and complex what/how when code can't explain itself
- Avoid single-use variables unless they serve as documentation (`meaningful_name = complex_expression` is good, `result = simple_call()` is not)
- Clean, minimal formatting - use `(thing)` not `(\n    thing\n)`
- Assert preconditions and let errors bubble up naturally

## Critical Rules

- **NEVER** use bare `python`, `pip`, or `poetry` commands
- **ALWAYS** use `uv`: `uv run`, `uv add`, `uv sync`
- **NEVER** catch-log-reraise without adding context
- **ALWAYS** read existing files before suggesting modifications
- **NEVER** use classes when functions or dataclasses would suffice

## Before You Code

1. Read the file to understand current state
2. Check for upstream/downstream dependencies that need updating
3. Verify assumptions about data structures and types
4. Assert preconditions rather than defensive checks

## Python Style

- Use dataclasses over classes when you just need data containers
- Type hints consistently, especially for function signatures and complex structures
- Factory functions for object creation: `def create_node(type, handler, context):`
- Context managers for resource management (DB sessions, file handles)
- Use async pragmatically - don't force it, but don't avoid it when it makes sense

## Database (SQLAlchemy/SQLModel)

- Always use Alembic for schema changes, never direct table creation in production code
- Clean model definitions with explicit relationships and indexes
- Database manager pattern for connection handling and configuration
- Separate models from business logic - models define schema, business logic uses them

## Error Handling & Logging

- Import logger: `from logger import get_logger`
- Create component logger: `log = get_logger("component.subcomponent")` (use hierarchical names: auth.google, api.external, etc.)
- Check logger.py COMPONENT_LEVELS dict for existing components if unsure
- Log levels: `log.debug()`, `log.info()`, `log.warning_low()`, `log.warning()`, `log.warning_recovery()`, `log.error()`, `log.critical()`
- For exceptions: use `log.exception("message")` instead of traceback.format_exc()
- Add `@log.catch(reraise=True)` to boundary functions (API handlers, background jobs, transaction boundaries)
- Don't add @catch to internal helpers or hot-path functions
- Handle known exceptions explicitly with try/except, let @catch be safety net for unknown errors
- Add context: `log.bind(request_id=id, user_id=uid)` or `with logger.contextualize(key=val):`
- Component hierarchy: set "auth" level to apply to "auth.google", "auth.azure", etc.
- Assert preconditions rather than defensive if-checks when assumptions should hold
- Only use defensive checks like `thing_passed.id != None` when sure they haven't been asserted/checked yet

## Code Organization

- Keep modules focused - integration modules for external services, models for schema
- Separate pure functions from stateful operations
- Group related functionality in modules, not classes unless you need instances

## Testing

- Mock external dependencies cleanly - create dedicated mock modules
- Use property-based testing for invariants and edge cases

## Anti-Patterns

**❌ Don't:**

```python
# Unnecessary variable
result = func()
return result


# Class for single use
class NodeFactory:
    def create(self, type, handler):
        return Node(type, handler)


# Catch-log-reraise without context
try:
    do_thing()
except Exception as e:
    log.error(f"Error: {e}")
    raise

# Comments that restate code
# Increment counter by 1
counter += 1
```

**✅ Do:**

```python
# Direct return
return func()


# Factory function
def create_node(type: str, handler: Callable) -> Node:
    return Node(type=type, handler=handler)


# Add context when reraising
try:
    do_thing()
except Exception as e:
    log.error(f"Failed to process item {item_id}", exc_info=True)
    raise

# Self-documenting code
processed_count += 1
```
