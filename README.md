
# SwiftDataCascadeBug

## Overview
This project demonstrates a potential bug in **SwiftData** where the behavior of the `deleteRule: .cascade` appears to depend on whether **autosave** is enabled for the `modelContext`. Specifically:
- When **autosave is enabled**, cascading deletions (deleting child objects when the parent is deleted) work as expected.
- When **autosave is disabled**, cascading deletions fail to propagate, even after explicitly calling `context.save()`.

## Features
This project provides:
1. **Tabs for Autosave and Manual Save Modes:** 
   - `Auto Save` mode: Uses SwiftData's autosave functionality.
   - `Manual Save` mode: Disables autosave, requiring explicit calls to save the `modelContext`.

2. **Folder and Item Management:**
   - Add folders and associate items with them.
   - Delete folders and observe whether associated items are correctly deleted (cascaded).

3. **Orphaned Item Cleanup:**
   - Identify and manually delete items that no longer have an associated folder.

## Reproducing the Issue
### Steps to Observe the Bug
1. Launch the app.
2. Switch to the `Manual Save` tab.
3. Add a folder and some items under that folder.
4. Delete the folder:
   - Expected: All associated items (children) should also be deleted because of the `.cascade` delete rule.
   - Actual: Items remain in the database unless they are explicitly deleted.

### Steps to Confirm Expected Behavior
1. Switch to the `Auto Save` tab.
2. Add a folder and some items under that folder.
3. Delete the folder:
   - Expected: All associated items (children) are deleted automatically, as defined by the `.cascade` delete rule.

## How It Works
The app is organized into two tabs: `Auto Save` and `Manual Save`. Each tab uses a separate `modelContainer` configured for its save mode.

### Key Classes
- **`Folder` Class:** Represents a folder that can contain multiple `Item` objects. It uses a `@Relationship` with `deleteRule: .cascade` to delete associated `Item` objects when a `Folder` is deleted.
- **`Item` Class:** Represents an item belonging to a folder. It maintains a reference to its parent `Folder`.

### Key Components
- **`isManuallySaved` Flag:** Determines whether autosave is enabled or manual saves are required.
- **`saveContextIfNecessary()` Method:** Saves the `modelContext` explicitly when autosave is disabled.

## Environment
- **Language:** Swift
- **Framework:** SwiftData
- **Xcode Version:** 15.1

## Known Behavior
### Expected Behavior
- The `.cascade` delete rule should ensure that when a `Folder` is deleted, all associated `Item` objects are deleted, regardless of whether autosave is enabled.

### Observed Behavior
- With autosave disabled (`Manual Save` mode), the `.cascade` delete rule is not respected, leaving orphaned `Item` objects in the database.

## Next Steps
### Reporting
If this behavior is confirmed to be a bug, consider submitting it via the Apple Feedback Assistant with this project as a reproducible example.

### Workarounds
As a temporary solution, manually delete associated child objects in `Manual Save` mode:
```swift
for item in folder.items {
    modelContext.delete(item)
}
modelContext.delete(folder)
saveContextIfNecessary()
```

### **Apple Feedback ID**
```plaintext
This issue has been reported to Apple using the Feedback Assistant.

Feedback ID: FB12345678
```

## License
This project is provided as a demonstration of a potential SwiftData issue. Feel free to use it as a reference for debugging or submitting feedback to Apple.
