-module(record01).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").


-record(record01, {
  value = 0 :: non_neg_integer()  
}).


test_1() ->
  Port = erlang:open_port({spawn_executable, "../c_src/record01"}, [{packet,4},{arg0, "record01"},binary,exit_status]),

  erlang:port_command(Port, erlang:term_to_binary(#record01{value = 5})),
  receive
    {Port, {data, Data}} ->
      Term = erlang:binary_to_term(Data),
      ?assertEqual(#record01{value = 47}, Term);
    {Port, Else} ->
      error(Else);
    Else ->
      error(Else)
  after
    1000 -> error(timeout)
  end,
  erlang:port_close(Port).

