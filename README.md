# MC

Missionaries and Cannibals implementation in elixir.

## Installation

To generate docs, install dependencies by running
  ```
  mix deps.get
  ```
To generate documentation
  ```
  mix docs
  ```


## Running

MC.server can receive __start__ through the observer interface.

Alternatively it can be started inside iex by starting it with
  ```
  mix -S iex
  ```
And then calling the start state function
  ```
  iex(1)> MC.start_state
  ```
