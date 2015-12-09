# Elixir notebook

Quick Elixir recipes / experiments that may or may not show you how to do things
quick, easy, dirty and totally unprofessional.

## 1-singleton-genserver

Step between Elixir application running on one node and running on multiple nodes
is hard, because some processes should run only once, not on every node. This example
shows an easy and dirty hack to do that.

Tags: distributed, multiple nodes
