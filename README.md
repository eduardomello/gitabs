# Gitabs

Gitabs is a conclusion project for Computer Science Course at UFRGS (Federal University of Rio Grande do Sul, Brazil).

It's main objective is to store meta-data related to a project on the same repository. Using different branches and making use of parentship of commits to create cause-effect relations.

## Overview

Any project has lots of information that guides the creation of the final product. It might be the project scope or some tasks a colaborator has to get done. Usually this data exists in external tools and colaborators have to manually relate them to the files they actually crafted.

Even if the process of updating these tools are perfect and every tool is up to date, sometimes colaborators feel that these tools is lacking on options. It does not portraits their real world accurately.

### Meta-data

In gitabs, every repository can have its own format of meta-data. Using json-schema files repository managers can define how they want to store meta-data and they can change that schema as the project goes without losing previous data. Meta-data is then stored and validated based on the predefined schema. 


### Meta-branches

Any type of o meta-data schema results on a branch named after its schema. Git provides that history of changes is correctly maintened.


### Workspaces

Workspaces is where the project is actually stored. It's just like any branch we are used to on git. The difference is that gitabs let you relate meta-branches to specific parts of that branch so you can easily see what motivated that commit.

### CLI

Gitabs will have a command line interface to provide the tools for getting the previous items working

### API

Gitabs will have a REST API in order to build different interfaces with it.


## Development

Development will be done in Ruby. After some weeks of initial researches I settled on a couple of gems I will be using:

- Rugged: https://github.com/libgit2/rugged
- Minigit: https://github.com/3ofcoins/minigit
- Thor: https://github.com/erikhuda/thor
- Sinatra: https://github.com/sinatra/sinatra/
- RSpec: http://rspec.info/

I'm using the concept of gitabs to guide my development. For that I created a branch called user_story which stores user stories that I've written for the project. Based on these Stories I will be using TDD throughout the development process.


