library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title="Flic Surveys"),
  dashboardSidebar(
    selectInput("question_id", "Question", "..."),
    actionButton("reload_questions", "Reload Questions", icon=icon("recycle"))
  ),
  dashboardBody(
    plotOutput("responses")
  ),
  title = "Flic Surveys"
)