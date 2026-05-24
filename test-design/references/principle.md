# The Test Contravariance Principle

Source: Uncle Bob Martin, "Test Contravariance" (2017)

## The core problem

When test structure mirrors production structure (one test file per class, one test method per production method), tests become *coupled to the implementation*, not to the behavior. This means:

- Renaming a class breaks tests even if nothing functionally changed.
- Splitting one class into two forces you to restructure test files.
- Merging two modules invalidates a test file's reason to exist.

This coupling prevents true refactoring, which requires keeping tests green throughout.

## The principle

> Tests should be anchored to **stable public behavior**, not to **internal structure**.

Production code becomes more generic over time (handles more cases, more abstraction). Tests become more specific over time (cover more edge cases, concrete scenarios). They move in opposite directions — hence "contravariant."

## What this means in practice

| Coupled (avoid)                          | Behavior-anchored (prefer)                        |
|------------------------------------------|---------------------------------------------------|
| `test_DataLoader.py` per `DataLoader.py` | `test_data_ingestion.py` covering the pipeline    |
| `test_Trainer_build_optimizer()`         | `test_training_reduces_loss_over_epochs()`        |
| Tests import private `_helpers`          | Tests call the public `train()` or `predict()`    |
| One test class per production class      | One test file per user-facing capability          |

## The "act of generalizing is decoupling"

When you extract private methods into classes behind a public API, those internal classes become untestable directly — and that's correct. They're validated through the original test's public interface. The API narrows; the tests get more specific. This is the contravariant movement.
