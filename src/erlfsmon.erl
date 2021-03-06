-module(erlfsmon).
-export([subscribe/0, known_events/0, start_logger/0]).

subscribe() ->
    gproc:reg({p, l, {erlfsmon, file_event}}).

known_events() ->
    gen_server:call(erlfsmon, known_events).

start_logger() ->
    spawn(fun() -> subscribe(), logger_loop() end).

logger_loop() ->
    receive
        {_Pid, {erlfsmon, file_event}, {Path, Flags}} ->
            error_logger:info_msg("file_event: ~p ~p~n", [Path, Flags]);
        _ -> ignore
    end,
    logger_loop().
