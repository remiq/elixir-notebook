# 1-singleton-genserver

Step between Elixir application running on one node and running on multiple nodes
is hard, because some processes should run only once, not on every node. This example
shows an easy and dirty hack to do that.

## Pros

- easy to implement
- fast way to cross "multi-node chasm"

## Cons

- prone to failure
- not suitable for Proper Erlang Application (tm)

## Idea

We have an application that contains two services:

- AbeVigoda - external service that reports if he's dead
- AbeDVDPrice - service setting price of dvd

AbeVigodaAPI allows us to check once per minute. When we were using our application
on one node, it was easy. Now we need to scale our DVD Price service to multiple nodes.
If we try to run same application on two nodes, AbeVigodaAPI will be called twice
per minute. We will solve the problem with having one AbeVigoda process per cluster
and one AbeDVDPrice per node.

You will run same application on multiple nodes and the only difference between
them would be virtual machine configuration and application configuration.

One of the nodes will be named `master node` while all other nodes will be named
`slave nodes`. This means there will be single `master node` and every node will
know from application configuration who is `master` and where is it.

Master node's supervisor tree will contain AbeVigoda and AbeDVDPrice, while
slave node's supervisor trees will contain only AbeDVDPrice.

AbeDVDPrice module will always ask AbeVigoda process on master node.

Slave node will not start, if master node is not online.

## Usage

Start master node using this command:

    $ iex --sname "master" -S mix

It starts fine, you can check how it looks using observer

    iex(master@NEWBORN)1> :observer.start

Pick Applications > "singleton" and see how application supervisor started both
processes. Try to get price of dvd:

    iex(master@NEWBORN)2> Singleton.AbeDVDPrice.get
    1000

Looks ok, just as you would expect with one node. Now start one slave:

    $ iex --sname "slave1" -S mix

Test if pricing works

    iex(slave1@NEWBORN)1> Singleton.AbeDVDPrice.get
    1000

Now run observer to see only AbeDVDPrice process:

    iex(slave1@NEWBORN)2> :observer.start

## Code

Please check following files:

- `config/config.exs` we define name of master node here.
- `lib/singleton.ex` - starting application is conditional based on config and
  node name
- `lib/singleton/*.ex` - both GenServers use `@pid` property to set where
  client-side functions should call. 

## Notes

If you are using this code on single physical computer, you can use `--sname "master"`.
But when you try to use different computers, you will need to use long names `--name "master@node1.acme.com"`

If used example feels pointless to you, imagine AbeDVDPrice process accesses a few
different singleton services to calculate price and it is not interested how
often state of variables changes.

If you are using exrm to release your software, you will need to change config AFTER
release on every node you run ONCE. Correct file to change is releases/$VER/sys.config
