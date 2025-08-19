If you would like to submit a request to have a customized template please submit a request via ADO ticket/request <a href="https://dev.azure.com/BECU/HUB/_workitems/create/Product%20Backlog%20Item?templateId=8a0cb639-881d-4845-b85d-3e7665f7a0a0&ownerId=5d9a08b6-633a-4031-85f5-8ef175fc8273" target="_blank">HERE</a>

Or each out to @<Jason Duer> for any assistance in getting set up

Extension has been customized to support any child work item type ( TASK, BUT, PBI, FEATURES) by calling out the type in the config of the template


# Create linked sub tasks to your parent work item 
  

Use this extension to enable creating child tasks from an existing work items based on a template. Automatically you will be able to generate sub work items under a parent one and with the proper links

  
## General information

  

There are two things to know to be comfortable using this extension.

  

- How to setup a "template" of work items

  

- How to create the sub linked work items

  

### How to setup a template of tasks

  

Go in the extension setup, which is per project. As you can see below, you have a "JSON" file to determine this. The easiest way is to copy a section and dubplate it and then modify it. In the Azure DevOps Json editor, on the header bar, you can click on "Tree" or "Text". Go to the Text mode and you can copy and paste values, to add Child items to the template.

![setup_screen.png](/.attachments/setup_screen-dbd9f079-1a85-41bf-8392-47fa13c33489.png)

  

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
  
in this example the above shows up as Dev Activity template
![image.png](/.attachments/image-ec580d02-c9a7-46c3-9976-b1fa9d67336a.png)

and create 2 Task child work items titled
1.Code Review
2.Dev Analysis and Development

and activity types defined and inherits the parent work items iteration and area path's

Note: You can setup parent fields in the sub tasks like the area and iteration paths. By this way, when the system will generate the sub-tasks, you will be able to use "parent task" variables, like the original title, ID, url ... In the value field, as in the sample, when you specify a field, it will be the parent's value.

  

### How to create the linked sub tasks

  

When you are on a work item, just go in the options and click on add tasks as below.
![image.png](/.attachments/image-aa98a500-1746-4958-aa5d-7fc8146b5c82.png)

then select as many templates you wish to apply, please note that templates could be a set any number of work items and types so insure your select the Template of child items appropriately to its parent child hierarchy

![image.png](/.attachments/image-1facb28b-4e3e-4239-a7d8-222cad66414c.png)
you should then see your Child items linked to the Parent work item

  


