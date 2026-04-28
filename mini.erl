-module(mini).

-export([start/0, client/1]).

 

start() ->

                Pid = spawn(mini, client, [self()]),

                loop_receive(Pid, 0).

               
 
loop_receive(Pid, Solde) ->     
    receive
        {Pid, consulter} ->
            io:format("SERVEUR RECU: Solde = ~p EUROS~n", [Solde]),
            loop_receive(Pid, Solde);
        {Pid, deposer, Montant} ->
            NvSolde= Solde + Montant,
            io:format("SERVEUR RECU: Depot : ~p EUROS ; Solde = ~p EUROS~n", [Montant, NvSolde]),
            loop_receive(Pid, NvSolde);
        {Pid, retirer, Montant} when Montant =< Solde ->
            NvSolde= Solde - Montant,
            io:format("SERVEUR RECU: Retrait : ~p EUROS ; Solde = ~p EUROS~n", [Montant, NvSolde]),
            loop_receive(Pid, NvSolde);
        {Pid, retirer, Montant} when Montant > Solde ->
            io:format("SERVEUR RECU: retrait refuse car solde : ~p ~n", [Solde]),
            loop_receive(Pid, Solde);
        {Pid, quitter} ->
            io:format("SERVEUR RECU: au revoir~n")
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



traiter_choix(P, 4) ->

    io:format("CLIENT dit : Au revoir !~n"),

    P ! {self(), quitter};

 

traiter_choix(P, 1) ->

    io:format("CLIENT dit : je souhaite consulter mon solde~n"),

    P ! {self(), consulter},

    client(P);

 

traiter_choix(P, 2) ->

    io:format("CLIENT dit : je souhaite deposer de l'argent ~n"),

    Montant = saisie_montant("Montant a deposer : "),

    P ! {self(), deposer, Montant},

    client(P);

traiter_choix(P, 3) ->

    io:format("CLIENT dit : je souhaite retirer de l'argent ~n"),

    Montant = saisie_montant("Montant a retirer : "),

    P ! {self(), retirer, Montant},

    client(P);

traiter_choix(P,_) ->

    io:format("Choix invalide~n"),

    client(P).

saisie_montant(Saisie) ->
    case io:fread(Saisie, "~d") of
        {ok, [Montant]} when Montant > 0 -> Montant;
        _ ->
            io:format("erreur lors de la saisie, veuillez saisir un entier"),
            saisie_montant(Saisie)
    end.
