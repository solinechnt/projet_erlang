-module(mini).

-export([start/0, client/1]).

 

start() ->

                Pid = spawn(mini, client, [self()]),

                loop_receive(Pid).

               

loop_receive(Pid) ->     

                receive

                               {Pid, 1} -> io:format("                      SERVEUR RECU Bonjour: SERVEUR DIT BONJOUR !!!!~n"),

                                               loop_receive(Pid);

                               {Pid, 3} -> io:format("                      SERVEUR RECU FIN: SERVEUR DIT AU REVOIR !!!!~n");

                               {Pid, Message} -> io:format("                      SERVEUR RECU: ~p~n", [Message]),

                                               loop_receive(Pid)

                end.

               

               

client(Pid) ->

    afficher_menu(),

    Choice = lire_choix(),

    traiter_choix(Pid, Choice).

 

afficher_menu() ->

    io:format("~n====== BANQUE EN LIGNE ======~n"),

    io:format("1 - Consulter mon compte~n"),

    io:format("2 - Effectuer un dépôt~n"),

    io:format("3 - Effectuer un retrait~n"),
    
    io:format("4 - Quitter~n"),

    io:format("==================~n").

    

lire_choix() ->

  case io:read("Votre choix : ") of

     {ok,Choix} -> Choix;

     eof -> io:format("lecture fin de fichier~n"), eof;

     {error, Reason} -> io:format("Erreur~p ~n", [Reason])

  end.

 

traiter_choix(P, 3) ->

    io:format("CLIENT dit : Au revoir !~n"),

    P ! {self(), 3};

 

traiter_choix(P, 1) ->

    io:format("CLIENT dit : Bonjour !~n"),

    P ! {self(), 1},

    client(P);

 

traiter_choix(P, 2) ->

    io:format("CLIENT dit : Lu : 2 ~n"),

    P ! {self(), "Choix 2 commandé par client"},

    client(P);

 

traiter_choix(P,_) ->

    io:format("Choix invalide~n"),

    client(P).
