# Improving the step template submission process

_these are some notes from a conversation that happened at the start of 2018. Needs to be written up properly_

* process changes to submit via library, rather than github PR
* octopus gains a button to submit
  - only shown if library sync is on?
  - publish button checks to see if its different before lighting up
  - publish button is highlighted as a "call to action"
* library gains a submit page, which shows a diff
  - submitting validates id/version
  - some kind of psscriptanalyzer test
  - then creates a PR
* we split up the files in github, so the metadata/script/tests are stored separately
  - comms to and from octopus are still based on the combined version
* octopus gains a tab to show tests
  - tests are stored as a separate file in github
  - tests are stored in the combined json as an extra element
* follow a lot of the conventions of the asos StepTemplateCI
* we'd probably have to re-write the library in dotnet core, as its currently js only. (it'd need some server side stuff to interact with github)

* after github feed type is implemented, extend community library sync to support internal git repos (auto import?)

* octopus eventually gains a button to run tests (post workers?)
* library eventually gains a history, with diff
* library eventually gains the ability to handle script modules
* octopus gains the ability to import/export/publish script modules
