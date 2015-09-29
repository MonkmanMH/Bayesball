library(Lahman)

data(SeriesPost)
head(SeriesPost)


library(dplyr)

ws_winner_table <- SeriesPost %>%
  mutate(teamIDwinner = as.character (teamIDwinner)) %>%
  filter(yearID > "1902", round == "WS") %>%
  group_by(teamIDwinner) %>%
  summarise(wincount = n()) %>%
  arrange(desc(wincount))
ws_winner_table

#

# Create table of current franchises
data("TeamsFranchises")
active_teams <- TeamsFranchises %>% 
  subset(active == "Y") %>%
  mutate(franchID = as.character(franchID)) %>%
  select(franchID, franchName)
active_teams
#
# create a list of the team names
data("Teams")
team_names <- Teams %>%
  filter(yearID > 1900, lgID != "FL") %>%
  mutate(teamID = as.character(teamID)) %>%
  mutate(franchID = as.character(franchID)) %>%
  select(yearID, teamID, franchID, name) %>%
  distinct(teamID) 
# add franchiseName from active_teams to team_names
team_names <- inner_join(team_names, active_teams, "franchID")
team_names
#
# add franchiseName to ws_winnertable
ws_winner_table2 <- ws_winner_table %>%
  full_join(team_names, by= c("teamIDwinner" = "teamID")) 
ws_winner_table2
# produce a summary table based on franchise name

# deal with the fact that some teams (note: not franchises!) have not won the World Series, and the 'wincount' variable in the table 'ws_winnertable' is an NA value
ws_winner_table3 <- ws_winner_table2 %>%
  filter(!is.na(wincount)) 

ws_winner_table4 <- ws_winner_table3 %>%
  group_by(franchID) %>%
  summarise(wincount = sum(wincount)) %>%
  arrange(desc(wincount))
ws_winner_table4

# variant with 'franchName'
ws_winner_table4a <- ws_winner_table3 %>%
  group_by(franchName) %>%
  summarise(wincount = sum(wincount)) %>%
  arrange(desc(wincount))
ws_winner_table4a
str(ws_winner_table4a)

# add the wincount back into the active_teams list

ws_winner_table5 <- active_teams %>%
  left_join(ws_winner_table4, by = "franchID") %>%
  arrange(desc(wincount)) %>%
  select(franchName, franchID, wincount)
ws_winner_table5
