transition("CLOSED",      "APP_PASSIVE_OPEN", "LISTEN").
transition("CLOSED",      "APP_ACTIVE_OPEN",  "SYN_SENT").
transition("LISTEN",      "RCV_SYN",          "SYN_RCVD").
transition("LISTEN",      "APP_SEND",         "SYN_SENT").
transition("LISTEN",      "APP_CLOSE",        "CLOSED").
transition("SYN_RCVD",    "APP_CLOSE",        "FIN_WAIT_1").
transition("SYN_RCVD",    "RCV_ACK",          "ESTABLISHED").
transition("SYN_SENT",    "RCV_SYN",          "SYN_RCVD").
transition("SYN_SENT",    "RCV_SYN_ACK",      "ESTABLISHED").
transition("SYN_SENT",    "APP_CLOSE",        "CLOSED").
transition("ESTABLISHED", "APP_CLOSE",        "FIN_WAIT_1").
transition("ESTABLISHED", "RCV_FIN",          "CLOSE_WAIT").
transition("FIN_WAIT_1",  "RCV_FIN",          "CLOSING").
transition("FIN_WAIT_1",  "RCV_FIN_ACK",      "TIME_WAIT").
transition("FIN_WAIT_1",  "RCV_ACK",          "FIN_WAIT_2").
transition("CLOSING",     "RCV_ACK",          "TIME_WAIT").
transition("FIN_WAIT_2",  "RCV_FIN",          "TIME_WAIT").
transition("TIME_WAIT",   "APP_TIMEOUT",      "CLOSED").
transition("CLOSE_WAIT",  "APP_CLOSE",        "LAST_ACK").
transition("LAST_ACK",    "RCV_ACK",          "CLOSED").

traverse(InitState, [], FinalState) :-
    FinalState = InitState.
traverse(InitState, [E|Es], FinalState) :-
    transition(InitState, E, NextState),
    traverse(NextState, Es, FinalState).

traverse_tcp_states(Events, FinalState) :-
    traverse("CLOSED", Events, FinalState),
    !.
traverse_tcp_states(Events, FinalState) :-
    FinalState = "ERROR".
