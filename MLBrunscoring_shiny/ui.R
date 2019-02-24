# Run scoring in Shiny -- ui
#
# written by Martin Monkman
# last update: 2019-02-18
#
# Copyright 2019 Martin Monkman
# license: MIT  https://opensource.org/licenses/MIT
#
#
# resources used & plagarized
#  - RStudio's widget gallery http://shiny.rstudio.com/gallery/widget-gallery.html
#
library(shiny)

shinyUI(navbarPage("MLB run scoring trends",
                   
# -+-+-+-+-+ LEAGUE PLOT
                   
                   tabPanel("league plot",
                            #
                            titlePanel("Per-game run scoring by league"),
                            #
                              includeMarkdown("runscoring_league.Rmd"),
                            #
                            # Sidebar with a dropdown list of ministry names
                            sidebarLayout(
                              
                              sidebarPanel(

                                # slider for year range
                                uiOutput("lg_yearrange"),
                                hr(),
                                # checkbox for league split into facet
                                checkboxInput("leaguesplitselect", label = h4("Plot each league separately"), value = FALSE),
                                hr(),
                                # checkbox for trend line
                                checkboxInput("trendlineselect", label = h4("Add a trend line"), value = FALSE),
                                # slider bar for trend line sensitivity 
                                sliderInput("trendline_sen_sel", 
                                            label = (h5("Select trend line sensitivity")), 
                                            min = 0.05, max = 1, value = 0.50, step = 0.05),
                                hr(),
                                # radio buttons for trend line confidence interval 
                                radioButtons("trendline_conf_sel", 
                                             label = h5("Select trend line confidence level"),
                                             choices = list("0.10" = .1, "0.50" = 0.5,
                                                            "0.90" = 0.9, "0.95" = 0.95,
                                                            "0.99" = 0.99, "0.999" = 0.999, 
                                                            "0.9999" = 0.9999), 
                                             selected = 0.95),
#                                hr(),
#                                column(4, verbatimTextOutput("trendline_conf")),
                                hr()
                              ),
                              # ---- end sidebarPanel
                              # 
                              mainPanel(
                                tags$style(type="text/css",
                                           ".shiny-output-error { visibility: hidden; }",
                                           ".shiny-output-error:before { visibility: hidden; }"),
                                #
                                h4("Runs per game: chart"),
                                plotOutput("plot_MLBtrend"),
                                br(), 
                                h4("Runs per game: data table"),
                                dataTableOutput(outputId="MLBtable")
                                )
                              # ---- end mainPanel
                            )
                            # ---- end sidebarLayout                              
                   ),
                   # ---------- end tabPanel "league plot"


# -+-+-+-+-+ TEAM PLOT


                   tabPanel("team plot",
                            #
                            titlePanel("Per-game runs scored & allowed by team"),
                            #
                            # Sidebar with a dropdown list of ministry names
                            sidebarLayout(
                              
                              sidebarPanel(
                                uiOutput("TeamNameListUI"),
                                hr(),
#                                uiOutput("team_yearrange"),
#                                hr(),
                                # checkbox for trend line
                                checkboxInput("team_trendlineselect", label = h4("Add a trend line"), value = TRUE),
                                # slider bar for trend line sensitivity 
                                sliderInput("team_trendline_sen_sel", 
                                            label = (h5("Select trend line sensitivity")), 
                                            min = 0.05, max = 1, value = .25, step = .05),
                                hr(),
                                # radio buttons for trend line confidence interval 
#                                radioButtons("team_trendline_conf_sel", 
#                                             label = h5("Select trend line confidence level"),
#                                             choices = list("0.10" = .1, "0.50" = 0.5,
#                                                            "0.90" = 0.9, "0.95" = 0.95,
#                                                            "0.99" = 0.99, "0.999" = 0.999, 
#                                                            "0.9999" = 0.9999), 
#                                             selected = 0.10),
#                                hr(),
#                                column(4, verbatimTextOutput("team_trendline_conf")),
                                hr()
                              ),
                              # ---- end team sidebarPanel
                              # 
                              mainPanel(
                                includeMarkdown("runscoring_teamplot.Rmd"),
                                plotOutput("plot_teamTrend"),
                                br(),
                                h4("Runs per game by team: data table"),
                                dataTableOutput(outputId="Team1_data_table"),
                                br()
                                
                                )
                              # ---- end team mainPanel
                            )
                            # ---- end team sidebarLayout                              
                   ),
                   # ---------- end tabPanel "team"

# -+-+-+-+-+ TEAM DATA
                   
                   tabPanel("team data",
                            
                      fluidPage(
                        titlePanel("Runs per game by team: data table"),
                        
                        fluidRow(
                          
                          column(4,
                                 selectInput("tableyearselect",
                                             h5("year:"),
                                             c("All", as.integer(1901:2016)))
                          ),
                          
                          column(4,
                                 selectInput("tableleagueselect",
                                             h5("league:"),
                                             c("All", "AL", "NL"))
                          ),
                          
                          
                          column(4,
                                 selectInput("tableteamselect",
                                             h5("team:"),
                                             c("All", 
                                               "ANA", "ARI", "ATL", "BAL", "BOS",
                                               "CHC", "CHW", "CIN", "CLE", "COL",
                                               "DET", "FLA", "HOU", "KCR", "LAD",
                                               "MIL", "MIN", "NYM", "NYY", "OAK",
                                               "PHI", "PIT", "SDP", "SEA", "SFG",
                                               "STL", "TBD", "TEX", "TOR", "WSN"                                                                                             
                                              ))
                          )

                        ),

                      fluidRow(
                            br(),
                              h4("the data table"),
                              dataTableOutput(outputId="team_data_table"),
                              br()
                            )        
                   )),
                   
                   # ---------- end tabPanel "team data"
                   
 

# -+-+-+-+-+ MORE

                   #
                   navbarMenu("documentation",
                              tabPanel("reference",
                                       fluidRow(
                                         column(12,
                                         includeMarkdown("runscoring_references.Rmd")
                                       ))),
                              tabPanel("documentation",
                                      fluidRow(
                                        column(12,
                                        includeMarkdown("runscoring_documentation.Rmd")
                                      ))),
                              tabPanel("data wrangle update",
                                       fluidRow(
                                         column(12,
                                         includeHTML("runscoring_datawrangle.html")
                                       )))   
                              
                   )
                   # ----- end navbarMenu "More"
))
# ---------- end navbarPage
#  
#  
