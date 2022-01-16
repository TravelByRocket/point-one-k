# $0.1k
Now inteneded to make basic trade studies, it was originally developed to prioritize entrepreneurial projects in the style of the book ["The $100 Startup" by Chris Guillebeau](https://100startup.com)

## Data Model
Some of the properties were carried over from the Ultimate Portfolio App as I learned all of the intended nuances, while also adding all of the proprties I needed for my specific project. 

Summarized:

* `Project` has `[Item]` and `[Quality]`
* Item has `[Score]` (one for each `Quality`)

### `Project`
A Project is the highest level object created. It contains all of the scored Items a well as project-specific information and content that relates to all of the items together. 

#### Attributes
* `closed: Bool` (maybe change to `archive`)
* `color: String`
* `creationDate: Date` (only for learning/tutorial purposes, delete later)
* `detail: String` (notes or description)
* `title: String`

#### Relationships
* `items: [Item]`
* `qualities: [Quality]` (the criteria that each item will be scored on)

### `Item`
The items in a project are scored on the criteria determined when a project is created. Items are compared to each other based on total score. For example, when scoring business ideas, each item is an idea within a same project.

#### Attributes
* `completed: Bool`
* `creationDate: Date` (only for learning purposes, delete later)
* `note: String`
* `priority: Int16` (to group items when viewing a project, if desired)
* `title: String`

#### Relationships
* `project: Project` (the project this item belongs to)
* `scores: [Score]` (the score for each quality described in the Project)

### `Score`
The numeric score used for a quality

#### Attributes
* `value: Int16`

#### Relationships
* `item: Item`
* `quality: Quality`

### `Quality`
One attribute to score by. A set of qualities in a project are what each item will be scored by.

#### Attributes
* `note: String` (option to include scoring guidance nnotes)
* `title: String` (name)

#### Relationships
* `project: Project` (a project contains one set of qualities)
* `scores: [Score]` (the associated Score object for each item; this really only makes conceptual sense the other direction and this is the requisite reverse relationship)

### Delete Rules
#### Cascade
* Project &rarr; Items
* Project &rarr; Qualities
* Item &rarr; Scores
* Quality &rarr; Scores

#### Nullify
* All others