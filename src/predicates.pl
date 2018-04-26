isTeam(Team):- team(Team,_).
% This is used in my predicates. Extraction of team names from team(teamName,Location) is done here. 

allTeams(List,Number) :- findall(Team,isTeam(Team),AllTeams), permutation(AllTeams,List), length(AllTeams,Number).
% This is for finding all permutations of all teams.
% Number is the number of all teams. List holds all teams in a list.
% First I construct a list AllTeams containing all teams in the given order in predicates. 
% Then I find all permutations of AllTeams list into List.
% I compute the length of AllTeams to find Number.

wins(Team,Week,List,Number) :- findall(OtherTeam,(match(CurWeek,Team,Score1,OtherTeam,Score2),Score1>Score2,CurWeek=<Week),List1),findall(OtherTeam2,(match(CurWeek2,OtherTeam2,Score3,Team,Score4),Score4>Score3,CurWeek2=<Week),List2),append(List1,List2,List),length(List,Number).
% WINS:
% Team(constant), Week(constant),List- list of the teams that satisfy the query,Number - Number of elements in List
% * Here I find all match predicates and extract OtherTeam variable's value.
% * OtherTeam holds the team defeated by Team, i.e given team.
% * Conditions in findall: 
% 1-Compare scores and find matches winned by the Team. 
% 2-Also compare CurWeek with Week to find matches within (Week's value) weeks.
% * Find home matches and away matches seperately and append the results.
% * Finally, compute Number with length predicate.
losses(Team,Week,List,Number) :- findall(OtherTeam,(match(CurWeek,Team,Score1,OtherTeam,Score2),Score1<Score2,CurWeek=<Week),List1),findall(OtherTeam2,(match(CurWeek2,OtherTeam2,Score3,Team,Score4),Score4<Score3,CurWeek2=<Week),List2),append(List1,List2,List),length(List,Number).
% LOSSES:
% Team(constant), Week(constant),List- list of the teams that satisfy the query,Number - Number of elements in List
% * Here I find all match predicates and extract OtherTeam variable's value.
% * OtherTeam holds the team wins Team, i.e given team.
% * Conditions in findall: 
% 1-Compare scores and find matches defeated by the Team. 
% 2-Also compare CurWeek with Week to find matches within (Week's value) weeks.
% * Find home matches and away matches seperately and append the results.
% * Finally, compute Number with length predicate.
% * Note that only difference with wins is comparison of the scores. 
draws(Team,Week,List,Number) :- findall(OtherTeam,(match(CurWeek,Team,Score1,OtherTeam,Score2),Score1=:=Score2,CurWeek=<Week),List1),findall(OtherTeam2,(match(CurWeek2,OtherTeam2,Score3,Team,Score4),Score4=:=Score3,CurWeek2=<Week),List2),append(List1,List2,List),length(List,Number).
% DRAWS:
% Team(constant), Week(constant),List- list of the teams that satisfy the query,Number - Number of elements in List
% * Here I find all match predicates and extract OtherTeam variable's value.
% * OtherTeam holds the team drawed with Team, i.e given team.
% * Conditions in findall: 
% 1-Compare scores and find matches Team draws. 
% 2-Also compare CurWeek with Week to find matches within (Week's value) weeks.
% * Find home matches and away matches seperately and append the results.
% * Finally, compute Number with length predicate.
% * Note that only difference with wins or losses is comparison of the scores. 

scored(Team,Week,Score):- findall(Score1,(match(CurWeek,Team,Score1,_,_),CurWeek=<Week),List1),findall(Score2,(match(CurWeek,_,_,Team,Score2),CurWeek=<Week),List2),append(List1,List2,List),listsum(List,Score).
% SCORED:
% * Score is the total number of scores scored by the Team up to week Week.
% * Here we only extract score of the Team from match predicates
% * Only extra condition in findall is week comparison
% * Find home matches and away matches seperately and append the results.
% * Finally, compute Score with listsum predicate that I wrote before.
conceded(Team,Week,Score):- findall(Score1,(match(CurWeek,Team,_,_,Score1),CurWeek=<Week),List1),findall(Score2,(match(CurWeek,_,Score2,Team,_),CurWeek=<Week),List2),append(List1,List2,List),listsum(List,Score).
% CONCEDED:
% * Score is the total number of scores conceded by the Team up to week Week.
% * Here we only extract score of the OtherTeam from match predicates
% * Only extra condition in findall is week comparison
% * Find home matches and away matches seperately and append the results.
% * Finally, compute Score with listsum predicate that I wrote before.
average(Team,Week,Average):- scored(Team,Week,Scored), conceded(Team,Week,Conceded), Average is Scored-Conceded.
% This computes average of a team up to a week. Average means goals scored minus goal conceded.
% I used last 2 predicates to find scored and conceded goals of a team then subtract them to get the average.
order(List,Week):- findall(Average-Team,(isTeam(Team),average(Team,Week,Average)),AllTeams),keysort(AllTeams,ReverseSorted),reverse(Sorted,ReverseSorted),findall(Team2,member(_-Team2,Sorted),List).
% This predicate shows the ordered status of the teams in week Week. List is the returned ordered list.
% First I form key value pairs. Average is averages of the teams and it is the key whereas Team is team name and value.
% AllTeams holds key value pairs. Then I call keysort which sorts according to the keys.
% This sorts but in reverse order, so I reverse ReverseSorted into Sorted.
% Sorted includes key value pairs I need only teams. Therefore, I extract team names from Sorted using findall predicate.
% I used member predicate with findall function to transfer all the members into List.
topThree([T1,T2,T3],Week):- order([T1,T2,T3|_],Week).
% This predicate finds top three teams in week Week. 
% T1 is the first, T2 is the second, T3 is the third team.
% I basically take the first three elements of the list returned by order predicate.

listsum([], 0).
% base case
listsum([Head | Tail], Total) :-
listsum(Tail, Sum),
Total is Head + Sum.
% This predicate sums all the element in a list.
% empty list sum is 0