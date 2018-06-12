%% @doc
%% A simple starter template for basic erlang applications, to run:
%% rebar3 compile
%% rebar3 shell
%% > {{name}}:start_link([{your, args}, in, here, 123]).
-module({{name}}).

-include("{{name}}.hrl").

-export([
         start_link/1
        ]).


-record(state, {
    % Arguments we want to pass to our main loop, feel free to change
    args = [] :: term(),
    % Parent process to inform when we're finished
    parent    :: pid(),
    our_constant :: integer()
}).

-spec start_link(Args :: term()) -> ok.
start_link(Args) ->
    % You can modify / validate / do whatever with your state first if you need to
    % The MY_CONSTANT macro comes from our include file
    Self = self(),
    State = #state{args = Args, our_constant = ?MY_CONSTANT, parent = Self},
    
    % Starts a new process for our application
    spawn_link(fun() -> app_loop(State) end),

    % Wait for the quit message from the main loop, this is so our app doesn't just
    % stop right away
    receive
        quit ->
            ok
    end.

% Simple application loop, waits for "quit" to be entered to exit
-spec app_loop(State :: #state{}) -> any().
app_loop(State = #state{args = Args, parent = Parent}) ->
    io:format("Hello world! Our args are: ~p~n", [Args]),
    % wait for a key press...
    Reply = io:get_line("Type \"quit\" to exit: "),

    case Reply of
        "quit\n" ->
            % Tell the parent we're quitting, this process dies after this message
            Parent ! quit;
        Else ->
            io:format("You said: ~s~n", [Else]),

            % and loop back around
            app_loop(State)
    end.

