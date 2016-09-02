-module(philosopher).
-export([start/5, dreaming/5]).

start(Hungry, Right, Left, Name, Ctrl) ->
	spawn_link(philosopher, dreaming, [Hungry, Right, Left, Name, Ctrl]).

dreaming(0, _, _, Name, Ctrl) ->
	io:format("~s is done eating!~n", [Name]),
	Ctrl ! done;

dreaming(Hungry, Right, Left, Name, Ctrl) ->
	io:format("~s is dreaming..~n", [Name]),
	Time = 500+random:uniform(500),
	timer:sleep(Time),
	Right ! {request, self()},
	Left ! {request, self()},
	waiting(Hungry, Right, Left, Name, Ctrl).

waiting(Hungry, Right, Left, Name, Ctrl) ->
	io:format("~s is waiting..~n", [Name]),
	receive
		{granted, From1} ->
			io:format("~s has received a chopstick!~n", [Name]),
			receive
				{granted, From2} ->
					io:format("~s has received a second chopstick!~n", [Name]),
					eating(Hungry, Right, Left, Name, Ctrl)
			end
	end.

eating(Hungry, Right, Left, Name, Ctrl) ->
	io:format("~s is eating..~n", [Name]),
	Time = 500+random:uniform(500),
	timer:sleep(Time),
	Right ! returned,
	Left ! returned,
	io:format("~s has returned two chopsticks!~n", [Name]),
	dreaming(Hungry-1, Right, Left, Name, Ctrl).