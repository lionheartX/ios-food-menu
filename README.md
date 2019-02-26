# ios-food-menu
## Features
1. CoreData background context and main context support
2. tableView batch updates
3. uses SQLite for CoreData store type in main app, uses In-Memory storage in unit tests for performance
4. swipe right on an item to edit/delete it

## Assumptions
1. food items are always sorted alphabetically for simplicity

## Fixes after submission (on develop branch)
1. Cascading deletion 
2. Adding food items with duplicate names is allowed, images is stored on filepath by hashValue
3. Deleting CoreData objects also removes any local image files that are associated (TODO)
