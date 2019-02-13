# ios-food-menu
## Features
1. CoreData background context and main context support
2. tableView batch updates
3. uses SQLite for CoreData store type in main app, uses In-Memory storage in unit tests for performance
4. swipe right on an item to edit/delete it

## Limitations (due to time constraint)
1. food items are always sorted alphabetically for simplicity
2. adding food items with duplicate names will cause a bug where images get reset, solution is either to prevent duplicate names or to change how images are saved in FilePath
