-module(record2ei_tests).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").


record_gen_test_() ->
  Files = [filename:basename(F, ".erl") || F <- filelib:wildcard("../test/*.erl"), not lists:suffix("_tests.erl", F)],

  Spec = [begin
    F_ = list_to_atom(F),
    TestFunctions = [Fun || {Fun,0} <- F_:module_info(exports),
      lists:prefix("test_", atom_to_list(Fun))],

    {F, {setup,
      fun() -> setup(F) end,
      fun(_) -> teardown(F) end,
      [{atom_to_list(Fun), fun F_:Fun/0} || Fun <- TestFunctions]
    }}
  end || F <- Files],
  Spec.




setup(F) ->
  os:cmd("rm -rf ../c_src"),
  os:cmd("../record2ei.erl "++F++".erl ../c_src"),
  file:write_file("../c_src/rebar.config", [
    io_lib:format("~100p.~n", [{port_specs, [{"c_src/"++F, ["c_src/"++F++".c", "c_src/"++F++"_ei.c"]}]}])
  ]),
  os:cmd("cp ../test/main.c ../test/"++F++".c ../c_src/"),
  A = os:cmd("(cd ..; ./rebar -C c_src/rebar.config -v compile)"),
  case file:read_file_info("../c_src/"++F) of
    {ok, _} -> ok;
    _ -> ?debugFmt("compile error: ~s~n",[A])
  end,
  ok.


teardown(_F) ->
  ok.



