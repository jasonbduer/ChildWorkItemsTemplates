# Work Item Templates
[![donate](https://img.shields.io/badge/donate-paypal-blue)](https://www.paypal.com/donate/?hosted_button_id=S9C25ZLQNLTLW)

## Create linked sub work items to your parent work item 
  

Use this extension to enable creating child work items from any type including custom work item types by calling out your work item type name under "type:" with in the json template
from an existing work items based on a template. Automatically you will be able to generate sub work items under a parent one and with the proper links

  
## General information

  

There are two things to know to be comfortable using this extension.

  

- How to setup a "template" of work items

  

- How to create the sub linked work items

  

### How to setup a template of tasks

  

Go in the extension setup, which is per project. As you can see below, you have a "JSON" file to determine this. The easiest
way is to copy a section and dubplate it and then modify it. In the Azure DevOps Json editor, on the header bar, you can click on "Tree" or "Text".
Go to the Text mode and you can copy and paste values, to add Child items to the template.

![setup_screen](https://github.com/jasonbduer/ChildWorkItemsTemplates/raw/main/doc/project_setup.png)

  

Example json format of a single section that creates 2 tasks
```json
{
  "name": "Dev Activity",
  "tasks": [
    {
      "name": "Code Review",
      "fields": [
        {
          "name": "System.Title",
          "value": "Code Review"
        },
        {
          "name": "System.IterationPath",
          "value": "{System.IterationPath}"
        },
        {
          "name": "System.AreaPath",
          "value": "{System.AreaPath}"
        },
        {
          "name": "Microsoft.VSTS.Common.Priority",
          "value": "{Microsoft.VSTS.Common.Priority}"
        },
        {
          "name": "Microsoft.VSTS.Common.Activity",
          "value": "Development"
        }
      ],
      "type": "Task"
    },
    {
      "name": "Dev Analysis and Development",
      "fields": [
        {
          "name": "System.Title",
          "value": "Dev Analysis and Development"
        },
        {
          "name": "System.IterationPath",
          "value": "{System.IterationPath}"
        },
        {
          "name": "System.AreaPath",
          "value": "{System.AreaPath}"
        },
        {
          "name": "Microsoft.VSTS.Common.Activity",
          "value": "Development"
        }
      ],
      "type": "Task"
    }
  ]
}
```
  
In this example the above shows up as Dev Activity template
and create 2 Task child work items titled
1.Code Review
2.Dev Analysis and Development

and activity types defined and inherits the parent work items iteration and area path's

Note: You can setup parent fields in the sub tasks like the area and iteration paths. By this way, when the system will generate the sub-tasks, you
will be able to use "parent task" variables, like the original title, ID, url ... In the value field, as in the sample, when you specify a field, it will be the parent's value.

  

### How to create the linked sub tasks

  

When you are on a work item, just go in the options and click on add tasks as below.

![Add_tasks](https://github.com/jasonbduer/ChildWorkItemsTemplates/raw/main/doc/Add_tasks.png)

then select as many templates you wish to apply, please note that templates could be a set any number of work items and types so insure your select
the Template of child items appropriately to its parent child hierarchy

![SelectTemp](https://github.com/jasonbduer/ChildWorkItemsTemplates/raw/main/doc/SelectTemp.png)

you should then see your Child items linked to the Parent work item

  


